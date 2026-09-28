import axios from "axios"
import type { AxiosRequestConfig } from "axios"
import { apiOperations } from "@api/generated/operations"
import type {
  ApiOperationRequestData,
  ApiOperationResponseData,
  ApiRoute,
  AuthResponse,
  HttpMethod,
  operations,
} from "@api/generated/types"
import { getApiRoute } from "@api/getApiRoute"

const CSRF_STORAGE_KEY = "csrfToken"
const CSRF_HEADER = "X-CSRF-Token"

type ApiClientOperationId = keyof typeof apiOperations

type ApiClientMethod<TOperationId extends ApiClientOperationId> =
  (typeof apiOperations)[TOperationId]["hasBody"] extends true
  ? (
    data: ApiOperationRequestData<TOperationId>,
    config?: AxiosRequestConfig,
  ) => Promise<ApiOperationResponseData<TOperationId>>
  : (
    config?: AxiosRequestConfig,
  ) => Promise<ApiOperationResponseData<TOperationId>>

type ApiClientMethods = {
  [TOperationId in ApiClientOperationId]: ApiClientMethod<TOperationId>
}

type StartOauthParameters = operations["startOauth"]["parameters"]

type StartOauthProps = {
  provider: StartOauthParameters["path"]["provider"]
  redirect?: NonNullable<StartOauthParameters["query"]>["redirect"]
}

const getStoredCsrfToken = () => sessionStorage.getItem(CSRF_STORAGE_KEY)

const setStoredCsrfToken = (csrfToken: string) => {
  sessionStorage.setItem(CSRF_STORAGE_KEY, csrfToken)
}

const clearStoredCsrfToken = () => {
  sessionStorage.removeItem(CSRF_STORAGE_KEY)
}

const withDefaults = (config?: AxiosRequestConfig) => ({
  ...config,
  withCredentials: config?.withCredentials ?? true,
  headers: {
    Accept: "application/json",
    ...config?.headers,
  },
})

const withCsrfToken = (csrfToken: string, config?: AxiosRequestConfig) =>
  withDefaults({
    ...config,
    headers: {
      ...config?.headers,
      [CSRF_HEADER]: csrfToken,
    },
  })

const request = <TResponseData>(
  route: ApiRoute,
  method: HttpMethod,
  data?: unknown,
  config?: AxiosRequestConfig,
) => {
  const url = getApiRoute(route)

  switch (method) {
    case "delete":
      return axios.delete<TResponseData>(url, withDefaults(config))
    case "get":
      return axios.get<TResponseData>(url, withDefaults(config))
    case "patch":
      return axios.patch<TResponseData>(url, data, withDefaults(config))
    case "post":
      return axios.post<TResponseData>(url, data, withDefaults(config))
    case "put":
      return axios.put<TResponseData>(url, data, withDefaults(config))
  }
}

const refreshSession = async () => {
  const response = await request<AuthResponse>("/auth/session", "get")

  setStoredCsrfToken(response.data.csrfToken)

  return response.data
}

const getCsrfToken = async () => {
  const csrfToken = getStoredCsrfToken()

  if (csrfToken) return csrfToken

  const session = await refreshSession()

  return session.csrfToken
}

const requestOperation = async <TOperationId extends ApiClientOperationId>(
  operationId: TOperationId,
  data: ApiOperationRequestData<TOperationId> | undefined,
  config: AxiosRequestConfig | undefined,
  retry = true,
): Promise<ApiOperationResponseData<TOperationId>> => {
  const metadata = apiOperations[operationId]
  const csrfToken = metadata.requiresCsrf ? await getCsrfToken() : null
  const responseConfig = csrfToken ? withCsrfToken(csrfToken, config) : config

  try {
    const response = await request<ApiOperationResponseData<TOperationId>>(
      metadata.route,
      metadata.method,
      data,
      responseConfig,
    )

    return response.data
  } catch (error) {
    if (
      retry &&
      metadata.requiresCsrf &&
      axios.isAxiosError(error) &&
      error.response?.status === 422
    ) {
      const session = await refreshSession()

      return requestOperation(
        operationId,
        data,
        withCsrfToken(session.csrfToken, config),
        false,
      )
    }

    throw error
  }
}

const createApiClientMethods = () => {
  const methods: Partial<Record<ApiClientOperationId, unknown>> = {}

  for (const operationId of Object.keys(
    apiOperations,
  ) as ApiClientOperationId[]) {
    const metadata = apiOperations[operationId]

    methods[operationId] = (...args: [unknown?, AxiosRequestConfig?]) => {
      if (metadata.hasBody) {
        return requestOperation(operationId, args[0] as never, args[1])
      }

      return requestOperation(
        operationId,
        undefined,
        args[0] as AxiosRequestConfig,
      )
    }
  }

  return methods as ApiClientMethods
}

const startOauth = async ({ provider, redirect }: StartOauthProps) => {
  const csrfToken = await getCsrfToken()
  const url = new URL(getApiRoute(`/auth/oauth/${provider}` as ApiRoute))

  if (redirect) {
    url.searchParams.set("redirect", redirect)
  }

  const form = document.createElement("form")

  form.method = "POST"
  form.action = url.toString()
  form.style.display = "none"

  const csrfInput = document.createElement("input")
  csrfInput.type = "hidden"
  csrfInput.name = "authenticity_token"
  csrfInput.value = csrfToken

  form.append(csrfInput)
  document.body.appendChild(form)
  form.submit()
}

/**
 * Most generated API methods use Axios. Methods like cleanup and startOauth are
 * browser/session helpers and intentionally do not make Axios requests.
 */
export const createApiClient = () => ({
  setup: refreshSession,
  cleanup: clearStoredCsrfToken,
  startOauth,
  ...createApiClientMethods(),
})

export type ApiClient = ReturnType<typeof createApiClient>

export const apiClient = createApiClient()

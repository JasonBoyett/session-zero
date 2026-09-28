import axios from "axios"
import type { AxiosRequestConfig, AxiosResponse } from "axios"
import type {
  ApiMethod,
  ApiRequestData,
  ApiResponseData,
  ApiRoute,
} from "@api/generated/types"
import { getApiRoute } from "@api/getApiRoute"

type BodyMethod = "patch" | "post" | "put"
type ApiClientArgs<
  TRoute extends ApiRoute,
  TMethod extends ApiMethod<TRoute>,
> = TMethod extends BodyMethod
  ? [data: ApiRequestData<TRoute, TMethod>, config?: AxiosRequestConfig]
  : [config?: AxiosRequestConfig]

function withDefaults(config?: AxiosRequestConfig): AxiosRequestConfig {
  return {
    ...config,
    withCredentials: config?.withCredentials ?? true,
    headers: {
      Accept: "application/json",
      ...config?.headers,
    },
  }
}

/**
 * Creates a typed API request function for a generated OpenAPI route and method.
 *
 * @example
 * const response = await apiClient("/auth/session", "post")(
 *   { email, password },
 *   { headers: { "X-CSRF-Token": csrfToken } },
 * )
 *
 * const currentUser = await apiClient("/auth/me", "get")()
 *
 * Routes and allowed methods are derived from `openapi/v1.json` via
 * `client/scripts/generate-api-types.mjs`. That script writes
 * `generated/types.d.ts`, where `ApiRoute` is `keyof paths` and
 * `ApiMethod<TRoute>` is inferred from the HTTP methods available on that
 * route. To add, remove, or rename routes/methods, update the Rails route and
 * Rswag request spec, then run `bin/generate-api`.
 */
export function apiClient<
  TRoute extends ApiRoute,
  TMethod extends ApiMethod<TRoute>,
>(route: TRoute, method: TMethod) {
  const url = getApiRoute(route)

  return (
    ...args: ApiClientArgs<TRoute, TMethod>
  ): Promise<AxiosResponse<ApiResponseData<TRoute, TMethod>>> => {
    switch (method) {
      case "delete": {
        const [config] = args as [AxiosRequestConfig?]

        return axios.delete<ApiResponseData<TRoute, TMethod>>(
          url,
          withDefaults(config),
        )
      }
      case "get": {
        const [config] = args as [AxiosRequestConfig?]

        return axios.get<ApiResponseData<TRoute, TMethod>>(
          url,
          withDefaults(config),
        )
      }
      case "patch": {
        const [data, config] = args as [
          ApiRequestData<TRoute, TMethod>,
          AxiosRequestConfig?,
        ]

        return axios.patch<ApiResponseData<TRoute, TMethod>>(
          url,
          data,
          withDefaults(config),
        )
      }
      case "post": {
        const [data, config] = args as [
          ApiRequestData<TRoute, TMethod>,
          AxiosRequestConfig?,
        ]

        return axios.post<ApiResponseData<TRoute, TMethod>>(
          url,
          data,
          withDefaults(config),
        )
      }
      case "put": {
        const [data, config] = args as [
          ApiRequestData<TRoute, TMethod>,
          AxiosRequestConfig?,
        ]

        return axios.put<ApiResponseData<TRoute, TMethod>>(
          url,
          data,
          withDefaults(config),
        )
      }
    }
  }
}

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import type { ApiClient } from "@api/apiClient"
import { PRODUCTION_PASSWORD_AUTH_REJECTED_MESSAGE } from "@/lib/constants"

export type AuthContext = ReturnType<typeof useAuth>
type UseAuthProps = {
  apiClient: ApiClient
}

type LoginProps = {
  email: string
  password: string
}

type OauthProps = Parameters<ApiClient["startOauth"]>[0]

export const useAuth = ({ apiClient }: UseAuthProps) => {
  const queryClient = useQueryClient()
  const sessionQueryKey = ["session"] as const

  const { data, isLoading, error } = useQuery({
    queryKey: sessionQueryKey,
    queryFn: apiClient.setup,
  })

  const logout = useMutation({
    mutationFn: async () => {
      return apiClient.destroyAuthSession()
    },
    onSuccess: (updatedSession) => {
      apiClient.cleanup()
      queryClient.setQueryData(sessionQueryKey, updatedSession)
    },
  })

  const login = useMutation({
    mutationFn: async (props: LoginProps) => {
      if (import.meta.env.VITE_ENV === "production") {
        throw new Error(PRODUCTION_PASSWORD_AUTH_REJECTED_MESSAGE)
      }
      return apiClient.login(props)
    },
  })

  const oauth = useMutation({
    mutationFn: async (props: OauthProps) => {
      return apiClient.startOauth(props)
    },
  })

  return {
    data,
    logout,
    login,
    oauth,
    isLoading,
    error,
  }
}

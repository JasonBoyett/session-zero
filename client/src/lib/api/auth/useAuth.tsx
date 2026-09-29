import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import type { ApiClient } from "@api/apiClient"
import { useEffect } from "react"
import {
  INDEX_USER_QUERY_KEY,
  PRODUCTION_PASSWORD_AUTH_REJECTED_MESSAGE,
} from "@/lib/constants"

export type AuthContext = ReturnType<typeof useAuth>
type UseAuthProps = {
  apiClient: ApiClient
  onAuthChange?: () => void
}

export type LoginProps = {
  email: string
  password: string
}

type OauthProps = Parameters<ApiClient["startOauth"]>[0]

export const useAuth = ({ apiClient, onAuthChange }: UseAuthProps) => {
  const queryClient = useQueryClient()
  const sessionQueryKey = ["session"] as const

  const refreshAuthState = () => {
    queryClient.invalidateQueries({ queryKey: INDEX_USER_QUERY_KEY })
    onAuthChange?.()
  }

  const { data, isLoading, error } = useQuery({
    queryKey: sessionQueryKey,
    queryFn: apiClient.setup,
  })

  useEffect(() => {
    if (!data) return

    refreshAuthState()
  }, [data?.authenticated, data?.userId])

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
      if (import.meta.env.PROD) {
        throw new Error(PRODUCTION_PASSWORD_AUTH_REJECTED_MESSAGE)
      }
      return apiClient.login(props)
    },
    onSuccess: (updatedSession) => {
      queryClient.setQueryData(sessionQueryKey, updatedSession)
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

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query"
import { destroySession, fetchSession } from "./session"

export type AuthContext = typeof useAuth

export const useAuth = () => {
  const queryClient = useQueryClient()
  const sessionQueryKey = ["session"] as const

  const { data, isLoading, error } = useQuery({
    queryKey: sessionQueryKey,
    queryFn: fetchSession,
  })

  const logout = (cleanup?: () => void) =>
    useMutation({
      mutationFn: async () => {
        const csrfToken = data?.csrfToken

        if (!csrfToken) {
          throw new Error("Cannot log out without a CSRF token")
        }

        return destroySession(csrfToken)
      },
      onSuccess: (updatedSession) => {
        queryClient.setQueryData(sessionQueryKey, updatedSession)
        if (cleanup) cleanup()
      },
    })
  return { data, logout, isLoading, error }
}

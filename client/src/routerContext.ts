import type { ApiClient } from "@api/apiClient"
import type { AuthContext } from "@api/auth/useAuth"

export type RouterContext = {
  apiClient: ApiClient
  auth: AuthContext
}

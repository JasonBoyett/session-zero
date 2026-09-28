import { apiClient } from "../apiClient"
import { STATUS_OK } from "../constants"

export const getCurrentUser = async () => {
  const response = await apiClient("/auth/me", "get")()

  if (response.status !== STATUS_OK)
    throw new Error(
      `An error occurred while getting the current user: ${response.status}`,
    )

  return response.data
}

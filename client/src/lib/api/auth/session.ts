import { apiClient } from "@api/apiClient"
import { STATUS_OK } from "../constants"

export async function fetchSession() {
  const response = await apiClient("/auth/session", "get")()

  if (response.status !== 200)
    throw new Error(
      `An error occurred while fetching the session: ${response.status}`,
    )

  return response.data
}

export async function destroySession(csrfToken: string) {
  const response = await apiClient(
    "/auth/session",
    "delete",
  )({
    headers: {
      "X-CSRF-Token": csrfToken,
    },
  })

  if (response.status !== STATUS_OK)
    throw new Error(`Destroying the session failed: ${response.status}`)

  return response.data
}

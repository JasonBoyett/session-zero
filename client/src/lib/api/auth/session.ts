import { apiClient } from "@api/apiClient"

export async function fetchSession() {
  return apiClient.setup()
}

export async function destroySession() {
  return apiClient.destroyAuthSession()
}

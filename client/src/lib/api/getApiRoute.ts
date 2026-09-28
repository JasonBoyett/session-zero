import type { ApiRoute } from "@api/generated/types"

export function getApiRoute(route: ApiRoute) {
  return new URL(`/api/v1${route}`, import.meta.env.VITE_API_URL).toString()
}

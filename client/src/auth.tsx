import { useAuth } from "./lib/api/auth/useAuth"
import { RouterProvider } from "@tanstack/react-router"
import type { ApiClient } from "@api/apiClient"
import type { ContextRouter } from "./router"

type ApiClientRouterProps = {
  apiClient: ApiClient
  router: ContextRouter
}

export const ApiClientRouter = ({ apiClient, router }: ApiClientRouterProps) => {
  const auth = useAuth({ apiClient })

  return <RouterProvider router={router} context={{ apiClient, auth }} />
}

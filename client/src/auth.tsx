import { useAuth } from "./lib/api/auth/useAuth"
import { RouterProvider } from "@tanstack/react-router"
import type { ContextRouter } from "./router"

export const AuthenticatedRouter = ({ router }: { router: ContextRouter }) => (
  <RouterProvider router={router} context={{ auth: useAuth() }} />
)

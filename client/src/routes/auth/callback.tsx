import { useEffect } from "react"
import { createFileRoute } from "@tanstack/react-router"

export const Route = createFileRoute("/auth/callback")({
  component: AuthCallback,
  validateSearch: (search: Record<string, unknown>) => ({
    error: typeof search.error === "string" ? search.error : undefined,
  }),
})

function AuthCallback() {
  const { auth } = Route.useRouteContext()
  const { error } = Route.useSearch()
  const navigate = Route.useNavigate()

  useEffect(() => {
    if (!auth.data || error) return

    void navigate({ to: "/" })
  }, [auth.data, error, navigate])

  if (error) {
    return (
      <main className="p-8">
        <h1 className="text-2xl font-bold">Could not sign in</h1>
        <p className="mt-2 text-red-600">OAuth failed: {error}</p>
      </main>
    )
  }

  return (
    <main className="p-8">
      <h1 className="text-2xl font-bold">Completing sign in...</h1>
    </main>
  )
}

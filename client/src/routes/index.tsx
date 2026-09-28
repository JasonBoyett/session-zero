import { INDEX_USER_QUERY_KEY } from "@/lib/constants"
import { useQuery } from "@tanstack/react-query"
import { createFileRoute } from "@tanstack/react-router"

export const Route = createFileRoute('/')({
  component: Home,
})

function Home() {
  const context = Route.useRouteContext()
  const user = useQuery({
    queryKey: INDEX_USER_QUERY_KEY,
    queryFn: () => context.apiClient.getCurrentUser(),
    enabled: context.auth.data?.authenticated ?? false,
  })

  return (
    <div className="p-8">
      <h1 className="text-4xl font-bold">Welcome to TanStack Start</h1>
      <p className="mt-4 text-lg">
        <button onClick={() => context.auth.oauth.mutate({ provider: "discord" })}>
          Continue with Discord
        </button>
        {context.auth.data?.authenticated ? (
          <h1>Hello {user.data?.name || "User"}!</h1>
        ) : (
          <h1>You are not logged in.</h1>
        )}
      </p>
    </div>
  )
}

import { INDEX_USER_QUERY_KEY } from "@/lib/constants"
import { useQuery } from "@tanstack/react-query"
import { createFileRoute, useNavigate } from "@tanstack/react-router"
import React from "react"

export const Route = createFileRoute("/")({
  component: Home,
})

function Home() {
  const context = Route.useRouteContext()
  const navigate = useNavigate()
  const isAuthenticated = context.auth.data?.authenticated ?? false
  const user = useQuery({
    queryKey: [...INDEX_USER_QUERY_KEY, context.auth.data?.userId],
    queryFn: () => context.apiClient.getCurrentUser(),
    enabled: isAuthenticated,
  })
  const login = (email: string, password: string) =>
    context.auth.login.mutate(
      { email, password },
      {
        onSuccess: () => user.refetch(),
      },
    )

  const [email, setEmail] = React.useState("")
  const [password, setPassword] = React.useState("")
  const loginError = context.auth.login.error

  return (
    <div className="p-8">
      <h1 className="text-4xl font-bold">
        {isAuthenticated
          ? `Welcome back, ${user.data?.name ?? "..."}!`
          : "Welcome to Session Zero!"}
      </h1>
      <div className="mt-4 text-lg">
        <form
          className="flex flex-col gap-4"
          onSubmit={(e) => {
            e.preventDefault()
            login(email, password)
          }}
        >
          <label className="text-sm" htmlFor="email">
            Email
          </label>
          <input
            className="rounded-md border-2 border-gray-300 p-2"
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <label className="text-sm" htmlFor="password">
            Password
          </label>
          <input
            className="rounded-md border-2 border-gray-300 p-2"
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <button
            className="rounded-md bg-blue-500 px-4 py-2 text-white"
            disabled={context.auth.login.isPending}
            type="submit"
          >
            {context.auth.login.isPending ? "Logging in..." : "Login"}
          </button>
          {isAuthenticated ? (
            <div className="flex flex-row gap-2">
              <button
                type="button"
                className="rounded-md bg-blue-500 px-4 py-2 text-white"
                disabled={context.auth.login.isPending}
                onClick={() => context.auth.logout.mutate()}
              >
                Log Out
              </button>

              <button
                type="button"
                onClick={() => {
                  navigate({ to: "/user" })
                }}
                className="rounded-md bg-blue-500 px-4 py-2 text-white"
              >
                Go to User Page
              </button>
            </div>
          ) : (
            <>
              <button
                type="button"
                className="rounded-md bg-blue-500 px-4 py-2 text-white"
                onClick={() => {
                  context.apiClient.startOauth({ provider: "discord" })
                }}
              >
                Login With Discord
              </button>
            </>
          )}
          {loginError ? (
            <p className="text-sm text-red-600">Invalid email or password.</p>
          ) : null}
        </form>
      </div>
    </div>
  )
}

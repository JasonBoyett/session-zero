import { USER_USER_PAGE_KEY } from "@/lib/constants"
import { useQuery } from "@tanstack/react-query"
import { createFileRoute } from "@tanstack/react-router"
import React from "react"

export const Route = createFileRoute("/user/")({
  component: RouteComponent,
})

function RouteComponent() {
  const context = Route.useRouteContext()

  const user = useQuery({
    queryKey: USER_USER_PAGE_KEY,
    queryFn: () => context.apiClient.getCurrentUser(),
  })

  const [name, setName] = React.useState("")

  return (
    <main className="flex min-h-screen justify-center bg-gray-50 px-4 py-16">
      <div className="w-full max-w-xl">
        <div className="mb-8">
          <h1 className="text-3xl font-bold tracking-tight text-gray-900">
            Welcome back, {user.data?.name}!
          </h1>
          <p className="mt-2 text-gray-500">
            Manage your Session Zero profile.
          </p>
        </div>

        <div className="rounded-xl border border-gray-200 bg-white shadow-sm">
          <div className="border-b border-gray-200 px-6 py-5">
            <h2 className="text-lg font-semibold text-gray-900">Profile</h2>
            <p className="mt-1 text-sm text-gray-500">
              Update how your name appears to other players.
            </p>
          </div>

          <form
            className="space-y-6 p-6"
            onSubmit={async (e) => {
              e.preventDefault()

              await context.apiClient.updateCurrentUser({ name })
              await user.refetch()
            }}
          >
            <div className="space-y-2">
              <label
                htmlFor="name"
                className="block text-sm font-medium text-gray-700"
              >
                Display name
              </label>

              <input
                type="text"
                id="name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="
                  w-full rounded-lg border border-gray-300
                  px-3 py-2 text-gray-900 shadow-sm
                  outline-none transition
                  placeholder:text-gray-400
                  focus:border-blue-500 focus:ring-2 focus:ring-blue-500/20
                "
              />
            </div>

            <div className="flex justify-end">
              <button
                type="submit"
                disabled={name === user.data?.name || !name.trim()}
                className="
                  rounded-lg bg-blue-600 px-4 py-2
                  text-sm font-medium text-white
                  transition
                  hover:bg-blue-700
                  focus:outline-none focus:ring-2
                  focus:ring-blue-500 focus:ring-offset-2
                  disabled:cursor-not-allowed disabled:opacity-50
                "
              >
                Save changes
              </button>
            </div>
          </form>
        </div>
      </div>
    </main>
  )
}

import { Outlet, createRootRouteWithContext } from "@tanstack/react-router"

import { TanStackRouterDevtoolsPanel } from "@tanstack/react-router-devtools"
import { TanStackDevtools } from "@tanstack/react-devtools"
import type { RouterContext } from "../routerContext"

import "../styles.css"

export const Route = createRootRouteWithContext<RouterContext>()({
  component: RootComponent,
  notFoundComponent: NotFoundComponent,
})

function RootComponent() {
  return (
    <>
      <Outlet />
      <TanStackDevtools
        config={{
          position: "bottom-right",
        }}
        plugins={[
          {
            name: "TanStack Router",
            render: <TanStackRouterDevtoolsPanel />,
          },
        ]}
      />
    </>
  )
}

function NotFoundComponent() {
  return (
    <main className="p-8">
      <h1 className="text-2xl font-bold">Not found</h1>
      <p className="mt-2 text-gray-600">That page does not exist.</p>
    </main>
  )
}

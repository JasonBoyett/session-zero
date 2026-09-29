import { useEffect } from "react"
import ReactDOM from "react-dom/client"
import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { ApiClientRouter } from "./auth"
import { getRouter } from "./router"
import { createApiClient } from "./lib/api/apiClient"

const queryClient = new QueryClient()
const router = getRouter()
const apiClient = createApiClient()

const syncSystemTheme = () => {
  document.documentElement.classList.toggle(
    "dark",
    window.matchMedia("(prefers-color-scheme: dark)").matches,
  )
}

const App = () => {
  useEffect(() => {
    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")

    syncSystemTheme()
    mediaQuery.addEventListener("change", syncSystemTheme)

    return () => mediaQuery.removeEventListener("change", syncSystemTheme)
  }, [])

  return (
    <QueryClientProvider client={queryClient}>
      <ApiClientRouter router={router} apiClient={apiClient} />
    </QueryClientProvider>
  )
}

declare module "@tanstack/react-router" {
  interface Register {
    router: typeof router
  }
}

const rootElement = document.getElementById("app")!

if (!rootElement.innerHTML) {
  syncSystemTheme()
  const root = ReactDOM.createRoot(rootElement)
  root.render(<App />)
}

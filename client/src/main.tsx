import ReactDOM from "react-dom/client"
import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { ApiClientRouter } from "./auth"
import { getRouter } from "./router"
import { createApiClient } from "./lib/api/apiClient"

const queryClient = new QueryClient()
const router = getRouter()
const apiClient = createApiClient()

const App = () => {
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
  const root = ReactDOM.createRoot(rootElement)
  root.render(<App />)
}

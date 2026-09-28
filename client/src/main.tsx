import ReactDOM from "react-dom/client"
import { QueryClient, QueryClientProvider } from "@tanstack/react-query"
import { AuthenticatedRouter } from "./auth"
import { getRouter } from "./router"

const queryClient = new QueryClient()
const router = getRouter()

const App = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthenticatedRouter router={router} />
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

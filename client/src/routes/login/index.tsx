import { Page } from "@/components/custom/page"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { isProduction } from "@/lib/constants"
import { createFileRoute, redirect, useNavigate } from "@tanstack/react-router"
import { useState } from "react"

export const Route = createFileRoute("/login/")({
  beforeLoad: () => {
    if (isProduction) {
      throw redirect({ to: "/" })
    }
  },
  component: Login,
})

function Login() {
  const context = Route.useRouteContext()
  const navigate = useNavigate()
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const isAuthenticated = context.auth.data?.authenticated ?? false
  const loginError = context.auth.login.error

  return (
    <Page>
      <div className="flex min-h-[calc(100vh-4rem)] items-center justify-center">
        <Card className="w-full max-w-md">
          <CardHeader>
            <CardTitle className="text-2xl">Development Login</CardTitle>
            <CardDescription>
              Sign in with a local email and password while developing.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form
              className="flex flex-col gap-4"
              onSubmit={(event) => {
                event.preventDefault()
                context.auth.login.mutate(
                  { email, password },
                  {
                    onSuccess: () => {
                      navigate({ to: "/" })
                    },
                  },
                )
              }}
            >
              <label
                className="flex flex-col gap-2 text-sm font-medium"
                htmlFor="email"
              >
                Email
                <input
                  className="rounded-md border border-input bg-background px-3 py-2 text-base text-foreground shadow-xs outline-none transition-colors placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50"
                  id="email"
                  type="email"
                  value={email}
                  onChange={(event) => setEmail(event.target.value)}
                />
              </label>

              <label
                className="flex flex-col gap-2 text-sm font-medium"
                htmlFor="password"
              >
                Password
                <input
                  className="rounded-md border border-input bg-background px-3 py-2 text-base text-foreground shadow-xs outline-none transition-colors placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50"
                  id="password"
                  type="password"
                  value={password}
                  onChange={(event) => setPassword(event.target.value)}
                />
              </label>

              {loginError ? (
                <p className="text-sm text-destructive">
                  Invalid email or password.
                </p>
              ) : null}

              <Button disabled={context.auth.login.isPending} type="submit">
                {context.auth.login.isPending ? "Logging in..." : "Log In"}
              </Button>

              <Button
                type="button"
                variant="outline"
                disabled={!isAuthenticated || context.auth.logout.isPending}
                onClick={() => context.auth.logout.mutate()}
              >
                {context.auth.logout.isPending ? "Logging out..." : "Log Out"}
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
    </Page>
  )
}

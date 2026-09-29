import { Page } from "@/components/custom/page"
import {
  isProduction,
  WELCOME_PAGE_TEXT_1,
  WELCOME_PAGE_TEXT_2,
} from "@/lib/constants"
import { createFileRoute } from "@tanstack/react-router"
import { Header } from "@/components/custom/header"
import { NavButton } from "@/components/custom/navButton"
import { NavCluster } from "@/components/custom/homePage/navCluster"
import { SZLogo } from "@/components/custom/sz-logo"
import { DiscordLoginButton } from "@/components/custom/discord-login-button"

export const Route = createFileRoute("/")({
  component: Home,
})

function Home() {
  const context = Route.useRouteContext()
  const isAuthenticated = context.auth.data?.authenticated ?? false
  return (
    <Page>
      <div className="relative flex min-h-[calc(100vh-4rem)] items-center justify-center overflow-hidden rounded-3xl px-6 py-20 text-card-foreground">
        <div className="relative flex max-w-4xl flex-col items-center gap-8 text-center">
          <SZLogo className="size-56" />
          <Header>Welcome to Session Zero</Header>
          <div className="space-y-3 text-balance text-2xl leading-tight text-muted-foreground md:text-3xl">
            <p>{WELCOME_PAGE_TEXT_1}</p>
            <p>{WELCOME_PAGE_TEXT_2}</p>
          </div>
          {isAuthenticated ? (
            <div className="w-full">
              <NavCluster />
            </div>
          ) : (
            <div className="w-full max-w-sm">
              <DiscordLoginButton
                oauthInit={() =>
                  context.apiClient.startOauth({ provider: "discord" })
                }
              />
            </div>
          )}

          {!isProduction ? (
            <NavButton navOptions={{ to: "/login" }}>
              Development Login
            </NavButton>
          ) : null}
        </div>
      </div>
    </Page>
  )
}

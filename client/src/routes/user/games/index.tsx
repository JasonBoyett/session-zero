import { Page } from "@/components/custom/page"
import {
  Card,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import { EmptyGamesState } from "@/components/user/games/empty-games-state"
import { EmptySection } from "@/components/user/games/empty-section"
import { GameMasterGameView } from "@/components/user/games/game-master-game-view"
import { GamesPageSkeleton } from "@/components/user/games/games-page-skeleton"
import { PlayerGameView } from "@/components/user/games/player-game-view"
import { ProfileHeader } from "@/components/user/games/profile-header"
import { SectionHeading } from "@/components/user/games/section-heading"
import {
  USER_GAMES_EMPTY_GM_SECTION_MESSAGE,
  USER_GAMES_EMPTY_PLAYER_SECTION_MESSAGE,
  USER_GAMES_GAME_PLURAL,
  USER_GAMES_GAME_SINGULAR,
  USER_GAMES_GM_GAMES_TITLE,
  USER_GAMES_LOAD_ERROR_DESCRIPTION,
  USER_GAMES_LOAD_ERROR_TITLE,
  USER_GAMES_PAGE_KEY,
  USER_GAMES_PAGE_TITLE,
  USER_GAMES_PLAYER_GAMES_TITLE,
} from "@/lib/constants"
import { useQuery } from "@tanstack/react-query"
import { createFileRoute } from "@tanstack/react-router"

export const Route = createFileRoute("/user/games/")({
  component: RouteComponent,
})

function RouteComponent() {
  const context = Route.useRouteContext()
  const games = useQuery({
    queryKey: USER_GAMES_PAGE_KEY,
    queryFn: async () => context.apiClient.getCurrentUserGames(),
  })

  const gmGameCount =
    games.data?.gmIdentities.reduce(
      (count, identity) => count + identity.games.length,
      0,
    ) ?? 0
  const playerGameCount = games.data?.gamesAsPlayer.length ?? 0
  const hasGames = gmGameCount > 0 || playerGameCount > 0

  return (
    <Page>
      <main className="mx-auto flex w-full max-w-6xl flex-1 flex-col gap-8 py-8">
        <header className="flex flex-col gap-6 border-b pb-8 lg:flex-row lg:items-end lg:justify-between">
          <div className="max-w-2xl space-y-3">
            <div className="space-y-2">
              <h1 className="font-heading text-4xl font-semibold tracking-tight text-foreground md:text-5xl">
                {USER_GAMES_PAGE_TITLE}
              </h1>
            </div>
          </div>
        </header>

        {games.isPending ? <GamesPageSkeleton /> : null}

        {games.isError ? (
          <Card className="border-destructive/30 bg-destructive/5">
            <CardHeader>
              <CardTitle>{USER_GAMES_LOAD_ERROR_TITLE}</CardTitle>
              <CardDescription>
                {USER_GAMES_LOAD_ERROR_DESCRIPTION}
              </CardDescription>
            </CardHeader>
          </Card>
        ) : null}

        {games.isSuccess && !hasGames ? <EmptyGamesState /> : null}

        {games.isSuccess && hasGames ? (
          <div className="grid min-w-0 gap-10">
            <section className="min-w-0 space-y-5">
              <SectionHeading title={USER_GAMES_GM_GAMES_TITLE} />

              {games.data.gmIdentities.length > 0 ? (
                <div className="grid min-w-0 gap-8">
                  {games.data.gmIdentities.map((identity) => (
                    <section className="min-w-0 space-y-4" key={identity.id}>
                      <ProfileHeader
                        displayName={identity.displayName}
                        profilePicture={identity.profilePicture}
                        meta={`${identity.games.length} ${
                          identity.games.length === 1
                            ? USER_GAMES_GAME_SINGULAR
                            : USER_GAMES_GAME_PLURAL
                        }`}
                      />

                      <div
                        className="gm-games-row flex w-full min-w-0 snap-x gap-4 overflow-x-auto overscroll-x-contain pb-3"
                        data-gm-games-row
                      >
                        {identity.games.map((game) => (
                          <GameMasterGameView key={game.id} game={game} />
                        ))}
                      </div>
                    </section>
                  ))}
                </div>
              ) : (
                <EmptySection message={USER_GAMES_EMPTY_GM_SECTION_MESSAGE} />
              )}
            </section>

            <section className="space-y-5">
              <SectionHeading title={USER_GAMES_PLAYER_GAMES_TITLE} />

              {games.data.gamesAsPlayer.length > 0 ? (
                <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
                  {games.data.gamesAsPlayer.map((game) => (
                    <PlayerGameView
                      key={`${game.playerProfile.id}-${game.id}`}
                      game={game}
                    />
                  ))}
                </div>
              ) : (
                <EmptySection
                  message={USER_GAMES_EMPTY_PLAYER_SECTION_MESSAGE}
                />
              )}
            </section>
          </div>
        ) : null}
      </main>
    </Page>
  )
}

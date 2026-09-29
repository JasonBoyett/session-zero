import type {
  GameSummaryAsGm,
  GameSummaryAsPlayer,
} from "@/lib/api/generated/types"
import { USER_GAMES_PAGE_KEY } from "@/lib/constants"
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

  return (
    <div>
      <section>
        <h1>Game Masters</h1>
        {games.data?.gmIdentities.map((identity) => (
          <section key={identity.id}>
            <h2>{identity.displayName}</h2>
            {identity.games.map((game) => (
              <GameMasterGameView key={game.id} game={game} />
            ))}
          </section>
        ))}
      </section>

      <section>
        <h1>Players</h1>
        {games.data?.gamesAsPlayer.map((game) => (
          <section key={`${game.playerProfile.id}-${game.id}`}>
            <h2>{game.playerProfile.displayName}</h2>
            <PlayerGameView game={game} />
          </section>
        ))}
      </section>
    </div>
  )
}

const GameMasterGameView = ({ game }: { game: GameSummaryAsGm }) => {
  return (
    <article>
      <h3>{game.name}</h3>
      <p>{game.description}</p>
      <p>{game.playerCount} players</p>
    </article>
  )
}

const PlayerGameView = ({ game }: { game: GameSummaryAsPlayer }) => {
  return (
    <article>
      <h3>{game.name}</h3>
      <p>{game.description}</p>
      <p>{game.playerCount} players</p>
      <p>GM: {game.gmProfile.displayName}</p>
    </article>
  )
}

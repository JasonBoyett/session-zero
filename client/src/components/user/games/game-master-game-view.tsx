import { GameCard } from "@/components/user/games/game-card"
import type { GamesIndexGameAsGm } from "@/lib/api/generated/types"

export const GameMasterGameView = ({
  game,
}: {
  game: GamesIndexGameAsGm
}) => {
  return (
    <div className="w-[min(20rem,85vw)] shrink-0 snap-start">
      <GameCard game={game} />
    </div>
  )
}

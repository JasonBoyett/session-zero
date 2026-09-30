import { GameCard } from "@/components/user/games/game-card"
import {
  ProfileAvatar,
  displayName,
} from "@/components/user/games/profile-avatar"
import type { GamesIndexGameAsPlayer } from "@/lib/api/generated/types"
import {
  USER_GAMES_GM_LABEL,
  USER_GAMES_PLAYING_AS_LABEL,
} from "@/lib/constants"

export const PlayerGameView = ({
  game,
}: {
  game: GamesIndexGameAsPlayer
}) => {
  return (
    <GameCard
      game={game}
      footer={
        <div className="flex min-w-0 items-center gap-2">
          <ProfileAvatar
            displayName={game.gmProfile.displayName}
            profilePicture={game.gmProfile.profilePicture}
          />
          <div className="min-w-0 text-sm">
            <p className="truncate font-medium text-foreground">
              {displayName(game.gmProfile.displayName)}
            </p>
            <p className="text-xs text-muted-foreground">
              {USER_GAMES_GM_LABEL}
            </p>
          </div>
        </div>
      }
      profileContext={
        <div className="flex min-w-0 items-center gap-2">
          <ProfileAvatar
            displayName={game.playerProfile.displayName}
            profilePicture={game.playerProfile.profilePicture}
            size="sm"
          />
          <span className="truncate">
            {USER_GAMES_PLAYING_AS_LABEL}{" "}
            {displayName(game.playerProfile.displayName)}
          </span>
        </div>
      }
    />
  )
}

import { Badge } from "@/components/ui/badge"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import type { GamesIndexGameAsGm } from "@/lib/api/generated/types"
import {
  USER_GAMES_NO_DESCRIPTION_FALLBACK,
  USER_GAMES_UNTITLED_GAME_FALLBACK,
} from "@/lib/constants"
import { Users } from "lucide-react"

export const GameCard = ({
  game,
  profileContext,
  footer,
}: {
  game: GamesIndexGameAsGm
  profileContext?: React.ReactNode
  footer?: React.ReactNode
}) => {
  return (
    <Card className="min-h-56 transition-colors hover:bg-muted/30">
      <CardHeader>
        <div className="flex items-start justify-between gap-4">
          <div className="min-w-0 space-y-2">
            {profileContext ? (
              <div className="min-w-0 text-xs font-medium text-muted-foreground">
                {profileContext}
              </div>
            ) : null}
            <CardTitle className="line-clamp-2 text-xl">
              {game.name ?? USER_GAMES_UNTITLED_GAME_FALLBACK}
            </CardTitle>
          </div>
          <Badge className="gap-1.5" variant="outline">
            <Users className="size-3" />
            {game.playerCount}
          </Badge>
        </div>
        <CardDescription className="line-clamp-4 leading-6">
          {game.description ?? USER_GAMES_NO_DESCRIPTION_FALLBACK}
        </CardDescription>
      </CardHeader>
      {footer ? (
        <CardContent className="mt-auto border-t pt-4">{footer}</CardContent>
      ) : null}
    </Card>
  )
}

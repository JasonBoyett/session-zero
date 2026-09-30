import {
  Card,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  USER_GAMES_EMPTY_STATE_DESCRIPTION,
  USER_GAMES_EMPTY_STATE_TITLE,
} from "@/lib/constants"
import { ScrollText } from "lucide-react"

export const EmptyGamesState = () => {
  return (
    <Card className="mx-auto w-full max-w-xl text-center">
      <CardHeader>
        <div className="mx-auto flex size-12 items-center justify-center rounded-xl bg-muted text-muted-foreground">
          <ScrollText className="size-5" />
        </div>
        <CardTitle>{USER_GAMES_EMPTY_STATE_TITLE}</CardTitle>
        <CardDescription>{USER_GAMES_EMPTY_STATE_DESCRIPTION}</CardDescription>
      </CardHeader>
    </Card>
  )
}

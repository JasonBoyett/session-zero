import {
  Card,
  CardAction,
  CardDescription,
  CardTitle,
} from "@/components/ui/card"
import {
  HOME_GAMES_NAV_BUTTON_TEXT,
  HOME_NAV_CARD_DESCRIPTION_TEXT,
  HOME_NAV_CARD_TITLE,
  HOME_PROFILE_NAV_BUTTON_TEXT,
} from "@/lib/constants"
import { NavButton } from "../navButton"

export const NavCluster = () => {
  return (
    <Card className="mb-6">
      <CardTitle className="text-3xl">{HOME_NAV_CARD_TITLE}</CardTitle>
      <CardDescription className="text-xl">
        <p>{HOME_NAV_CARD_DESCRIPTION_TEXT}</p>
      </CardDescription>
      <CardAction className="flex flex-row gap-2 p-4">
        <NavButton navOptions={{ to: "/" }}>
          <p> {HOME_GAMES_NAV_BUTTON_TEXT} </p>
        </NavButton>
        <NavButton navOptions={{ to: "/user" }}>
          <p> {HOME_PROFILE_NAV_BUTTON_TEXT}</p>
        </NavButton>
      </CardAction>
    </Card>
  )
}

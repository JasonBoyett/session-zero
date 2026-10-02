import { ProfileField } from "@/components/profile/profile-field"
import { ProfileTitle } from "@/components/profile/profile-title"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import {
  PROFILE_ACCEPTED_LABEL,
  PROFILE_CHARACTER_DESCRIPTION_LABEL,
  PROFILE_CHARACTER_SHEET_LABEL,
  PROFILE_EMPTY_VALUE,
  PROFILE_PENDING_LABEL,
  PROFILE_PLAYER_FALLBACK_NAME,
} from "@/lib/constants"
import type { PlayerProfileResponse } from "@/lib/api/generated/types"

export const PlayerProfilePage = ({
  profile,
}: {
  profile: PlayerProfileResponse
}) => {
  return (
    <Card className="w-full">
      <CardHeader>
        <ProfileTitle
          name={profile.characterName ?? PROFILE_PLAYER_FALLBACK_NAME}
          profilePicture={profile.characterImage}
        />
      </CardHeader>
      <CardContent className="space-y-5">
        <Badge variant={profile.isAccepted ? "default" : "secondary"}>
          {profile.isAccepted ? PROFILE_ACCEPTED_LABEL : PROFILE_PENDING_LABEL}
        </Badge>
        <ProfileField
          label={PROFILE_CHARACTER_DESCRIPTION_LABEL}
          value={profile.characterDescription ?? PROFILE_EMPTY_VALUE}
        />
        <ProfileField
          label={PROFILE_CHARACTER_SHEET_LABEL}
          value={profile.characterSheetLink ?? PROFILE_EMPTY_VALUE}
        />
      </CardContent>
    </Card>
  )
}

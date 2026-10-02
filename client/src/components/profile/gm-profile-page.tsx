import { Card, CardContent, CardHeader } from "@/components/ui/card"
import { ProfileField } from "@/components/profile/profile-field"
import { ProfileTitle } from "@/components/profile/profile-title"
import {
  PROFILE_BIO_LABEL,
  PROFILE_EMPTY_VALUE,
  PROFILE_GM_FALLBACK_NAME,
  PROFILE_SYSTEMS_LABEL,
} from "@/lib/constants"
import type { GmProfileResponse } from "@/lib/api/generated/types"

export const GmProfilePage = ({
  profile,
}: {
  profile: GmProfileResponse
}) => {
  return (
    <Card className="w-full">
      <CardHeader>
        <ProfileTitle
          name={profile.name ?? PROFILE_GM_FALLBACK_NAME}
          profilePicture={profile.profilePicture}
        />
      </CardHeader>
      <CardContent className="space-y-5">
        <ProfileField
          label={PROFILE_BIO_LABEL}
          value={profile.bio ?? PROFILE_EMPTY_VALUE}
        />
        <ProfileField
          label={PROFILE_SYSTEMS_LABEL}
          value={
            profile.systems.length > 0
              ? profile.systems.join(", ")
              : PROFILE_EMPTY_VALUE
          }
        />
      </CardContent>
    </Card>
  )
}

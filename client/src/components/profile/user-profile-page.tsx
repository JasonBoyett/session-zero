import { ProfileField } from "@/components/profile/profile-field"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Card, CardContent, CardHeader } from "@/components/ui/card"
import {
  PROFILE_ACCOUNT_DETAILS_TITLE,
  PROFILE_EMAIL_LABEL,
  PROFILE_EMPTY_VALUE,
  PROFILE_GM_PROFILES_LABEL,
  PROFILE_JOINED_LABEL,
  PROFILE_LAST_UPDATED_LABEL,
  PROFILE_LINKED_PROFILES_TITLE,
  PROFILE_PLAYER_PROFILES_LABEL,
  PROFILE_USER_FALLBACK_NAME,
} from "@/lib/constants"
import type { UserProfilePageResponse } from "@/lib/api/generated/types"

const dateFormatter = new Intl.DateTimeFormat(undefined, {
  dateStyle: "medium",
})

export const UserProfilePage = ({
  profile,
}: {
  profile: UserProfilePageResponse
}) => {
  const userInfo = profile.userInfo
  const name = userInfo.name ?? PROFILE_USER_FALLBACK_NAME

  return (
    <div className="w-full space-y-8">
      <header className="flex flex-col gap-6 border-b pb-8 sm:flex-row sm:items-end sm:justify-between">
        <div className="flex min-w-0 items-center gap-5">
          <Avatar className="size-20" size="lg">
            {userInfo.profilePicture ? (
              <AvatarImage alt="" src={userInfo.profilePicture} />
            ) : null}
            <AvatarFallback className="text-xl">
              {initialsFor(name)}
            </AvatarFallback>
          </Avatar>
          <div className="min-w-0">
            <h1 className="truncate font-heading text-4xl font-semibold tracking-tight text-foreground md:text-5xl">
              {name}
            </h1>
          </div>
        </div>
      </header>

      <section className="grid gap-4">
        <Card className="w-full">
          <CardHeader>
            <h2 className="text-xl font-semibold tracking-tight text-foreground">
              {PROFILE_ACCOUNT_DETAILS_TITLE}
            </h2>
          </CardHeader>
          <CardContent className="grid gap-5 sm:grid-cols-2">
            <ProfileField
              label={PROFILE_EMAIL_LABEL}
              value={userInfo.email ?? PROFILE_EMPTY_VALUE}
            />
            <ProfileField
              label={PROFILE_JOINED_LABEL}
              value={formatDate(userInfo.createdAt)}
            />
            <ProfileField
              label={PROFILE_LAST_UPDATED_LABEL}
              value={formatDate(userInfo.updatedAt)}
            />
          </CardContent>
        </Card>

        <Card className="w-full">
          <CardHeader>
            <h2 className="text-xl font-semibold tracking-tight text-foreground">
              {PROFILE_LINKED_PROFILES_TITLE}
            </h2>
          </CardHeader>
          <CardContent className="grid gap-5 sm:grid-cols-2">
            <ProfileField
              label={PROFILE_GM_PROFILES_LABEL}
              value={String(profile.gmProfiles.length)}
            />
            <ProfileField
              label={PROFILE_PLAYER_PROFILES_LABEL}
              value={String(profile.playerProfiles.length)}
            />
          </CardContent>
        </Card>
      </section>
    </div>
  )
}

const formatDate = (date: string | undefined) =>
  date ? dateFormatter.format(new Date(date)) : PROFILE_EMPTY_VALUE

const initialsFor = (name: string) =>
  name
    .split(/\s+/)
    .slice(0, 2)
    .map((word) => word[0])
    .join("")
    .toUpperCase()

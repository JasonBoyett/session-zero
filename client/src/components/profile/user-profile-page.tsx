import { ProfileField } from "@/components/profile/profile-field"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent } from "@/components/ui/card"
import {
  PROFILE_ACCOUNT_DETAILS_TITLE,
  PROFILE_ACCEPTED_LABEL,
  PROFILE_BIO_LABEL,
  PROFILE_CHARACTER_DESCRIPTION_LABEL,
  PROFILE_EMAIL_LABEL,
  PROFILE_EMPTY_VALUE,
  PROFILE_GM_PROFILES_LABEL,
  PROFILE_JOINED_LABEL,
  PROFILE_LAST_UPDATED_LABEL,
  PROFILE_LINKED_PROFILES_TITLE,
  PROFILE_NO_GM_PROFILES_MESSAGE,
  PROFILE_NO_PLAYER_PROFILES_MESSAGE,
  PROFILE_PENDING_LABEL,
  PROFILE_PLAYER_PROFILES_LABEL,
  PROFILE_USER_FALLBACK_NAME,
  PROFILE_GM_FALLBACK_NAME,
  PROFILE_PLAYER_FALLBACK_NAME,
  PROFILE_SYSTEMS_LABEL,
} from "@/lib/constants"
import type {
  GmProfileResponse,
  PlayerProfileResponse,
  UserProfilePageResponse,
} from "@/lib/api/generated/types"
import { Link } from "@tanstack/react-router"

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
    <div className="grid w-full gap-8 lg:grid-cols-[18rem_1fr] lg:items-start">
      <aside className="space-y-7 px-1 py-2 lg:sticky lg:top-8 lg:border-r lg:border-border/40 lg:pr-8">
        <header className="space-y-5 border-b border-border/40 pb-6">
          <Avatar size="profile">
            {userInfo.profilePicture ? (
              <AvatarImage alt="" src={userInfo.profilePicture} />
            ) : null}
            <AvatarFallback>{initialsFor(name)}</AvatarFallback>
          </Avatar>
          <h1 className="break-words font-heading text-3xl font-semibold tracking-tight text-foreground">
            {name}
          </h1>
        </header>

        <section className="space-y-5">
          <h2 className="text-xl font-semibold tracking-tight text-foreground">
            {PROFILE_ACCOUNT_DETAILS_TITLE}
          </h2>
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
        </section>
      </aside>

      <main className="min-w-0">
        <section className="space-y-6">
          <h2 className="text-xl font-semibold tracking-tight text-foreground">
            {PROFILE_LINKED_PROFILES_TITLE}
          </h2>

          <GmProfileSection profiles={profile.gmProfiles} />

          <PlayerProfileSection profiles={profile.playerProfiles} />
        </section>
      </main>
    </div>
  )
}

const GmProfileSection = ({ profiles }: { profiles: GmProfileResponse[] }) => {
  return (
    <section className="space-y-3">
      <div className="flex items-center justify-between gap-4 border-b pb-2">
        <h3 className="text-base font-medium text-foreground">
          {PROFILE_GM_PROFILES_LABEL}
        </h3>
        <Badge variant="outline">{profiles.length}</Badge>
      </div>

      {profiles.length > 0 ? (
        <div className="grid gap-4 md:grid-cols-2">
          {profiles.map((profile) => (
            <GmProfileCard key={profile.id} profile={profile} />
          ))}
        </div>
      ) : (
        <p className="text-sm text-muted-foreground">
          {PROFILE_NO_GM_PROFILES_MESSAGE}
        </p>
      )}
    </section>
  )
}

const PlayerProfileSection = ({
  profiles,
}: {
  profiles: PlayerProfileResponse[]
}) => {
  return (
    <section className="space-y-3">
      <div className="flex items-center justify-between gap-4 border-b pb-2">
        <h3 className="text-base font-medium text-foreground">
          {PROFILE_PLAYER_PROFILES_LABEL}
        </h3>
        <Badge variant="outline">{profiles.length}</Badge>
      </div>

      {profiles.length > 0 ? (
        <div className="grid gap-4 md:grid-cols-2">
          {profiles.map((profile) => (
            <PlayerProfileCard key={profile.id} profile={profile} />
          ))}
        </div>
      ) : (
        <p className="text-sm text-muted-foreground">
          {PROFILE_NO_PLAYER_PROFILES_MESSAGE}
        </p>
      )}
    </section>
  )
}

const GmProfileCard = ({ profile }: { profile: GmProfileResponse }) => {
  const name = profile.name ?? PROFILE_GM_FALLBACK_NAME

  return (
    <Link
      className="block"
      params={{ id: String(profile.id), type: "gm" }}
      to="/profile/$type/$id"
    >
      <Card className="h-full transition-colors hover:bg-muted/30">
        <CardContent className="space-y-4">
          <ProfileSummaryHeader
            name={name}
            profilePicture={profile.profilePicture}
          />
          <ProfileField
            label={PROFILE_SYSTEMS_LABEL}
            value={
              profile.systems.length > 0
                ? profile.systems.join(", ")
                : PROFILE_EMPTY_VALUE
            }
          />
          <ProfileField
            label={PROFILE_BIO_LABEL}
            value={profile.bio ?? PROFILE_EMPTY_VALUE}
          />
        </CardContent>
      </Card>
    </Link>
  )
}

const PlayerProfileCard = ({ profile }: { profile: PlayerProfileResponse }) => {
  const name = profile.characterName ?? PROFILE_PLAYER_FALLBACK_NAME

  return (
    <Link
      className="block"
      params={{ id: String(profile.id), type: "player" }}
      to="/profile/$type/$id"
    >
      <Card className="h-full transition-colors hover:bg-muted/30">
        <CardContent className="space-y-4">
          <div className="flex items-start justify-between gap-3">
            <ProfileSummaryHeader
              name={name}
              profilePicture={profile.characterImage}
            />
            <Badge variant={profile.isAccepted ? "default" : "secondary"}>
              {profile.isAccepted
                ? PROFILE_ACCEPTED_LABEL
                : PROFILE_PENDING_LABEL}
            </Badge>
          </div>
          <ProfileField
            label={PROFILE_CHARACTER_DESCRIPTION_LABEL}
            value={profile.characterDescription ?? PROFILE_EMPTY_VALUE}
          />
        </CardContent>
      </Card>
    </Link>
  )
}

const ProfileSummaryHeader = ({
  name,
  profilePicture,
}: {
  name: string
  profilePicture: string | null
}) => {
  return (
    <div className="flex min-w-0 items-center gap-3">
      <Avatar size="lg">
        {profilePicture ? <AvatarImage alt="" src={profilePicture} /> : null}
        <AvatarFallback>{initialsFor(name)}</AvatarFallback>
      </Avatar>
      <h4 className="min-w-0 truncate font-medium text-foreground">{name}</h4>
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

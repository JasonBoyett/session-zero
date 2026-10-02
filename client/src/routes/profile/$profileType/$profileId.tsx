import { Page } from "@/components/custom/page"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  PROFILE_ACCEPTED_LABEL,
  PROFILE_BIO_LABEL,
  PROFILE_CHARACTER_DESCRIPTION_LABEL,
  PROFILE_CHARACTER_SHEET_LABEL,
  PROFILE_EMPTY_VALUE,
  PROFILE_GM_FALLBACK_NAME,
  PROFILE_INVALID_TYPE_DESCRIPTION,
  PROFILE_INVALID_TYPE_TITLE,
  PROFILE_LOAD_ERROR_DESCRIPTION,
  PROFILE_LOAD_ERROR_TITLE,
  PROFILE_LOADING_TITLE,
  PROFILE_PENDING_LABEL,
  PROFILE_PLAYER_FALLBACK_NAME,
  PROFILE_QUERY_KEY,
  PROFILE_SYSTEMS_LABEL,
  PROFILE_USER_FALLBACK_NAME,
} from "@/lib/constants"
import type {
  GmProfileResponse,
  PlayerProfileResponse,
  UserProfileResponse,
} from "@/lib/api/generated/types"
import type { ApiClient } from "@/lib/api/apiClient"
import { useQuery } from "@tanstack/react-query"
import { createFileRoute } from "@tanstack/react-router"

type ProfileType = "gm" | "player" | "user"

type ProfileResult =
  | { type: "gm"; data: GmProfileResponse }
  | { type: "player"; data: PlayerProfileResponse }
  | { type: "user"; data: UserProfileResponse }

export const Route = createFileRoute("/profile/$profileType/$profileId")({
  component: RouteComponent,
})

function RouteComponent() {
  const context = Route.useRouteContext()
  const { profileId, profileType } = Route.useParams()
  const parsedProfileId = Number(profileId)
  const isKnownProfileType = isProfileType(profileType)
  const isValidProfileId = Number.isInteger(parsedProfileId) && parsedProfileId > 0

  const profile = useQuery({
    queryKey: [PROFILE_QUERY_KEY, profileType, profileId],
    enabled: isKnownProfileType && isValidProfileId,
    queryFn: async () => {
      if (!isProfileType(profileType)) {
        throw new Error(PROFILE_INVALID_TYPE_TITLE)
      }

      return fetchProfile(context.apiClient, profileType, parsedProfileId)
    },
  })

  if (!isKnownProfileType || !isValidProfileId) {
    return (
      <Page>
        <CenteredCard
          title={PROFILE_INVALID_TYPE_TITLE}
          description={PROFILE_INVALID_TYPE_DESCRIPTION}
        />
      </Page>
    )
  }

  return (
    <Page>
      <main className="mx-auto flex w-full max-w-3xl flex-1 items-center py-8">
        {profile.isPending ? (
          <CenteredCard title={PROFILE_LOADING_TITLE} />
        ) : null}

        {profile.isError ? (
          <CenteredCard
            title={PROFILE_LOAD_ERROR_TITLE}
            description={PROFILE_LOAD_ERROR_DESCRIPTION}
          />
        ) : null}

        {profile.isSuccess ? <ProfileCard profile={profile.data} /> : null}
      </main>
    </Page>
  )
}

const ProfileCard = ({
  profile,
}: {
  profile: ProfileResult
}) => {
  switch (profile.type) {
    case "gm":
      return (
        <Card className="w-full">
          <CardHeader>
            <ProfileTitle
              name={profile.data.name ?? PROFILE_GM_FALLBACK_NAME}
              profilePicture={profile.data.profilePicture}
            />
          </CardHeader>
          <CardContent className="space-y-5">
            <ProfileField
              label={PROFILE_BIO_LABEL}
              value={profile.data.bio ?? PROFILE_EMPTY_VALUE}
            />
            <ProfileField
              label={PROFILE_SYSTEMS_LABEL}
              value={
                profile.data.systems.length > 0
                  ? profile.data.systems.join(", ")
                  : PROFILE_EMPTY_VALUE
              }
            />
          </CardContent>
        </Card>
      )
    case "player":
      return (
        <Card className="w-full">
          <CardHeader>
            <ProfileTitle
              name={profile.data.characterName ?? PROFILE_PLAYER_FALLBACK_NAME}
              profilePicture={profile.data.characterImage}
            />
          </CardHeader>
          <CardContent className="space-y-5">
            <Badge variant={profile.data.isAccepted ? "default" : "secondary"}>
              {profile.data.isAccepted
                ? PROFILE_ACCEPTED_LABEL
                : PROFILE_PENDING_LABEL}
            </Badge>
            <ProfileField
              label={PROFILE_CHARACTER_DESCRIPTION_LABEL}
              value={profile.data.characterDescription ?? PROFILE_EMPTY_VALUE}
            />
            <ProfileField
              label={PROFILE_CHARACTER_SHEET_LABEL}
              value={profile.data.characterSheetLink ?? PROFILE_EMPTY_VALUE}
            />
          </CardContent>
        </Card>
      )
    case "user":
      return (
        <Card className="w-full">
          <CardHeader>
            <ProfileTitle
              name={profile.data.name ?? PROFILE_USER_FALLBACK_NAME}
              profilePicture={profile.data.profilePicture}
            />
          </CardHeader>
        </Card>
      )
  }
}

const CenteredCard = ({
  description,
  title,
}: {
  description?: string
  title: string
}) => {
  return (
    <Card className="mx-auto w-full max-w-xl text-center">
      <CardHeader>
        <CardTitle>{title}</CardTitle>
        {description ? (
          <CardDescription>{description}</CardDescription>
        ) : null}
      </CardHeader>
    </Card>
  )
}

const ProfileTitle = ({
  name,
  profilePicture,
}: {
  name: string
  profilePicture: string | null
}) => {
  return (
    <div className="flex items-center gap-4">
      <Avatar size="lg">
        {profilePicture ? <AvatarImage alt="" src={profilePicture} /> : null}
        <AvatarFallback>{initialsFor(name)}</AvatarFallback>
      </Avatar>
      <CardTitle className="text-3xl">{name}</CardTitle>
    </div>
  )
}

const ProfileField = ({ label, value }: { label: string; value: string }) => {
  return (
    <div className="space-y-1">
      <h2 className="text-sm font-medium text-muted-foreground">{label}</h2>
      <p className="leading-7 text-foreground">{value}</p>
    </div>
  )
}

const isProfileType = (
  profileType: string,
): profileType is ProfileType =>
  profileType === "gm" || profileType === "player" || profileType === "user"

const fetchProfile = async (
  apiClient: ApiClient,
  profileType: ProfileType,
  profileId: number,
): Promise<ProfileResult> => {
  switch (profileType) {
    case "gm":
      return {
        type: profileType,
        data: await apiClient.getGmProfile({ id: profileId }),
      }
    case "player":
      return {
        type: profileType,
        data: await apiClient.getPlayerProfile({ id: profileId }),
      }
    case "user":
      return {
        type: profileType,
        data: await apiClient.getUserProfile({ id: profileId }),
      }
  }
}

const initialsFor = (name: string) =>
  name
    .split(/\s+/)
    .slice(0, 2)
    .map((word) => word[0])
    .join("")
    .toUpperCase()

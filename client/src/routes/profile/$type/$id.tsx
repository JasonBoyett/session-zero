import { Page } from "@/components/custom/page"
import { GmProfilePage } from "@/components/profile/gm-profile-page"
import { PlayerProfilePage } from "@/components/profile/player-profile-page"
import { UserProfilePage } from "@/components/profile/user-profile-page"
import {
  Card,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  PROFILE_INVALID_TYPE_DESCRIPTION,
  PROFILE_INVALID_TYPE_TITLE,
  PROFILE_LOAD_ERROR_DESCRIPTION,
  PROFILE_LOAD_ERROR_TITLE,
  PROFILE_LOADING_TITLE,
  PROFILE_QUERY_KEY,
} from "@/lib/constants"
import type { ApiClient } from "@/lib/api/apiClient"
import { useQuery } from "@tanstack/react-query"
import { createFileRoute } from "@tanstack/react-router"

const profileFetchers = {
  gm: (apiClient: ApiClient, id: number) => apiClient.getGmProfile({ id }),
  player: (apiClient: ApiClient, id: number) =>
    apiClient.getPlayerProfile({ id }),
  user: (apiClient: ApiClient, id: number) => apiClient.getUserProfile({ id }),
}

type ProfileFetchers = typeof profileFetchers
type ProfileType = keyof ProfileFetchers

type ProfileResult = {
  [Type in ProfileType]: {
    type: Type
    data: Awaited<ReturnType<ProfileFetchers[Type]>>
  }
}[ProfileType]

export const Route = createFileRoute("/profile/$type/$id")({
  component: RouteComponent,
})

function RouteComponent() {
  const context = Route.useRouteContext()
  const { id, type } = Route.useParams()
  const parsedId = Number(id)
  const isKnownProfileType = isProfileType(type)
  const isValidProfileId = Number.isInteger(parsedId) && parsedId > 0

  const profile = useQuery({
    queryKey: [PROFILE_QUERY_KEY, type, id],
    enabled: isKnownProfileType && isValidProfileId,
    queryFn: async () => {
      if (!isProfileType(type)) {
        throw new Error(PROFILE_INVALID_TYPE_TITLE)
      }

      return fetchProfile(context.apiClient, type, parsedId)
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
      <main className="me-auto w-full max-w-5xl flex-1 py-8">
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
      return <GmProfilePage profile={profile.data} />
    case "player":
      return <PlayerProfilePage profile={profile.data} />
    case "user":
      return <UserProfilePage profile={profile.data} />
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

const isProfileType = (
  type: string,
): type is ProfileType =>
  Object.hasOwn(profileFetchers, type)

const fetchProfile = async (
  apiClient: ApiClient,
  type: ProfileType,
  id: number,
): Promise<ProfileResult> => {
  return {
    type,
    data: await profileFetchers[type](apiClient, id),
  } as ProfileResult
}

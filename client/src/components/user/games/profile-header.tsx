import { ProfileAvatar, displayName } from "@/components/user/games/profile-avatar"

export const ProfileHeader = ({
  displayName: name,
  profilePicture,
  meta,
}: {
  displayName: string | null
  profilePicture: string | null
  meta: string
}) => {
  return (
    <div className="flex items-center justify-between gap-4">
      <div className="flex min-w-0 items-center gap-3">
        <ProfileAvatar displayName={name} profilePicture={profilePicture} />
        <div className="min-w-0">
          <h3 className="truncate text-lg font-semibold text-foreground">
            {displayName(name)}
          </h3>
          <p className="text-sm text-muted-foreground">{meta}</p>
        </div>
      </div>
    </div>
  )
}

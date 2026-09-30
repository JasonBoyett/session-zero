import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { USER_GAMES_UNNAMED_PROFILE_FALLBACK } from "@/lib/constants"

export const displayName = (name: string | null) =>
  name?.trim() || USER_GAMES_UNNAMED_PROFILE_FALLBACK

export const ProfileAvatar = ({
  displayName: name,
  profilePicture,
  size,
}: {
  displayName: string | null
  profilePicture: string | null
  size?: "default" | "sm" | "lg"
}) => {
  return (
    <Avatar size={size ?? "lg"}>
      {profilePicture ? <AvatarImage alt="" src={profilePicture} /> : null}
      <AvatarFallback>{initialsFor(name)}</AvatarFallback>
    </Avatar>
  )
}

const initialsFor = (name: string | null) => {
  const words = displayName(name).split(/\s+/)

  return words
    .slice(0, 2)
    .map((word) => word[0])
    .join("")
    .toUpperCase()
}

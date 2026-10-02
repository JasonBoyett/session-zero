import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { CardTitle } from "@/components/ui/card"

export const ProfileTitle = ({
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

const initialsFor = (name: string) =>
  name
    .split(/\s+/)
    .slice(0, 2)
    .map((word) => word[0])
    .join("")
    .toUpperCase()

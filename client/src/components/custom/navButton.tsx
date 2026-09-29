import { Link } from "@tanstack/react-router"
import type { LinkOptions } from "@tanstack/react-router"
import { Button } from "../ui/button"

export const NavButton = ({
  children,
  navOptions,
  ...props
}: {
  children?: React.ReactNode | undefined
  navOptions: LinkOptions
} & React.HTMLAttributes<HTMLButtonElement>) => {
  return (
    <Link {...navOptions}>
      <Button className="text-3xl p-6" {...props}>
        {children}
      </Button>
    </Link>
  )
}

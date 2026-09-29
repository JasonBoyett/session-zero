import type { ComponentProps } from "react"
import { cn } from "@/lib/utils"
import { Button } from "../ui/button"

const DiscordLogo = () => {
  return (
    <svg
      aria-hidden="true"
      className="size-5 shrink-0"
      viewBox="0 0 127.14 96.36"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        fill="#fff"
        d="M107.7 8.07A105.15 105.15 0 0 0 81.47 0a72.06 72.06 0 0 0-3.36 6.83 97.68 97.68 0 0 0-29.11 0A72.37 72.37 0 0 0 45.64 0a105.89 105.89 0 0 0-26.25 8.09C2.79 32.65-1.71 56.6.54 80.21a105.73 105.73 0 0 0 32.17 16.15 77.7 77.7 0 0 0 6.89-11.11 68.42 68.42 0 0 1-10.85-5.18c.91-.66 1.8-1.34 2.66-2a75.57 75.57 0 0 0 64.32 0c.87.71 1.76 1.39 2.66 2a68.68 68.68 0 0 1-10.87 5.19 77 77 0 0 0 6.89 11.1 105.25 105.25 0 0 0 32.19-16.14c2.64-27.38-4.51-51.11-18.9-72.15ZM42.45 65.69c-6.27 0-11.44-5.77-11.44-12.87S36.07 40 42.45 40s11.55 5.82 11.44 12.83-5.07 12.86-11.44 12.86Zm42.24 0c-6.27 0-11.44-5.77-11.44-12.87S78.31 40 84.69 40s11.55 5.82 11.44 12.83-5.06 12.86-11.44 12.86Z"
      />
    </svg>
  )
}

export const DiscordLoginButton = ({
  oauthInit,
  children = "Login with Discord",
  className,
  type = "button",
  ...props
}: ComponentProps<"button"> & { oauthInit: VoidFunction }) => {
  return (
    <Button
      className={cn(
        "inline-flex min-h-16 min-w-80 items-center justify-center gap-4 rounded-xl bg-[#5865F2] px-10 py-4 text-2xl font-semibold text-white shadow-sm transition-colors hover:bg-[#4752C4] focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-[#5865F2]/40 active:bg-[#3C45A5] disabled:pointer-events-none disabled:opacity-50 max-sm:min-w-0 max-sm:w-full [&_svg]:size-8",
        className,
      )}
      type={type}
      onClick={() => oauthInit()}
      {...props}
    >
      <DiscordLogo />
      <span>{children}</span>
    </Button>
  )
}

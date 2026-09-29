import type { SVGProps } from "react"
import { cn } from "@/lib/utils"

export const SZLogo = ({ className, ...props }: SVGProps<SVGSVGElement>) => {
  return (
    <svg
      viewBox="0 0 100 100"
      xmlns="http://www.w3.org/2000/svg"
      className={cn("size-10 text-foreground", className)}
      aria-hidden="true"
      {...props}
    >
      <path
        d="
          M50 6
          L76 18
          L90 42
          L84 70
          L64 90
          L36 90
          L16 70
          L10 42
          L24 18
          Z

          M50 6 L38 26 L24 18
          M50 6 L62 26 L76 18

          M10 42 L30 36 L38 26
          M90 42 L70 36 L62 26

          M16 70 L34 62 L30 36
          M84 70 L66 62 L70 36

          M36 90 L42 74 L34 62
          M64 90 L58 74 L66 62

          M38 26 L62 26
          M42 74 L58 74

          M44 40
          C44 36 46.5 34 50 34
          C53.5 34 56 36 56 40
          L56 60
          C56 64 53.5 66 50 66
          C46.5 66 44 64 44 60
          Z

          M42 63 L58 37
        "
        fill="none"
        stroke="currentColor"
        strokeWidth="3.5"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  )
}

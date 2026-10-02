import type { ReactNode } from "react"

export const SectionHeading = ({
  action,
  description,
  title,
}: {
  action?: ReactNode
  description?: string
  title: string
}) => {
  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between gap-4">
        <h2 className="text-2xl font-semibold tracking-tight text-foreground">
          {title}
        </h2>
        {action}
      </div>
      <div className="h-px bg-border shadow-[0_8px_16px_-6px_var(--foreground)]" />
      {description ? (
        <p className="mt-1 text-sm text-muted-foreground">{description}</p>
      ) : null}
    </div>
  )
}

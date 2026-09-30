export const SectionHeading = ({
  description,
  title,
}: {
  description?: string
  title: string
}) => {
  return (
    <div className="space-y-3">
      <h2 className="text-2xl font-semibold tracking-tight text-foreground">
        {title}
      </h2>
      <div className="h-px bg-border shadow-[0_8px_16px_-6px_var(--foreground)]" />
      {description ? (
        <p className="mt-1 text-sm text-muted-foreground">{description}</p>
      ) : null}
    </div>
  )
}

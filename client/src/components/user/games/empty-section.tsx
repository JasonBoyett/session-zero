export const EmptySection = ({ message }: { message: string }) => {
  return (
    <div className="rounded-lg border border-dashed px-4 py-6 text-sm text-muted-foreground">
      {message}
    </div>
  )
}

export const ProfileField = ({
  label,
  value,
}: {
  label: string
  value: string
}) => {
  return (
    <div className="space-y-1">
      <h2 className="text-sm font-medium text-muted-foreground">{label}</h2>
      <p className="leading-7 text-foreground">{value}</p>
    </div>
  )
}

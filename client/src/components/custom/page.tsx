export const Page = ({
  children,
}: {
  children: React.ReactNode | undefined
}) => {
  return (
    <div className="flex min-h-screen flex-col p-8 text-foreground">
      {children}
    </div>
  )
}

export const Page = ({
  children,
}: {
  children: React.ReactNode | undefined
}) => {
  return (
    <div className="flex flex-col min-h-screen bg-background text-foreground p-8">
      {children}
    </div>
  )
}

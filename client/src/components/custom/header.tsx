export const Header = ({
  children,
  ...props
}: {
  children?: React.ReactNode | undefined
} & React.HTMLAttributes<HTMLHeadingElement>) => {
  return (
    <h1 className="text-7xl font-bold text-foreground" {...props}>
      {children}
    </h1>
  )
}

import { Skeleton } from "@/components/ui/skeleton"

export const GamesPageSkeleton = () => {
  return (
    <div className="grid gap-8">
      <div className="space-y-4">
        <Skeleton className="h-8 w-64" />
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          <Skeleton className="h-56" />
          <Skeleton className="h-56" />
          <Skeleton className="hidden h-56 xl:block" />
        </div>
      </div>
      <div className="space-y-4">
        <Skeleton className="h-8 w-52" />
        <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          <Skeleton className="h-56" />
          <Skeleton className="h-56" />
        </div>
      </div>
    </div>
  )
}

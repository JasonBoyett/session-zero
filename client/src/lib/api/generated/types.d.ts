/**
 * This file was auto-generated from OpenAPI schemas.
 * Do not make direct changes to the file.
 */

import type { components, operations, paths } from "./openapi"

export type { components, operations, paths }

export type ApiRoute = keyof paths
export type HttpMethod = "delete" | "get" | "patch" | "post" | "put"
export type ApiOperationId = keyof operations
export type ApiMethod<TRoute extends ApiRoute> = {
  [TMethod in HttpMethod]: TMethod extends keyof paths[TRoute]
    ? NonNullable<paths[TRoute][TMethod]> extends never
      ? never
      : TMethod
    : never
}[HttpMethod]

export type ApiOperation<
  TRoute extends ApiRoute,
  TMethod extends ApiMethod<TRoute>,
> = NonNullable<paths[TRoute][TMethod]>

export type ApiSuccessStatus = 200 | 201 | 202 | 204
export type ApiJsonResponseBody<TResponse> = TResponse extends {
  content: {
    "application/json": infer Body
  }
}
  ? Body
  : never

export type ApiResponseData<
  TRoute extends ApiRoute,
  TMethod extends ApiMethod<TRoute>,
> = ApiOperation<TRoute, TMethod> extends { responses: infer TResponses }
  ? TResponses extends Record<PropertyKey, unknown>
    ? ApiJsonResponseBody<TResponses[Extract<keyof TResponses, ApiSuccessStatus>]>
    : never
  : never

export type ApiRequestData<
  TRoute extends ApiRoute,
  TMethod extends ApiMethod<TRoute>,
> = ApiOperation<TRoute, TMethod> extends {
  requestBody: {
    content: {
      "application/json": infer Body
    }
  }
}
  ? Body
  : never

export type ApiOperationResponseData<TOperationId extends ApiOperationId> =
  operations[TOperationId] extends { responses: infer TResponses }
    ? TResponses extends Record<PropertyKey, unknown>
      ? ApiJsonResponseBody<
          TResponses[Extract<keyof TResponses, ApiSuccessStatus>]
        >
      : never
    : never

export type ApiOperationRequestData<TOperationId extends ApiOperationId> =
  operations[TOperationId] extends {
    requestBody: {
      content: {
        "application/json": infer Body
      }
    }
  }
    ? Body
    : never

export type AuthResponse = {
  authenticated: boolean
  csrfToken: string
  userId: number | null
}

export type CreateAuthSessionRequest = {
  email: string
  password: string
}

export type ErrorResponse = {
  error: string
}

export type CurrentUserResponse = {
  id: number
  email: string | null
  name: string | null
  profilePicture: string | null
  createdAt: string
  updatedAt: string
}

export type UpdateCurrentUserRequest = {
  name?: string | null
  profilePicture?: string | null
}

export type ProfileSummary = {
  id: number
  displayName: string | null
  profilePicture: string | null
}

export type GameSummary = {
  id: number
  name: string | null
  system: string | null
  description: string | null
  playerCount: number
}

export type GameSummaryAsGm = GameSummary

export type GameSummaryAsPlayer = GameSummary & {
  playerProfile: ProfileSummary
  gmProfile: ProfileSummary
}

export type GmIdentitySummary = {
  id: number
  displayName: string | null
  profilePicture: string | null
  games: GameSummaryAsGm[]
}

export type GamesIndexResponse = {
  gmIdentities: GmIdentitySummary[]
  gamesAsPlayer: GameSummaryAsPlayer[]
}

export type GamesIndexGmIdentity = GmIdentitySummary
export type GamesIndexGameAsGm = GameSummaryAsGm
export type GamesIndexGameAsPlayer = GameSummaryAsPlayer

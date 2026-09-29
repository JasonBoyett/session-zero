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

export type AuthResponse = components["schemas"]["AuthResponse"]
export type CreateAuthSessionRequest = components["schemas"]["CreateAuthSessionRequest"]
export type ErrorResponse = components["schemas"]["ErrorResponse"]
export type CurrentUserResponse = components["schemas"]["CurrentUserResponse"]
export type UpdateCurrentUserRequest = components["schemas"]["UpdateCurrentUserRequest"]
export type ProfileSummary = components["schemas"]["ProfileSummary"]
export type GameSummary = components["schemas"]["GameSummary"]
export type GameSummaryAsGm = components["schemas"]["GameSummaryAsGm"]
export type GameSummaryAsPlayer = components["schemas"]["GameSummaryAsPlayer"]
export type GmIdentitySummary = components["schemas"]["GmIdentitySummary"]
export type GamesIndexResponse = components["schemas"]["GamesIndexResponse"]

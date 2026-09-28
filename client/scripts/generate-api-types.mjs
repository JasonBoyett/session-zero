import { execFileSync } from "node:child_process"
import { mkdirSync, readFileSync, writeFileSync } from "node:fs"
import { dirname, resolve } from "node:path"

const openApiPath = resolve("../openapi/v1.json")
const openApiTypesPath = resolve("src/lib/api/generated/openapi.d.ts")
const namedTypesPath = resolve("src/lib/api/generated/types.d.ts")
const operationsPath = resolve("src/lib/api/generated/operations.ts")
const httpMethods = ["delete", "get", "patch", "post", "put"]

mkdirSync(dirname(openApiTypesPath), { recursive: true })

execFileSync(
  "bunx",
  ["openapi-typescript", openApiPath, "-o", openApiTypesPath],
  { stdio: "inherit" },
)

const openApi = JSON.parse(readFileSync(openApiPath, "utf8"))
const schemaNames = Object.keys(openApi.components?.schemas ?? {})

const aliases = schemaNames
  .map((name) => `export type ${name} = components["schemas"]["${name}"]`)
  .join("\n")

const operationEntries = Object.entries(openApi.paths ?? {}).flatMap(
  ([route, pathItem]) =>
    httpMethods.flatMap((method) => {
      const operation = pathItem?.[method]

      if (!operation?.operationId) return []
      if (route.startsWith("/auth/oauth/")) return []
      if (operation["x-browser-only"]) return []

      const parameters = operation.parameters ?? []
      const requiresCsrf = parameters.some((parameter) => {
        if (parameter?.$ref === "#/components/parameters/CsrfToken") return true

        return parameter?.name === "X-CSRF-Token"
      })

      return [
        [
          operation.operationId,
          {
            route,
            method,
            hasBody: Boolean(operation.requestBody),
            requiresCsrf,
          },
        ],
      ]
    }),
)

writeFileSync(
  operationsPath,
  `/**\n * This file was auto-generated from OpenAPI operation IDs.\n * Do not make direct changes to the file.\n */\n\nexport const apiOperations = ${JSON.stringify(
    Object.fromEntries(operationEntries),
    null,
    2,
  )} as const\n`,
)

writeFileSync(
  namedTypesPath,
  `/**
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

${aliases}
`,
)

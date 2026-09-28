import { execFileSync } from "node:child_process"
import { mkdirSync, readFileSync, writeFileSync } from "node:fs"
import { dirname, resolve } from "node:path"

const openApiPath = resolve("../openapi/v1.json")
const openApiTypesPath = resolve("src/lib/api/generated/openapi.d.ts")
const namedTypesPath = resolve("src/lib/api/generated/types.d.ts")

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

writeFileSync(
  namedTypesPath,
  `/**\n * This file was auto-generated from OpenAPI schemas.\n * Do not make direct changes to the file.\n */\n\nimport type { components, operations, paths } from "./openapi"\n\nexport type { components, operations, paths }\n\nexport type ApiRoute = keyof paths\nexport type HttpMethod = "delete" | "get" | "patch" | "post" | "put"\nexport type ApiMethod<TRoute extends ApiRoute> = {\n  [TMethod in HttpMethod]: TMethod extends keyof paths[TRoute]\n    ? NonNullable<paths[TRoute][TMethod]> extends never\n      ? never\n      : TMethod\n    : never\n}[HttpMethod]\n\nexport type ApiOperation<\n  TRoute extends ApiRoute,\n  TMethod extends ApiMethod<TRoute>,\n> = NonNullable<paths[TRoute][TMethod]>\n\nexport type ApiSuccessStatus = 200 | 201 | 202 | 204\nexport type ApiJsonResponseBody<TResponse> = TResponse extends {\n  content: {\n    "application/json": infer Body\n  }\n}\n  ? Body\n  : never\n\nexport type ApiResponseData<\n  TRoute extends ApiRoute,\n  TMethod extends ApiMethod<TRoute>,\n> = ApiOperation<TRoute, TMethod> extends { responses: infer TResponses }\n  ? TResponses extends Record<PropertyKey, unknown>\n    ? ApiJsonResponseBody<TResponses[Extract<keyof TResponses, ApiSuccessStatus>]>\n    : never\n  : never\n\nexport type ApiRequestData<\n  TRoute extends ApiRoute,\n  TMethod extends ApiMethod<TRoute>,\n> = ApiOperation<TRoute, TMethod> extends {\n  requestBody: {\n    content: {\n      "application/json": infer Body\n    }\n  }\n}\n  ? Body\n  : never\n\n${aliases}\n`,
)

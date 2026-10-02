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
const schemas = openApi.components?.schemas ?? {}
const schemaNames = Object.keys(schemas)

const tsIdentifierPattern = /^[A-Za-z_$][\w$]*$/

const pathExpressionForAlias = (baseTypeName, aliasPath) => {
  if (!tsIdentifierPattern.test(baseTypeName)) {
    throw new Error(`Invalid schema type name for alias generation: ${baseTypeName}`)
  }

  const segments = aliasPath.split(".").filter(Boolean)

  if (segments.length === 0) {
    throw new Error(`Alias path for ${baseTypeName} cannot be empty`)
  }

  return segments.reduce((expression, segment) => {
    const match = segment.match(/^([A-Za-z_$][\w$]*)(\[number\])?$/)

    if (!match) {
      throw new Error(
        `Invalid alias path segment "${segment}" for schema ${baseTypeName}`,
      )
    }

    const [, propertyName, arrayAccess] = match
    const propertyAccess = `${expression}["${propertyName}"]`

    return arrayAccess ? `${propertyAccess}[number]` : propertyAccess
  }, baseTypeName)
}

const schemaNameFromRef = (ref) => {
  const prefix = "#/components/schemas/"

  return typeof ref === "string" && ref.startsWith(prefix)
    ? ref.slice(prefix.length)
    : null
}

const dereferenceSchema = (schema) => {
  const refName = schemaNameFromRef(schema?.$ref)

  return refName ? schemas[refName] : schema
}

const schemaForAliasPath = (baseTypeName, aliasPath) => {
  let schema = schemas[baseTypeName]

  if (!schema) return null

  for (const segment of aliasPath.split(".").filter(Boolean)) {
    const match = segment.match(/^([A-Za-z_$][\w$]*)(\[number\])?$/)

    if (!match) return null

    const [, propertyName, arrayAccess] = match
    schema = dereferenceSchema(schema)
    schema = schema?.properties?.[propertyName]

    if (!schema) return null

    if (arrayAccess) {
      schema = schema.type === "array" ? schema.items : null
    }

    if (!schema) return null
  }

  return schema
}

const aliasTarget = (baseTypeName, aliasPath) => {
  const targetSchema = schemaForAliasPath(baseTypeName, aliasPath)
  const refName = schemaNameFromRef(targetSchema?.$ref)

  return {
    expression: refName ?? pathExpressionForAlias(baseTypeName, aliasPath),
    isSchemaRef: Boolean(refName),
  }
}

const nullableType = (type, schema) => schema?.nullable ? `${type} | null` : type

const propertyKey = (name) => tsIdentifierPattern.test(name) ? name : JSON.stringify(name)

const renderSchemaType = (schema) => {
  const refName = schemaNameFromRef(schema?.$ref)

  if (refName) return refName

  if (schema?.allOf) {
    return schema.allOf.map(renderSchemaType).join(" & ")
  }

  if (schema?.oneOf) {
    return schema.oneOf.map(renderSchemaType).join(" | ")
  }

  if (schema?.enum) {
    return schema.enum.map((value) => JSON.stringify(value)).join(" | ")
  }

  if (schema?.type === "array") {
    return nullableType(`${renderSchemaType(schema.items)}[]`, schema)
  }

  if (schema?.type === "object" || schema?.properties) {
    const required = new Set(schema.required ?? [])
    const properties = Object.entries(schema.properties ?? {})

    if (properties.length === 0) return nullableType("Record<string, never>", schema)

    const body = properties
      .map(([name, propertySchema]) => {
        const optional = required.has(name) ? "" : "?"

        return `  ${propertyKey(name)}${optional}: ${renderSchemaType(propertySchema)}`
      })
      .join("\n")

    return nullableType(`{\n${body}\n}`, schema)
  }

  const primitiveType = {
    boolean: "boolean",
    integer: "number",
    number: "number",
    string: "string",
  }[schema?.type]

  return nullableType(primitiveType ?? "unknown", schema)
}

const aliases = schemaNames
  .map((name) => `export type ${name} = ${renderSchemaType(schemas[name])}`)
  .join("\n\n")

const helperAliases = Object.entries(schemas)
  .flatMap(([schemaName, schema]) =>
    Object.entries(schema?.["x-type-aliases"] ?? {}).map(([aliasName, aliasPath]) => {
      if (!tsIdentifierPattern.test(aliasName)) {
        throw new Error(`Invalid generated alias name: ${aliasName}`)
      }

      if (typeof aliasPath !== "string") {
        throw new Error(`Alias path for ${aliasName} must be a string`)
      }

      const target = aliasTarget(schemaName, aliasPath)

      return `export type ${aliasName} = ${target.expression}`
    }),
  )
  .join("\n")

const operationEntries = Object.entries(openApi.paths ?? {}).flatMap(
  ([route, pathItem]) =>
    httpMethods.flatMap((method) => {
      const operation = pathItem?.[method]

      if (!operation?.operationId) return []
      if (route.startsWith("/auth/oauth/")) return []
      if (operation["x-browser-only"]) return []

      const parameters = [
        ...(pathItem.parameters ?? []),
        ...(operation.parameters ?? []),
      ]
      const pathParams = parameters
        .filter((parameter) => parameter?.in === "path")
        .map((parameter) => parameter.name)
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
            pathParams,
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

export type ApiOperationPathData<TOperationId extends ApiOperationId> =
  operations[TOperationId] extends {
    parameters: {
      path: infer PathParameters
    }
  }
    ? PathParameters
    : never

${aliases}
${helperAliases ? `\n${helperAliases}` : ""}
`,
)

# AGENTS.md

## Product Vision

Session Zero is a tool for GMs and players to plan TTRPG games through structured session-zero and safety conversations.

The app should help groups align on campaign expectations, tone, boundaries, safety tools, play preferences, character concepts, logistics, and shared table agreements. Treat player agency, consent, privacy, and psychological safety as core product concerns.

## Domain Principles

- Use “GM” and “players” for table roles.
- Keep TTRPG language inclusive and system-neutral unless a feature explicitly targets a system.
- Treat safety answers and boundaries as sensitive user data.
- Do not expose private player responses casually; design sharing intentionally.
- Avoid framing safety tools as optional extras or compliance checkboxes.
- Prefer clear, respectful language over cute or dismissive wording.
- Remember that a session zero is both planning and consent work: campaign setup, tone alignment, and safety expectations all matter.

## Current Architecture

- Backend: Rails 8 API app.
- Frontend: React, Vite, TanStack Router, and TanStack Query in `client/`.
- Auth: Rails encrypted cookie session with Devise.
- OAuth: Discord OAuth through Rails/OmniAuth.
- API contract: Rswag/OpenAPI generated to `openapi/v1.json`.
- Client API: generated TypeScript types and operation metadata under `client/src/lib/api/generated/`.
- API responses are camelized for the client with `olive_branch`.

## Auth Conventions

- Keep auth session state cookie/server based.
- Do not move auth tokens into `localStorage`.
- Fetch CSRF/session state through `GET /api/v1/auth/session`.
- Store the CSRF token in `sessionStorage` only through the existing API client helpers.
- Use the existing API client and auth context instead of ad hoc fetch calls.
- OAuth start is a browser form `POST`, not Axios/fetch.
- Verify real browser OAuth flows when changing session, CSRF, OmniAuth, or callback behavior.

## API Conventions

- Update Rswag specs when changing public API behavior.
- Run `bin/generate-api` after OpenAPI changes.
- Prefer generated API client methods on the frontend.
- Keep operation IDs stable unless intentionally changing the client API.
- Keep browser-only OAuth operations documented in OpenAPI, but do not force them into the generated Axios operation map.

## OpenAPI Schema Conventions

- Define reusable OpenAPI component schemas as individual Ruby files under `spec/schemas/`.
- Organize schema files into domain-oriented subdirectories. Directory structure is for organization only and does not affect the generated OpenAPI component name.
- A schema's filename is its OpenAPI component identity. `snake_case` filenames are converted to CamelCase with Rails inflection. For example, `spec/schemas/profile/response/gm_profile_response.rb` defines `GmProfileResponse`.
- Schema filenames must be globally unique across `spec/schemas/`, regardless of directory. Do not rely on directory namespaces to distinguish schemas.
- Do not manually register schemas in `swagger_helper.rb`. `SwaggerSchemaLoader` recursively discovers every `.rb` file under `spec/schemas/`; creating the file registers the schema.
- Schema files should evaluate directly to a Ruby `Hash` containing the OpenAPI schema definition. Do not add modules, classes, constants, or registration boilerplate unless the schema system is intentionally being redesigned.
- Prefer standard schema suffixes that communicate purpose:
  - `*_request.rb` for request payloads.
  - `*_response.rb` for endpoint responses.
  - `*_summary.rb` for smaller embedded representations.
  - Context-specific names such as `*_as_gm.rb` or `*_as_player.rb` when the representation changes by role or context.
- Compose schemas with normal OpenAPI `$ref`, `allOf`, `oneOf`, and related constructs rather than duplicating shared definitions.
- `SwaggerSchemaLoader` validates schema files before Rswag generation. Unknown top-level schema keys, malformed schema structure, duplicate component names, and files that do not evaluate to a `Hash` should fail immediately.
- OpenAPI extension keys beginning with `x-` are allowed.
- Keep loader validation focused on catching local authoring mistakes. Do not reimplement full OpenAPI validation in `SwaggerSchemaLoader`.
- When changing the public API contract, update the relevant Rswag request spec and component schema, then run `bin/generate-api`.
- Never manually edit generated OpenAPI or TypeScript API artifacts when the source Rswag spec or schema definition can be changed instead.

## Frontend Conventions

- Use TanStack Router file routes.
- Access API/auth through router context where possible.
- Prefer small route components and straightforward React state.
- Prefer inferred TypeScript types unless explicit types improve clarity or exported API safety.
- Prefer arrow functions for new local helpers and callbacks.
- Use `bun frontend <args>` from the repository root when running Bun commands inside `client/`, including `bun frontend add <package>`.
- Use `bun frontenx <args>` from the repository root when running `bunx` tools inside `client/`.
- Preserve existing design patterns unless intentionally redesigning.
- Run frontend typecheck, lint, and build before considering frontend work complete.

## Backend Conventions

- Prefer small Rails controllers with domain logic in models/services when useful.
- Cover API behavior with request specs and/or integration tests.
- Be careful with session, CSRF, and OAuth changes.
- Avoid adding backward compatibility unless there is persisted data, shipped behavior, external consumers, or an explicit requirement.
- SQLite can lock if Rails tests and RSpec run concurrently; run them sequentially when needed.

## Verification Commands

Run the full app in development:

```sh
bun dev
```

Run only one side when you want narrower logs:

```sh
bun run dev:api
bun run dev:client
```

Backend:

```sh
bin/rails test
bundle exec rspec
```

Dependencies:

```sh
bun frontend add <package>
bun frontend add -d <package>
bun frontenx <tool>
bundle add <gem>
```

API generation:

```sh
bin/generate-api
```

Frontend:

```sh
cd client && bunx tsc --noEmit
cd client && bun run lint
cd client && bun run build
```

## Near-Term Product Direction

Likely next features include:

- Authenticated user profile/settings.
- Campaign or game creation.
- Player invitations.
- Session-zero questionnaire flows.
- Safety tool and boundary collection.
- Shared table agreement or campaign summary.
- Privacy controls for what GMs and players can see.

## Product Decision Guidance

When choosing between correct implementations, prefer the option that makes future safety/privacy rules easier to express. For example, a player response may need to be private, visible only in aggregate, visible to the GM, or shared with the whole table depending on the question and context.

Do not assume all session-zero answers should be shared with everyone. Build toward intentional disclosure and clear user expectations.

<!-- BEGIN:turborepo-agent-rules -->

# This is NOT the Turborepo you know

Turborepo configuration, task behavior, and CLI commands can vary between installed versions and may differ from your training data. Resolve the `turbo` package from this file's directory or relevant workspace; in monorepos, it may not be visible from the repository root. For example, run `node -p "require.resolve('turbo/package.json')"` from a workspace that depends on `turbo`.

Read `docs/README.md` inside that installed package first, then read the relevant pages from its `docs/` directory before changing Turborepo configuration or commands. Heed deprecation notices. These bundled docs match the installed package version and are available without network access.

This block is written and re-added by `turbo` before repository-scoped commands when an AI agent is detected. In the Turborepo source repository, its template is defined in `crates/turborepo-cli/src/cli/agent_guidance.rs`. Removing the managed block while updates are enabled means a later qualifying invocation will add it again. Set `"agentGuidance": false` in the root `turbo.json` or `turbo.jsonc` to opt out; this does not remove an existing block. Keep the block committed with your work to avoid an uncommitted change on the next agent invocation.
<!-- END:turborepo-agent-rules -->

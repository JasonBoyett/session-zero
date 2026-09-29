# Session Zero

Session Zero helps GMs and players plan TTRPG games through structured session-zero and safety conversations.

## Development

Install JavaScript workspace dependencies from the repository root:

```sh
bun install
```

Run the Rails API and Vite client together with Turborepo:

```sh
bun dev
```

Run one side when you want narrower logs:

```sh
bun run dev:api
bun run dev:client
```

Run Bun commands inside the frontend package from the repository root:

```sh
bun frontend run lint
bun frontenx tsc --noEmit
bun frontend add <package>
bun frontend add -d <package>
```

Add Rails/API gems from the repository root:

```sh
bundle add <gem>
```

Common checks:

```sh
bun run typecheck
bun run lint
bun run build
bun run test:api
```

* ...

import path from "node:path"
import { defineConfig, loadEnv } from 'vite'
import { devtools } from '@tanstack/devtools-vite'

import { tanstackRouter } from '@tanstack/router-plugin/vite'

import viteReact from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

const config = defineConfig(({ mode }) => {
  const env = loadEnv(mode, path.resolve(import.meta.dirname, ".."), "")
  const clientPort = Number.parseInt(env.CLIENT_PORT, 10)
  const apiUrl = new URL(env.API_URL).origin

  if (!Number.isInteger(clientPort)) {
    throw new Error("CLIENT_PORT must be an integer")
  }

  return {
    define: {
      "import.meta.env.VITE_API_URL": JSON.stringify(apiUrl),
    },
    server: {
      port: clientPort,
      strictPort: true,
    },
    resolve: {
      tsconfigPaths: true,
      alias: {
        "@components": path.resolve(import.meta.dirname, "./src/components"),
        "@": path.resolve(import.meta.dirname, "./src"),
      },
    },
    plugins: [
      devtools(),
      tailwindcss(),
      tanstackRouter({ target: 'react', autoCodeSplitting: true }),
      viteReact(),
    ],
  }
})

export default config

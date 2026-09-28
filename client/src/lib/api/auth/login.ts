import { apiClient } from "@api/apiClient"

export type LoginResponse = ReturnType<typeof login>
type LoginProps = {
  email: string
  password: string
}

const PRODUCTION_AUTH_WARNING =
  "Cannot use password authentication in production environment"

export const login = async (props: LoginProps) => {
  if (import.meta.env.VITE_ENVIRONMENT === "production")
    throw new Error(PRODUCTION_AUTH_WARNING)

  return apiClient.createAuthSession({
    email: props.email,
    password: props.password,
  })
}

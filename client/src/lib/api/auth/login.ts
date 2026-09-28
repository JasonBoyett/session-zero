import { apiClient } from "@api/apiClient"
import { STATUS_OK } from "../constants"

export type LoginResponse = ReturnType<typeof login>
type LoginProps = {
  email: string
  password: string
  csrfToken: string
}

const PRODUCTION_AUTH_WARNING =
  "Cannot use password authentication in production environment"

export const login = async (props: LoginProps) => {
  if (import.meta.env.VITE_ENVIRONMENT === "production")
    throw new Error(PRODUCTION_AUTH_WARNING)

  const response = await apiClient("/auth/session", "post")(
    {
      email: props.email,
      password: props.password,
    },
    {
      headers: {
        "X-CSRF-Token": props.csrfToken,
      },
    },
  )

  if (response.status !== STATUS_OK)
    throw new Error(`An error occurred while logging in: ${response.status}`)

  return response.data
}

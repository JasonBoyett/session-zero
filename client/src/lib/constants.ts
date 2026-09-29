// keys for query cache
export const INDEX_USER_QUERY_KEY = ["index", "user"] as const
export const USER_USER_PAGE_KEY = ["user", "user"] as const

// text headers
export const HOME_NAV_CARD_TITLE = "Welcome back"

// button text
export const HOME_GAMES_NAV_BUTTON_TEXT = "Your Games"
export const HOME_PROFILE_NAV_BUTTON_TEXT = "Your Profile"

// card description text
export const HOME_NAV_CARD_DESCRIPTION_TEXT = "Click below to see:"

// page text
export const WELCOME_PAGE_TEXT_1 =
  "Plan the game, choose the vibe, set the boundaries."
export const WELCOME_PAGE_TEXT_2 =
  "Then let the dice fall and the adventure begin."

// Error messages
export const PRODUCTION_PASSWORD_AUTH_REJECTED_MESSAGE =
  "Password authentication is disabled in production"

// environment constants
export const isProduction = import.meta.env.PROD

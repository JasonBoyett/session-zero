// keys for query cache
export const INDEX_USER_QUERY_KEY = ["index", "user"] as const
export const USER_USER_PAGE_KEY = ["user", "user"] as const
export const USER_GAMES_PAGE_KEY = ["user", "games"] as const

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

// games page text
export const USER_GAMES_PAGE_TITLE = "Your tables"
export const USER_GAMES_LOAD_ERROR_TITLE = "Could not load games"
export const USER_GAMES_LOAD_ERROR_DESCRIPTION =
  "Refresh the page and try again. If it keeps happening, the API is probably having a moment."
export const USER_GAMES_GM_GAMES_TITLE = "Games you run"
export const USER_GAMES_EMPTY_GM_SECTION_MESSAGE = "No GM-led games yet."
export const USER_GAMES_PLAYER_GAMES_TITLE = "Games you play"
export const USER_GAMES_EMPTY_PLAYER_SECTION_MESSAGE = "No player seats yet."
export const USER_GAMES_GM_LABEL = "GM"
export const USER_GAMES_PLAYING_AS_LABEL = "Playing as"
export const USER_GAMES_UNTITLED_GAME_FALLBACK = "Untitled game"
export const USER_GAMES_NO_DESCRIPTION_FALLBACK = "No description yet."
export const USER_GAMES_EMPTY_STATE_TITLE = "No games yet"
export const USER_GAMES_EMPTY_STATE_DESCRIPTION =
  "Once your GM identities or player profiles are connected to games, they will show up here."
export const USER_GAMES_UNNAMED_PROFILE_FALLBACK = "Unnamed profile"
export const USER_GAMES_GAME_SINGULAR = "game"
export const USER_GAMES_GAME_PLURAL = "games"

// Error messages
export const PRODUCTION_PASSWORD_AUTH_REJECTED_MESSAGE =
  "Password authentication is disabled in production"

// environment constants
export const isProduction = import.meta.env.PROD

/**
 * This file was auto-generated from OpenAPI operation IDs.
 * Do not make direct changes to the file.
 */

export const apiOperations = {
  "getCurrentUser": {
    "route": "/auth/me",
    "method": "get",
    "hasBody": false,
    "pathParams": [],
    "requiresCsrf": false
  },
  "updateCurrentUser": {
    "route": "/auth/me",
    "method": "patch",
    "hasBody": true,
    "pathParams": [],
    "requiresCsrf": true
  },
  "login": {
    "route": "/auth/login",
    "method": "post",
    "hasBody": true,
    "pathParams": [],
    "requiresCsrf": true
  },
  "destroyAuthSession": {
    "route": "/auth/session",
    "method": "delete",
    "hasBody": false,
    "pathParams": [],
    "requiresCsrf": true
  },
  "getAuthSession": {
    "route": "/auth/session",
    "method": "get",
    "hasBody": false,
    "pathParams": [],
    "requiresCsrf": false
  },
  "createAuthSession": {
    "route": "/auth/session",
    "method": "post",
    "hasBody": true,
    "pathParams": [],
    "requiresCsrf": true
  },
  "getCurrentUserGames": {
    "route": "/auth/me/games",
    "method": "get",
    "hasBody": false,
    "pathParams": [],
    "requiresCsrf": false
  },
  "getUserProfile": {
    "route": "/profile/user/{id}",
    "method": "get",
    "hasBody": false,
    "pathParams": [
      "id"
    ],
    "requiresCsrf": false
  },
  "getGmProfile": {
    "route": "/profile/gm/{id}",
    "method": "get",
    "hasBody": false,
    "pathParams": [
      "id"
    ],
    "requiresCsrf": false
  },
  "getPlayerProfile": {
    "route": "/profile/player/{id}",
    "method": "get",
    "hasBody": false,
    "pathParams": [
      "id"
    ],
    "requiresCsrf": false
  }
} as const

/**
 * This file was auto-generated from OpenAPI operation IDs.
 * Do not make direct changes to the file.
 */

export const apiOperations = {
  "getCurrentUser": {
    "route": "/auth/me",
    "method": "get",
    "hasBody": false,
    "requiresCsrf": false
  },
  "updateCurrentUser": {
    "route": "/auth/me",
    "method": "patch",
    "hasBody": true,
    "requiresCsrf": true
  },
  "login": {
    "route": "/auth/login",
    "method": "post",
    "hasBody": true,
    "requiresCsrf": true
  },
  "destroyAuthSession": {
    "route": "/auth/session",
    "method": "delete",
    "hasBody": false,
    "requiresCsrf": true
  },
  "getAuthSession": {
    "route": "/auth/session",
    "method": "get",
    "hasBody": false,
    "requiresCsrf": false
  },
  "createAuthSession": {
    "route": "/auth/session",
    "method": "post",
    "hasBody": true,
    "requiresCsrf": true
  },
  "getCurrentUserGames": {
    "route": "/auth/me/games",
    "method": "get",
    "hasBody": false,
    "requiresCsrf": false
  }
} as const

SaveBackendConfig = {
    -- Keep disabled until there is a real external service.
    -- With this off, saves stay in match memory only.
    ENABLED = false,

    -- Example future value:
    -- BASE_URL = "https://api.your-domain.com"
    BASE_URL = "",

    LOAD_PATH = "/api/survivalrpg/player/load",
    SAVE_PATH = "/api/survivalrpg/player/save",
    TIMEOUT_MS = 8000,

    -- This is not a database password. It is only a server-side Dota key signal.
    -- The backend still must validate SteamID, match rules, ranges and seasons.
    SEND_DEDICATED_SERVER_KEY = true,
    DEDICATED_SERVER_KEY_VERSION = "survival_rpg_v1",

    LOG_REQUESTS = false,
}

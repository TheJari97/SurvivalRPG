SaveBackendConfig = {
    -- Real backend is live. Production rejects requests without a valid server key.
    -- Local Tools may still fall back to memory if Dota cannot provide a dedicated server key.
    ENABLED = true,

    BASE_URL = "https://survivalrpgdota.com",

    LOAD_PATH = "/api/survivalrpg/player/load",
    SAVE_PATH = "/api/survivalrpg/player/save",
    TIMEOUT_MS = 8000,

    -- This is not a database password. It is only a server-side Dota key signal.
    -- The backend still must validate SteamID, match rules, ranges and seasons.
    SEND_DEDICATED_SERVER_KEY = true,
    DEDICATED_SERVER_KEY_VERSION = "survival_rpg_v1",

    LOG_REQUESTS = false,
}

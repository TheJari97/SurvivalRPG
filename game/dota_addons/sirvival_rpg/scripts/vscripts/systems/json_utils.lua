JsonUtils = JsonUtils or {}

local function is_array(value)
    if type(value) ~= "table" then return false end

    local count = 0
    local max_index = 0
    for key, _ in pairs(value) do
        if type(key) ~= "number" or key < 1 or key % 1 ~= 0 then
            return false
        end
        count = count + 1
        if key > max_index then max_index = key end
    end

    return count == max_index
end

local function escape_string(value)
    value = tostring(value or "")
    value = string.gsub(value, "\\", "\\\\")
    value = string.gsub(value, "\"", "\\\"")
    value = string.gsub(value, "\n", "\\n")
    value = string.gsub(value, "\r", "\\r")
    value = string.gsub(value, "\t", "\\t")
    return value
end

function JsonUtils.Encode(value)
    local value_type = type(value)

    if value == nil then
        return "null"
    end

    if value_type == "boolean" then
        return value and "true" or "false"
    end

    if value_type == "number" then
        if value ~= value or value == math.huge or value == -math.huge then
            return "0"
        end
        return tostring(value)
    end

    if value_type == "string" then
        return "\"" .. escape_string(value) .. "\""
    end

    if value_type ~= "table" then
        return "\"" .. escape_string(value) .. "\""
    end

    if is_array(value) then
        local parts = {}
        for index = 1, #value do
            parts[#parts + 1] = JsonUtils.Encode(value[index])
        end
        return "[" .. table.concat(parts, ",") .. "]"
    end

    local keys = {}
    for key, _ in pairs(value) do
        keys[#keys + 1] = key
    end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

    local parts = {}
    for _, key in ipairs(keys) do
        parts[#parts + 1] = "\"" .. escape_string(key) .. "\":" .. JsonUtils.Encode(value[key])
    end

    return "{" .. table.concat(parts, ",") .. "}"
end

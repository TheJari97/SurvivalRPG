Timers = Timers or {}
function Timers:CreateTimer(delay, callback)
    local ent = GameRules:GetGameModeEntity()
    local name = DoUniqueString("sirv_timer")
    ent:SetContextThink(name, function()
        return callback()
    end, delay or 0)
end

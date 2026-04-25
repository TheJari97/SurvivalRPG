XPConfig = {
    max_level = 100,
    base_formula = "120 * level ^ 1.85",
    skill_points = {
        { min = 1, max = 20, every = 2 },
        { min = 21, max = 60, every = 3 },
        { min = 61, max = 100, every = 4 },
    },
    talent_levels = { 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 },
}

function XPConfig:GetRequiredXP(level)
    level = math.max(1, tonumber(level or 1))
    return math.floor(120 * math.pow(level, 1.85))
end

function XPConfig:GetSkillPointsForLevel(level)
    local points = 0
    for i = 2, level do
        if i <= 20 and i % 2 == 0 then points = points + 1 end
        if i >= 21 and i <= 60 and i % 3 == 0 then points = points + 1 end
        if i >= 61 and i <= 100 and i % 4 == 0 then points = points + 1 end
    end
    return points
end

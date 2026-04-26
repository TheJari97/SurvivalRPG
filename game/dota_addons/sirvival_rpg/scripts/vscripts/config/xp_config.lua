XPConfig = {
    max_level = 100,
    base_formula = "120 * level ^ 1.85",
    max_skill_points = 19,
    skill_point_levels = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 25, 30, 35, 40, 50, 60, 75, 90, 100 },
    talent_levels = { 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 },
}

function XPConfig:GetRequiredXP(level)
    level = math.max(1, tonumber(level or 1))
    return math.floor(120 * math.pow(level, 1.85))
end

function XPConfig:GetSkillPointsForLevel(level)
    local points = 0
    level = math.max(1, tonumber(level or 1))
    for _, pointLevel in ipairs(self.skill_point_levels or {}) do
        if level >= pointLevel then points = points + 1 end
    end
    return math.min(points, self.max_skill_points or points)
end

SurvivalItems = SurvivalItems or {}

LinkLuaModifier("modifier_item_sirv_generic", "items/sirv_items.lua", LUA_MODIFIER_MOTION_NONE)

local function ItemSpecial(item, key)
    if not item then return 0 end
    return item:GetSpecialValueFor(key) or 0
end

function SurvivalItems:UseConsumable(item)
    local caster = item:GetCaster()
    local target = item:GetCursorTarget() or caster
    if not caster or not target then return end
    local heal = ItemSpecial(item, "heal")
    local mana = ItemSpecial(item, "mana")
    if heal > 0 then target:Heal(heal, item) end
    if mana > 0 then target:GiveMana(mana) end
    item:SpendCharge()
end

modifier_item_sirv_generic = class({})
function modifier_item_sirv_generic:IsHidden() return true end
function modifier_item_sirv_generic:IsPurgable() return false end
function modifier_item_sirv_generic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sirv_generic:DeclareFunctions()
    return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_HEALTH_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
end
function modifier_item_sirv_generic:GetModifierPreAttack_BonusDamage() return ItemSpecial(self:GetAbility(), "bonus_damage") end
function modifier_item_sirv_generic:GetModifierPhysicalArmorBonus() return ItemSpecial(self:GetAbility(), "bonus_armor") end
function modifier_item_sirv_generic:GetModifierHealthBonus() return ItemSpecial(self:GetAbility(), "bonus_health") end
function modifier_item_sirv_generic:GetModifierMagicalResistanceBonus() return ItemSpecial(self:GetAbility(), "bonus_resist") end
function modifier_item_sirv_generic:GetModifierMoveSpeedBonus_Constant() return ItemSpecial(self:GetAbility(), "bonus_ms") end
function modifier_item_sirv_generic:GetModifierBonusStats_Strength() return ItemSpecial(self:GetAbility(), "bonus_primary") end
function modifier_item_sirv_generic:GetModifierBonusStats_Agility() return ItemSpecial(self:GetAbility(), "bonus_primary") end
function modifier_item_sirv_generic:GetModifierBonusStats_Intellect() return ItemSpecial(self:GetAbility(), "bonus_primary") end

item_sirv_basic_weapon = class({})
function item_sirv_basic_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_basic_head = class({})
function item_sirv_basic_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_basic_chest = class({})
function item_sirv_basic_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_basic_cape = class({})
function item_sirv_basic_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_basic_boots = class({})
function item_sirv_basic_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_basic_relic = class({})
function item_sirv_basic_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_basic_backpack = class({})
function item_sirv_basic_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_basic_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_weapon = class({})
function item_sirv_common_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_head = class({})
function item_sirv_common_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_chest = class({})
function item_sirv_common_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_cape = class({})
function item_sirv_common_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_boots = class({})
function item_sirv_common_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_relic = class({})
function item_sirv_common_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_common_backpack = class({})
function item_sirv_common_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_common_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_weapon = class({})
function item_sirv_rare_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_head = class({})
function item_sirv_rare_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_chest = class({})
function item_sirv_rare_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_cape = class({})
function item_sirv_rare_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_boots = class({})
function item_sirv_rare_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_relic = class({})
function item_sirv_rare_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_rare_backpack = class({})
function item_sirv_rare_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_rare_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_weapon = class({})
function item_sirv_epic_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_head = class({})
function item_sirv_epic_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_chest = class({})
function item_sirv_epic_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_cape = class({})
function item_sirv_epic_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_boots = class({})
function item_sirv_epic_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_relic = class({})
function item_sirv_epic_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_epic_backpack = class({})
function item_sirv_epic_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_epic_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_weapon = class({})
function item_sirv_legendary_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_head = class({})
function item_sirv_legendary_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_chest = class({})
function item_sirv_legendary_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_cape = class({})
function item_sirv_legendary_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_boots = class({})
function item_sirv_legendary_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_relic = class({})
function item_sirv_legendary_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_legendary_backpack = class({})
function item_sirv_legendary_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_legendary_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_weapon = class({})
function item_sirv_mythic_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_head = class({})
function item_sirv_mythic_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_chest = class({})
function item_sirv_mythic_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_cape = class({})
function item_sirv_mythic_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_boots = class({})
function item_sirv_mythic_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_relic = class({})
function item_sirv_mythic_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_mythic_backpack = class({})
function item_sirv_mythic_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_mythic_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_weapon = class({})
function item_sirv_divine_weapon:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_weapon:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_head = class({})
function item_sirv_divine_head:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_head:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_chest = class({})
function item_sirv_divine_chest:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_chest:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_cape = class({})
function item_sirv_divine_cape:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_cape:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_boots = class({})
function item_sirv_divine_boots:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_boots:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_relic = class({})
function item_sirv_divine_relic:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_relic:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_divine_backpack = class({})
function item_sirv_divine_backpack:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_divine_backpack:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_iron_fragment = class({})
function item_sirv_material_iron_fragment:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_iron_fragment:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_arcane_dust = class({})
function item_sirv_material_arcane_dust:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_arcane_dust:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_wild_essence = class({})
function item_sirv_material_wild_essence:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_wild_essence:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_elite_core = class({})
function item_sirv_material_elite_core:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_elite_core:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_boss_mark = class({})
function item_sirv_material_boss_mark:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_boss_mark:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_ancient_gem = class({})
function item_sirv_material_ancient_gem:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_ancient_gem:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_titan_blood = class({})
function item_sirv_material_titan_blood:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_titan_blood:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_material_divine_fragment = class({})
function item_sirv_material_divine_fragment:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_material_divine_fragment:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_artifact_wall_heart = class({})
function item_sirv_artifact_wall_heart:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_artifact_wall_heart:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_artifact_dawn_tear = class({})
function item_sirv_artifact_dawn_tear:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_artifact_dawn_tear:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_artifact_void_eye = class({})
function item_sirv_artifact_void_eye:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_artifact_void_eye:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_artifact_eclipse_claw = class({})
function item_sirv_artifact_eclipse_claw:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_artifact_eclipse_claw:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_artifact_titan_seed = class({})
function item_sirv_artifact_titan_seed:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_artifact_titan_seed:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_pet_collar = class({})
function item_sirv_pet_collar:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_pet_collar:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_pet_armor = class({})
function item_sirv_pet_armor:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_pet_armor:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_pet_claws = class({})
function item_sirv_pet_claws:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_pet_claws:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_pet_talisman = class({})
function item_sirv_pet_talisman:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_pet_talisman:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_pet_emblem = class({})
function item_sirv_pet_emblem:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_pet_emblem:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_potion_small = class({})
function item_sirv_potion_small:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_potion_small:OnSpellStart() SurvivalItems:UseConsumable(self) end

item_sirv_potion_mana = class({})
function item_sirv_potion_mana:GetIntrinsicModifierName() if self:GetAbilityName():find('potion') then return nil end return "modifier_item_sirv_generic" end
function item_sirv_potion_mana:OnSpellStart() SurvivalItems:UseConsumable(self) end

local function RegisterGenericShopItem(itemName)
    if not itemName or _G[itemName] then return end
    _G[itemName] = class({})
    function _G[itemName]:GetIntrinsicModifierName()
        return "modifier_item_sirv_generic"
    end
    function _G[itemName]:OnSpellStart()
        SurvivalItems:UseConsumable(self)
    end
end

if ShopConfig and ShopConfig.item_info then
    for itemName, _ in pairs(ShopConfig.item_info) do
        RegisterGenericShopItem(itemName)
    end
end

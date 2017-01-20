-------------------------------------------------------------------------------
--- AUTHOR: Keithen
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
-------------------------------------------------------------------------------

require( GetScriptDirectory().."/constants" )
require( GetScriptDirectory().."/item_purchase_enigma" )
require ( GetScriptDirectory().."/ability_usage_enigma" )

local utils = require( GetScriptDirectory().."/utility" )
local dt = require( GetScriptDirectory().."/decision_tree" )
local gHeroVar = require( GetScriptDirectory().."/global_hero_data" )

function setHeroVar(var, value)
	local bot = GetBot()
	gHeroVar.SetVar(bot:GetPlayerID(), var, value)
end

function getHeroVar(var)
	local bot = GetBot()
	return gHeroVar.GetVar(bot:GetPlayerID(), var)
end

local ENIGMA_SKILL_Q = "enigma_malefice";
local ENIGMA_SKILL_W = "enigma_demonic_conversion";
local ENIGMA_SKILL_E = "enigma_midnight_pulse";
local ENIGMA_SKILL_R = "enigma_black_hole";

local ENIGMA_ABILITY1 = "special_bonus_movement_speed_20"
local ENIGMA_ABILITY2 = "special_bonus_magic_resistance_12"
local ENIGMA_ABILITY3 = "special_bonus_cooldown_reduction_15"
local ENIGMA_ABILITY4 = "special_bonus_gold_income_20"
local ENIGMA_ABILITY5 = "special_bonus_hp_300"
local ENIGMA_ABILITY6 = "special_bonus_respawn_reduction_30"
local ENIGMA_ABILITY7 = "special_bonus_armor_12"
local ENIGMA_ABILITY8 = "special_bonus_unique_enigma"

local EnigmaAbilityPriority = {
	ENIGMA_SKILL_W,    ENIGMA_SKILL_Q,    ENIGMA_SKILL_W,    ENIGMA_SKILL_E,    ENIGMA_SKILL_W,
    ENIGMA_SKILL_R,    ENIGMA_SKILL_W,    ENIGMA_SKILL_Q,    ENIGMA_SKILL_E,    ENIGMA_ABILITY1,
    ENIGMA_SKILL_Q,    ENIGMA_SKILL_R,    ENIGMA_SKILL_E,    ENIGMA_SKILL_Q,    ENIGMA_ABILITY3,
    ENIGMA_SKILL_E,    ENIGMA_SKILL_R,    ENIGMA_ABILITY6,   ENIGMA_ABILITY7
};

local enigmaActionStack = { [1] = constants.ACTION_NONE }

botEnigma = dt:new()

function botEnigma:new(o)
	o = o or dt:new(o)
	setmetatable(o, self)
	self.__index = self
	return o
end

enigmaBot = botEnigma:new{actionStack = enigmaActionStack, abilityPriority = EnigmaAbilityPriority}
--enigmaBot:printInfo();

enigmaBot.Init = false;

function enigmaBot:ConsiderAbilityUse()
	ability_usage_enigma.AbilityUsageThink()
end

function Think()
    local npcBot = GetBot()

		enigmaBot:Think(npcBot)
end

function MinionThink(minion)
    print("DADDY!!", utils.GetHeroName(GetBot()))
end

function enigmaBot:GetMaxClearableCampLevel(bot)
	if DotaTime() < 30 then
		return constants.CAMP_EASY
	end

	local conversion = bot:GetAbilityByName("enigma_demonic_conversion")
	if conversion:GetLevel() >= 2 then
		return constants.CAMP_HARD
	end

	return constants.CAMP_MEDIUM
end

function enigmaBot:IsReadyToRoam(bot)
    local BH = bot:GetAbilityByName("enigma_black_hole")
    return BH:IsFullyCastable() -- that's all we need
end

function enigmaBot:DoCleanCamp(bot, neutrals)
    local conversion = bot:GetAbilityByName("enigma_demonic_conversion")
	table.sort(neutrals, function(n1, n2) return n1:GetHealth() < n2:GetHealth() end) -- sort by health
    if conversion:IsFullyCastable() then
        -- TODO: Find the biggest guy we can convert
        bot:Action_UseAbilityOnEntity(conversion, neutrals[#neutrals])
    end
    bot:Action_AttackUnit(neutrals[#neutrals], true)
end
--------------------------------------------------------------------------------------------
--- AUTHOR: Keithen
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
--------------------------------------------------------------------------------------------

_G._savedEnv = getfenv()
module( "map_control", package.seeall )

local utils = require( GetScriptDirectory().."/utility" )
require( GetScriptDirectory().."/buildings_status" )

local RB1 = Vector(1400,-4700)
local RB2 = Vector(-1050,-4600)
local RB3 = Vector(4000,-4000)
local RT1 = Vector(-4300,-1300)
local RT2 = Vector(-2300,200)
local DT1 = Vector(300,4200)
local DT2 = Vector(-2600,3900)
local DT3 = Vector(-4200,4700)
local DB1 = Vector(2200,-1200)
local DB2 = Vector(3500,500)

local L = utils.Locations

local POIs = {L.RadiantBase, L.RBT1, L.RBT2, L.RBT3, L.RMT1, L.RMT2, L.RMT3, L.RTT1, L.RTT2, L.RTT3, L.RadiantTopShrine, L.RadiantBotShrine,
              L.DireBase, L.DBT1, L.DBT2, L.DBT3, L.DMT1, L.DMT2, L.DMT3, L.DTT1, L.DTT2, L.DTT3, L.DireTopShrine, L.DireBotShrine,
              utils.ROSHAN, RB1, RB2, RB3, RT1, RT2, DT1, DT2, DT3, DB1, DB2}
local data = {}

-- map our building ids to the points of interest
local buildings_mapping = {
    [TEAM_RADIANT]={
        -- towers -- TODO: take care of barracks
        [1]=2,
        [2]=3,
        [3]=4,
        [4]=5,
        [5]=6,
        [6]=7,
        [7]=8,
        [8]=9,
        [9]=10,
        -- ancient
        [18]=1,
        -- shrines
        [19]=11,
        [20]=12
    },
    [TEAM_DIRE]={
        -- towers -- TODO: take care of barracks
        [1]=14,
        [2]=15,
        [3]=16,
        [4]=17,
        [5]=18,
        [6]=19,
        [7]=20,
        [8]=21,
        [9]=22,
        -- ancient
        [18]=13,
        -- shrines
        [19]=23,
        [20]=24
    }
}

function writeout_points()
    local json = "{\"pois\":["
    for i, vec in pairs(POIs) do
        if i > 1 then json = json.."," end
        json = json .. "["..vec[1]..","..vec[2].."]"
    end
    json = json.."]}"
    local request = CreateHTTPRequest("")
    request:SetHTTPRequestRawPostBody('application/json', json)
    request:Send(function(result) return end)
end

function writeout_data(category)
    local json = "{\"name\":\""..category.."\",\"data\":["
    for i, value in pairs(data[category]) do
        if i > 1 then json = json.."," end
        json = json .. value
    end
    json = json.."]}"
    local request = CreateHTTPRequest("")
    request:SetHTTPRequestRawPostBody('application/json', json)
    request:Send(function(result) return end)
end

function init()
    data["our_vision"] = {}
    data["our_presence"] = {}
    data["our_money"] = {}
    data["our_objectives"] = {}
    data["our_kill"] = {}
    data["our_get_killed"] = {}

    data["their_vision"] = {}
    data["their_presence"] = {}
    data["their_money"] = {}
    data["their_objectives"] = {}
    data["their_kill"] = {}
    data["their_get_killed"] = {}

    for category, _ in pairs(data) do
        reset_category(category)
    end
end

function reset_category(category)
    for i=1,35 do
        data[category][i] = 0.0
    end
end

function update_our_presence()
    reset_category("our_presence")
    local array = data["our_presence"]
    local allies = GetUnitList(UNIT_LIST_ALLIED_HEROES)
    local alliesWithTP = {}
    for _, ally in pairs(allies) do
        if utils.HaveTeleportation(ally) then
            alliesWithTP[#alliesWithTP+1] = ally
        end
    end
    local bids = buildings_status.GetStandingBuildingIDs(GetTeam())
    local mapping = buildings_mapping[GetTeam()]
    for _, bid in pairs(bids) do
        if mapping[bid] ~= nil then
            array[mapping[bid]] = 0.1 * #alliesWithTP
        end
    end

    writeout_data("our_presence")
end

function update()
    update_our_presence()
end

writeout_points()
init()

for k,v in pairs( map_control ) do _G._savedEnv[k] = v end

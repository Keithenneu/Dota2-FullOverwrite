--------------------------------------------------------------------------------------------
--- AUTHOR: Keithen
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-FullOverwrite
--------------------------------------------------------------------------------------------

_G._savedEnv = getfenv()
module( "map_control", package.seeall )

local utils = require( GetScriptDirectory().."/utility" )

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

local POIs = {L.RadiantBase, L.RBT1, L.RBT2, L.RBT3, L.RMT1, L.RMT2, L.RMT3, L.RTT1, L.RTT2, L.RTT3, L.RadiantTopShrine, L.RadiantBotShrine, L.DireBase, L.DBT1, L.DBT2, L.DBT3, L.DMT1, L.DMT2, L.DMT3, L.DTT1, L.DTT2, L.DTT3, L.DireTopShrine, L.DireBotShrine, utils.ROSHAN, RB1, RB2, RB3, RT1, RT2, DT1, DT2, DT3, DB1, DB2}

local printedPoints = false
function print_points()
    if not printedPoints then
        printedPoints = true
        local data = "{\"pois\":["
        print("Points of interest")
        for i, vec in pairs(POIs) do
            if i > 1 then data = data.."," end
            data = data .. "["..vec[1]..","..vec[2].."]"
        end
        data = data.."]}"
        print(data)
    end
end

for k,v in pairs( map_control ) do _G._savedEnv[k] = v end

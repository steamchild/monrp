team.SetUp(1,"Guest",Color(0,0,0))
team.SetUp(2,"Admin",Color(0,255,0))
Groups = {}

function AddExtraTeam(Weapons,Models,WalkSpeed,Health,Color,Name)
local Group = {}
Group.Name = Name
Group.ID = table.Count(Groups) + 1
Group.Models = Models
Group.Health = Health
Group.RunSpeed = WalkSpeed + 100
Group.WalkSpeed = WalkSpeed 
Group.Color = Color
Group.StartUSD = 500
Group.StartEUR = 0
Group.Weapons = {}
	for k, v in pairs(Weapons) do
		Group.Weapons[k] = Weapons[k] 
	end
Groups[table.Count(Groups) + 1] = Group
return Group
end

local CITIZEN_WEAPONS = {
"gmod_tool",
"weapon_physgun",
"weapon_physcannon",
"gmod_camera"
}

local CITIZEN_MODELS = {
	"models/player/Group01/Female_01.mdl",
	"models/player/Group01/Female_02.mdl",
	"models/player/Group01/Female_03.mdl",
	"models/player/Group01/Female_04.mdl",
	"models/player/Group01/Female_06.mdl",
	"models/player/Group01/Female_07.mdl",
	"models/player/group01/male_01.mdl",
	"models/player/Group01/Male_02.mdl",
	"models/player/Group01/male_03.mdl",
	"models/player/Group01/Male_04.mdl",
	"models/player/Group01/Male_05.mdl",
	"models/player/Group01/Male_06.mdl",
	"models/player/Group01/Male_07.mdl",
	"models/player/Group01/Male_08.mdl",
	"models/player/Group01/Male_09.mdl"
}

TEAM_CONNECTING = AddExtraTeam({},CITIZEN_MODELS,250,100,Color(50,200,200),"Joining")
TEAM_CITIZEN = AddExtraTeam(CITIZEN_WEAPONS,CITIZEN_MODELS,250,120,Color(100,155,100),"Citizen")

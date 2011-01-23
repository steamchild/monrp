require("datastream")
include( "sh_functions.lua")
include( "sv_chat.lua" )

local meta = FindMetaTable("Entity")
local ply = FindMetaTable("Player")
local Dir = "MonRP/"

function ply:SendData(VarNames,VarValues)

datastream.StreamToClients(self, "Player_Data", {VarNames,VarValues} );

end 

//--------------------------------------------------
//	LOAD DATA
//--------------------------------------------------

 --Find file language elements
function findstatement(compilepos,content)
	if (content == nil) then return false end
	local statementname = ""
	local pos = compilepos
	local length = string.len( content )
	local reading = ""
	local statementtpye = ""
	local firstchar = ""
	local lastchar = ""
	local operators = {"=","+","-","*","/",";","}","{","[","]"}
	local tabdeepness = 0

//Read Statement
	while pos <= length do
		pos = pos + 1
		local pos2 = pos
		local char = ""
		char = string.sub(content,pos,pos)
		local nextchar = ""
		// we dont need spaces if its not string
		while (nextchar == "" or nextchar == " ") and pos2<=length and reading != "str" do
			pos2 = pos2+1
			nextchar = string.sub(content,pos2,pos2)
		end
		if char!=" "then
			if (firstchar == "") then firstchar = char end
			lastchar = char

			if (char == "[" and reading == "") then reading = "str" end
			if (char == "]" and reading == "str") then reading = "" end

			if (firstchar == "{") then tabdeepness = tabdeepness + 1 end
			if (firstchar == "}") then tabdeepness = tabdeepness - 1 end
			if (tabdeepness > 0 and (reading=="table" or reading == "")) then reading = "table" else reading = "" end


			statementname = statementname..char
			if reading == "" and (char == "]" or char == ";" or char == "=" or char == "}" or char == "{" or char == ",") then break end
			if reading == "" and (nextchar == ";" or nextchar == "=" or nextchar == "}" or nextchar == "" or 
						nextchar == " " or nextchar == "[" or nextchar == ",") 
			then break end
		end
	end

//What is the statemant we read is:
	if (tonumber(statementname)) then statementtype = "number" end
	if (!tonumber(firstchar) and lastchar != "{" and lastchar != "[") then statementtype = "var" end
	if (firstchar == "[" and lastchar == "]") then statementtype = "string" end
	if (firstchar != lastchar and lastchar == "{") then statementtype = "procedure" end
	if (firstchar == "{" and lastchar == "}") then statementtype = "table" end
	if (table.HasValue(operators,statementname) and string.len(statementname) == 1) then statementtype = "operator" end

	if (statementname != "") then return statementname, pos, statementtype end
	return "fend", pos, "end"
end

function ChangeGroup(ply,Group)
	ply.Group = Group
	ply:SetMaxHealth(ply.Group.Health, true )
	ply:SetHealth(ply.Group.Health)
	ply:SetWalkSpeed(ply.Group.WalkSpeed)  
	ply:SetRunSpeed(ply.Group.RunSpeed)
	GAMEMODE:PlayerSetModel(ply)
end

 --Compile language elements to player data
function ply:LoadData()

local SteamID = self:SteamID()
local ID = string.gsub(SteamID,":","_")
local FileName = "player_"..ID..".txt"

if !file.Exists(Dir..FileName) then return false end
local content = file.Read("../data/"..Dir..FileName) 
local pos = 0
local curproc = ""
local Errors = 0
local proc = ""
local var
local operator
local mean

while true do
	local state
	local stype
	state,pos,stype = findstatement(pos,content)

	if (state == "fend") then print("broken") break end 

	if stype == "procedure" then proc = string.sub(state,1,-2) print("procedure: "..proc)
	else

	if (proc == "player") then 
		if (state == ";") then stype = nil state = nil var = nil operator = nil mean = nil print("reseted") end 
		if (stype == "var") then print("var: "..state) var = state end
		if (stype == "operator") then print("operator: "..state) operator = state end
		if (operator == "=") then
			if stype == "number" then mean = tonumber(state) print("mean: "..mean) end
			if stype == "string" then mean = string.sub(state,2,-2) print("mean: "..mean) end
			if stype == "table" then mean = stringtotable(state) end
			if (var and operator and mean) then print("Exit: "..var..operator..mean) self:SetVar(var, mean) end
		end
	end
	end
end
return true
end

function meta:WriteData(data)

local SteamID = self:SteamID()
local ID = string.gsub(SteamID,":","_")
local FileName = "player_"..ID..".txt"

local dv = ";"
local exit = ""

for k, v in pairs(data[1]) do
	local name = v
	local value = data[2][k]
	print("name:")
	print(name)
	print("value:")
	print(value)
	if (value) then 
		local strval = tostring(value)
		if type(value) == "string" then strval = "["..strval.."]" end
		exit = exit..name.."="..strval..dv
	end
end

local Text = "player{"..exit.."}"

file.Write(Dir..FileName, Text)
return true
end

//--------------------------------------------------
//	USEFULL
//--------------------------------------------------

function ply:HitSpeed(time)
	if SERVER then 
		local runam = self.NormRunSpeed/2
		local walkam = self.NormWalkSpeed/2
		if self:GetRunSpeed() > runam then self:SetRunSpeed(runam) end
		if self:GetWalkSpeed() > walkam then self:SetWalkSpeed(walkam) end
		self.SpeedRegenTime = time
	end
end

function ply:AddMoneyUSD(amount)
	self.USD = self.USD + amount self:SendData({"USD"},{self.USD}) return
end

function ply:AddMoneyEUR(amount)
	self.EUR = self.EUR + amount self:SendData({"EUR"},{self.EUR}) return
end

function ply:TakeMoneyEUR(amount)
	if (self.EUR-amount>=0) then self.EUR=self.EUR-amount self:SendData({"EUR"},{self.EUR}) return true end
	return false
end

function ply:TakeMoneyUSD(amount)
	if (self.USD-amount>=0) then self.USD=self.USD-amount self:SendData({"USD"},{self.USD}) return true end
	return false
end
/*-------------------------------------------
	USE WITH CARE
--------------------------------------------*/
function ply:ForceTakeMoneyEUR(amount)
	self.EUR=self.EUR-amount self:SendData({"EUR"},{self.EUR})
	if (self.EUR < 0) then return false else return true end
end

function ply:ForceTakeMoneyUSD(amount)
	self.USD=self.USD-amount self:SendData({"USD"},{self.USD})
	if (self.USD < 0) then return false else return true end
end

/*-------------------------------------------
	USE WITH CARE
--------------------------------------------*/

function ply:MrpDropWeapon(wep)
	if (wep) then 
		local pos = self:EyePos()
		local ang = self:EyeAngles()
		local norm = ang:Forward()
		local vel = 150
		local angvel = Angle(0,0,10)
		local entwep = SpawnWep(self, ang, pos, wep)
		entwep:GetPhysicsObject():AddVelocity( vel*norm )
		entwep:GetPhysicsObject():AddAngleVelocity(angvel)
		self:StripWeapon(wep:GetClass())
	end
end

function ply:WriteValues(names)
	local values = {}
	for k , v in pairs(names) do
		print(v)
		print(self[v])
		values[k] = self[v]
	end
	self:WriteData({names,values}) 
end

function ply:CalcHunger()
	if (!self.Hunger or !self.HungerSpeed) then return end
	if (self.Hunger - 0.1 > 0) then self.Hunger = self.Hunger - 0.1 end
	self:SendData( {"Hunger"},{self.Hunger} )
end

function ply:CalcFatigue()
	if (!self.Fatigue or !self.FatigueSpeed) then return end
	if (self.Fatigue - 0.05 > 0) then self.Fatigue = self.Fatigue - 0.05 end
	self:SendData( {"Fatigue"},{self.Fatigue} )
end

function ply:AddHunger(amount)
	if (self.Hunger+amount < 100) then self.Hunger = self.Hunger+amount else self.Hunger = 100 end
	self:SendData( {"Hunger"},{self.Hunger} )
end

//--------------------------------------------------
//	INTERFACE
//--------------------------------------------------

function ply:OpenInterface(ID)
	umsg.Start( "OpenInterface" );
		umsg.Long( ID );
	umsg.End();
end

//---------------------------------------------------
//	OWNING
//---------------------------------------------------
function ply:AddRealty(core)
	table.insert(ply.Realty,core)
end
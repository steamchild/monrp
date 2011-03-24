function stringtotable(string)
local pos = 0
local values = {}
local value = ""
local k = 0
	while value != "fend" do
		value,pos,stype = findstatement(pos,string.sub(string,2,-2))
		if (value != "") then
			if stype == "number" then k=k+1 values[k] = tonumber(value) end
			if stype == "string" then k=k+1 values[k] = string.sub(value,2,-2) end
			if stype == "table" then k=k+1 values[k] = stringtotable(value) end
		end
	end
return values
end

function MoneyToString(Money)
	local Mstring = tostring(Money)
	local Mtab = string.ToTable(Mstring)
	local count = 0
	local len = table.Count(Mtab)
	local pos = len
	local k = 0
	while pos>2 do
		pos = len-k
		local v = Mtab[pos]
		if (v!=",") then count = count + 1 end
		if (count >= 3) then count = 0 table.insert(Mtab,pos,",") end
		k = k + 1
	end
	local ExitStr = ""
	for k, v in pairs(Mtab) do
		ExitStr=ExitStr..v
	end	
	return ExitStr
end

ents.FindCores = function()
	local exit = ents.FindByClass("core_house")
	return exit
end

ents.FindDoors = function()
	local exit = ents.FindByClass("prop_door_rotating")
	table.Add(exit,ents.FindByClass("func_door_rotating"))
	table.Add(exit,ents.FindByClass("func_door"))
	return exit
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:IsDoor()
	local class = self:GetClass()
	return table.HasValue({"prop_door_rotating","func_door_rotating","func_door"}, class )
end

function ENTITY:MrpGetOwners()
	return self.MrpOwners
end

function ENTITY:MrpIsOwner(ply)
	if (!self:MrpGetOwners()) then return end
	if (table.HasValue(self.MrpOwners,ply)) then return true else return false end
end

function ENTITY:MrpIsOwned()
	if (!self.MrpOwners) then return false end
	if (table.getn(self.MrpOwners) == 0) then return false else return true end
end

function ENTITY:IsForSale()
	if (self.ForSale or !self:MrpIsOwned()) then return true end
	return false
end

function ENTITY:IsForSaleAuction()
	return self.ForSaleAuction
end


local PLAYER = FindMetaTable("Player")

function PLAYER:HasMoney(amm,cur)
	if (cur == 1) then
		return self.USD > amm
	else
		return self.EUR > amm
	end
end
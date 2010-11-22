ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Money"
ENT.Author = "eMe"
ENT.Spawnable = false
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:DTVar("Int",self.amount,"amount")
end

local ENTITY = FindMetaTable("Entity")
function ENTITY:IsMoney()
	return self:GetClass() == "spawned_money"
end
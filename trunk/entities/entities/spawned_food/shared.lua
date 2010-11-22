ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Food"
ENT.Author = "eMe"
ENT.Spawnable = false
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:DTVar("Int",self.rich,"rich")
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:IsFood()
	return self:GetClass() == "spawned_food"
end
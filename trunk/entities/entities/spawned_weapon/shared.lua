ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawned Weapon"
ENT.Author = "eMe"
ENT.Spawnable = false
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:DTVar("Int",self.class,"class")
end

local ENTITY = FindMetaTable("Entity")
function ENTITY:IsWeapon()
	return self:GetClass() == "spawned_weapon"
end
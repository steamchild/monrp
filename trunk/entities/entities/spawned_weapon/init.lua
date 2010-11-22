AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	local model = self.model or "models/props/cs_assault/money.mdl"
	self.Entity:SetModel(model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) 
end


function ENT:Use(activator,caller)
	local wep = activator:Give(self.class)
	self:Remove()
end

function SpawnWep(owner, ang, pos, wep)
	local ent = ents.Create("spawned_weapon")
	ent.Owner = owner
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent.model = wep.WorldModel
	ent.class = wep:GetClass()
	ent.prim = wep:Clip1()
	ent.sec = wep:Clip2()
	ent.primtype = wep:GetPrimaryAmmoType()
	ent.sectype = wep:GetSecondaryAmmoType()
	ent:Spawn()
	ent:Activate()
	return ent
end
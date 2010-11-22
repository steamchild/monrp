AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SpawnFunction(player,trace)
	if trace.Hit then
		SpawnFood(player, player:GetAngles(), trace.HitPos+trace.HitNormal*16)
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_junk/garbage_takeoutcarton001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) 
end


function ENT:Use(activator,caller)
	local amount = self.amount
	if (self.rich) then activator:AddHunger(self.rich) end
	self:Remove()
end

function SpawnFood(owner, ang, pos)
	local ent = ents.Create("spawned_food")
	ent.Owner = owner
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent.rich=10
	ent:Spawn()
	ent:Activate()
	return ent
end
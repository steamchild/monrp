AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/money.mdl")
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
	local cur = self.cur
	if (cur == CUR_USD) then activator:AddMoneyUSD(amount) else if (cur == CUR_EUR) then activator:AddMoneyEUR(amount) end end
	self:Remove()
end

function SpawnMoney(owner, ang, pos, amount, cur)
	local ent = ents.Create("spawned_money")
	ent.Owner = owner
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent.amount=amount
	ent.cur=cur
	ent:Spawn()
	ent:Activate()
	return ent
end
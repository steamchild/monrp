AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SpawnFunction(player,trace)
	if trace.Hit then
		local ent = ents.Create("sent_box")
		ent:SetPos(trace.HitPos + trace.HitNormal * 16)
		ent:Spawn()
		ent:Activate()
		return ent
	end
end

function ENT:Initialize()
	self.Entity:SetModel("models/items/item_item_crate.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.Functions = {{},{}}
	self.Items = {}
	self.svn = 0
	self.log = {}
	local phys = self.Entity:GetPhysicsObject()

	if phys and phys:IsValid() then phys:Wake() end
end


function ENT:Use(activator,caller)
	activator:OpenInterface(self:EntIndex())
end

function ENT:AddLog(str) // Logs Changes to sent to client not all items, but only changes
	self.svn = self.svn + 1
	return table.insert(self.log,str)
end

function ENT:RequestItems(ply,svn) // Called when monrp engine detects incoming stream from client asking items
	self:SendItems(ply,svn,self.svn) //svn - client's svn; self.svn - entity svn
end

function ENT:AddEnt(ent)
	if !ent.Model or !ent.Class then return end
	table.insert(self.Items,ent)
	self:AddLog(ent)
end

function ENT:DelEnt(num)
	self:AddLog(num)
	return table.remove(self.Items,num)
end

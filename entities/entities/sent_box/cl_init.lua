include("shared.lua")

function ENT:Initialize()
	self.MrpSign = "*Empty*"
end

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:Think()
end
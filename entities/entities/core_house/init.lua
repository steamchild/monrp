AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Opened = {}
	self.Currency = 1
	self.SellTime = 60
end




function ENT:OnRemove( )

end


function ENT:GetPlyOpened()
	return self.Opened
end

function ENT:OnPlyOpened(ply)

end

function ENT:OnPlyClosed(ply)

end

function ENT:SetTimer( time )

end

function ENT:GetTime()

end

function ENT:SetCurrency(cur)

end

function ENT:GetCurrency()

end	

function ENT:Tick()

end

function CoreTick()
	for k, v in pairs(ents.FindByClass("core_house")) do
		if (v.Tick) then v:Tick() end
	end
end
hook.Add("Tick", "CoreTick", CoreTick)


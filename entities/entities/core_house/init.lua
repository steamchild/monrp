AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.PlyOpened = {}
	self.Currency = 1
end




function ENT:OnRemove( )

end

function ENT:SetPrice(val)
	self.Price = val
end

function ENT:GetPrice()
	return self.Price
end

function ENT:GetPlyOpened()

end

function ENT:IsSelling()
	if (self.Timer) then return true else return false end
end

function ENT:PlyOpened(ply)
	table.insert(self.PlyOpened,ply)
	local price = self:GetPrice()
	local recep = RecipientFilter()
	for k, v in pairs(self.PlyOpened) do
		recep:AddPlayer(v)
	end
	umsg.Start("aucdata", recep)
		umsg.Short(self:GetIndex())
		if (self:GetCurrency() == 1) then umsg.Bool(false) else umsg.Bool(true) end
		if (price > 32766) then umsg.Long(price) else umsg.Short(price) end
		umsg.Short(self.TimeLeft)
	umsg.End()
end


function ENT:PlyClosed(ply)
	for k, v in pairs(self:GetPlyOpened()) do
		if (v == ply) then table.remove(self.PlyOpened,k) break end
	end
end

function ENT:SetBuyer(ply,price,cur)
	local Set
	if (cur != self:GetCurrency()) then return false end
	if self:GetCurrency() == 1 then
		if (ply.USD < self:GetPrice()+price) then return false end
	else
		if (ply.EUR < self:GetPrice()+price) then return false end
	end
	self.Buyer = ply
	self:AddPrice(price)
end

function ENT:GetBuyer()
	return self.Buyer
end

function ENT:AddPrice(amm)
	if (!self.Price) then self.Price = 0 end
	self.Price = self.Price + amm
end

function ENT:GetPrice()
	return self.Price
end

function ENT:SetTimer( time )
	self.Timer = time
end

function ENT:GetTime()
	return self.TimeLeft
end

function ENT:SetCurrency(cur)
	self.Currency = cur
end

function ENT:GetCurrency()
	return self.Currency
end	

function ENT:Tick()
	if (self:IsSelling()) then
		self.TimeLeft = CurTime() - self.Timer
		if (self.TimeLeft <= 0) then
			if (self:GetBuyer()) then
				self:Sell(self:GetBuyer(),self:GetPrice(),self:GetCurrency())
			end
		end
	end
end

function ENT:Sell(ply,price,cur)
	if (ply) then
		if (cur==1) then
			ply:ForceTakeMoneyUSD(price)
		else
			ply:ForceTakeMoneyEUR(price)
		end
		ply:AddRealty(self)
	end
end

function ENT:MrpSetOwner(ply)
	self.MrpOwner = ply
end

function ENT:MrpGetOwner()
	return self.MrpOwner
end

function CoreTick()
	for k, v in paris(ents.FindByClass("core_house")) do
		if (v.Tick) then v:Tick() end
	end
end
hook.Add("Tick", "CoreTick", CoreTick)


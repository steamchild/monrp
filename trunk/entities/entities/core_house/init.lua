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

function ENT:SetPrice(val)
	self.Price = val
end

function ENT:GetPrice()
	return self.Price
end

function ENT:GetPlyOpened()
	return self.Opened
end

function ENT:IsSelling()
	if (self.Timer) then return true else return false end
end

function ENT:PlyOpened(ply)
	table.insert(self.Opened,ply)
	self:Inform(ply)
end


function ENT:PlyClosed(ply)
	for k, v in pairs(self:GetPlyOpened()) do
		if (v == ply) then table.remove(self.Opened,k) break end
	end
end

function ENT:SetBuyer(ply,price,cur)
	if (cur != self:GetCurrency()) then return false end
	if (!self:GetPrice()) then self:SetPrice(0) end
	if self:GetCurrency() == 1 then
		if (ply.USD < self:GetPrice()+price) then return false end
	else
		if (ply.EUR < self:GetPrice()+price) then return false end
	end
	self.Buyer = ply
	self:AddPrice(price)
	self:SetTimer(CurTime())
	self:Inform()
end

function ENT:GetBuyer()
	return self.Buyer
end

function ENT:AddPrice(amm)
	if (!self.Price) then self.Price = 0 end
	self.Price = self.Price + amm
end

function ENT:SetTimer( time )
	self.Timer = time
	self.TimeLeft = self.SellTime
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
		self.TimeLeft = (self.Timer+self.SellTime) - CurTime()
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
		self.Timer = 0
	end
end

function ENT:MrpSetOwner(ply)
	self.MrpOwner = ply
end

function ENT:MrpGetOwner()
	return self.MrpOwner
end

function ENT:Inform(ply)
	local price = self:GetPrice()
	local recep = RecipientFilter()
	local cur = self:GetCurrency()
	if (ply) then 
		recep:AddPlayer(ply)
	else
		for k, v in pairs(self.Opened) do
			recep:AddPlayer(v)
		end
	end
	umsg.Start("aucdata", recep)
		umsg.Short(self:EntIndex( ))
		if (cur == 1) then umsg.Bool(false) else umsg.Bool(true) end

		if (price) then if (price > 32766) then umsg.Bool(false) umsg.Long(price) else
			umsg.Bool(true) umsg.Short(price) end else umsg.Bool(true) umsg.Short(0) end

		umsg.Short(self.TimeLeft)
	umsg.End()
end

function CoreTick()
	for k, v in pairs(ents.FindByClass("core_house")) do
		if (v.Tick) then v:Tick() end
	end
end
hook.Add("Tick", "CoreTick", CoreTick)


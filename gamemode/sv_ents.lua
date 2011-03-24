local ENTITY = FindMetaTable("Entity")

/*----------------------------------------
	INTERFACE
----------------------------------------*/

function ENTITY:GetChanges(svn)
	local Log = {}
	print("SV_ENTS.SVN:")
	print(svn)

	local k = svn
	while k < self.svn do
		k = k + 1
		Log[k-svn+1] = self.log[k]
	end

	print("sv_ents: analys Log: ")
	PrintTable(Log)

	local adtms = {}
	local removed = {}
	local final = {}

	for k, v in pairs(Log) do
		if (tonumber(v)) then 
			table.insert(removed,v)
		else
			table.insert(adtms,v)
		end
	end
	if (table.Count(adtms) >= table.Count(self.Items)) then mode = false return self.Items, mode else
		mode = true return Log, mode  end
end

function ENTITY:SendItems(ply,svn,entsvn) // Entity calls this functian to send its items to client
	local Log, mode = self:GetChanges(svn)
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveItems", {ENTID,Log,mode,entsvn} )
end

function ENTITY:SendFunctions(ply,functions) // Entity calls this functian to send its items to client
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveFunctions", {ENTID,functions[1]} )
end

function ENTITY:SendCommands(ply,commands) // Entity calls this functian to send its items to client
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveCommands", {ENTID,commands[1]} )
end


/*---------------------------------------------
	USEFULL STUFF
-----------------------------------------------*/

function ENTITY:MrpAddOwner(ply)
	if (!self.MrpOwners) then self.MrpOwners = {} end
	table.insert(self.MrpOwners,ply)
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendAddOwner(self,ply,recep)
end

function ENTITY:MrpRemoveOwner(ply)
	if (!self.MrpOwners) then self.MrpOwners = {} return end
	local removed
	for k, v in pairs(self.MrpOwners) do
		if (v == ply) then table.remove(self.MrpOwners,k) removed = k break end
	end
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendRemoveOwner(self,ply,removed,recep)
end

function ENTITY:OwnSingle(ply)
	self.MrpOwners = {ply}
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendOwnersData(self,recep)
end

function ENTITY:UnOwn()
	self.MrpOwners = {}
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendOwnersData(self,recep)
end

function ENTITY:SetOwnGroup(str)
	self.mrp_door_group = str
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendGroupData(self,recep)
end

function ENTITY:SetOwnerTeams(enum)
	door.TeamOwn = enum
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendTeamData(self,recep)
end

//-----------------------------BUYING SHIT-------------------------------
function ENTITY:SetBuyer(ply)
	self.buyer = ply
end

function ENTITY:GetBuyer()
	return self.buyer
end

function ENTITY:SetPrice(amm)
	self.price = amm
end

function ENTITY:GetPrice()
	return self.price or 0
end

function ENTITY:SetCurrency(cur)
	self.currency = cur
end

function ENTITY:GetCurrency()
	if (!self.currency and self.currency != 0) then self.currency = 1 end
	return self.currency
end

function ENTITY:Buy()
	if (!self.buyer or !self.price or !self.currency) then return end
	if self.buyer:TakeMoney(self.price,self.currency) then self:OwnSingle(self.buyer) end
end

function ENTITY:ForceBuy()
	if (!self.buyer or !self.price or !self.currency) then return end
	self:OwnSingle(self.buyer)
	return self.buyer:ForceTakeMoney(self.price,self.currency)
end

function ENTITY:GetNiceName(barticle)
	local name = ""
	name = self:GetName()
	if !name then
		local class = self:GetClass()
		if (string.sub(class,1,4) == "core") then class = string.sub(class,5) end
		name = class
	end
	
	if barticle and (table.HasValue({e,y,u,i,o,a},string.sub(name,1,1))) then
		name = "an "..name else name = "a "..name
	end
	return name
end
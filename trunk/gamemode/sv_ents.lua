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

function ENTITY:SendItems(ply,svn,entsvn) // Entity calls this function to send its items to client
	local Log, mode = self:GetChanges(svn)
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveItems", {ENTID,Log,mode,entsvn} )
end

function ENTITY:SendFunctions(ply,functions) // Entity calls this function to send its items to client
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveFunctions", {ENTID,functions[1]} )
end

function ENTITY:SendCommands(ply,commands) // Entity calls this function to send its items to client
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
	SendDoorAddOwner(self,ply,recep)
end

function ENTITY:MrpRemoveOwner(ply)
	if (!self.MrpOwners) then self.MrpOwners = {} return end
	local removed
	for k, v in pairs(self.MrpOwners) do
		if (v == ply) then table.remove(self.MrpOwners,k) removed = k break end
	end
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendDoorRemoveOwner(self,ply,removed,recep)
end

function ENTITY:SetMrpDoorGroup(str)
	self.mrp_door_group = str
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendDoorGroupData(self,recep)
end

function ENTITY:SetDoorOwnerTeams(enum)
	door.TeamOwn = enum
	local recep = RecipientFilter()
	recep:AddAllPlayers()
	SendDoorTeamData(self,recep)
end
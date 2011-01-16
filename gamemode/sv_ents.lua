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
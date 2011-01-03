local ENTITY = FindMetaTable("Entity")

/*----------------------------------------
	INTERFACE
----------------------------------------*/

function ENTITY:GetChanges(svn)
	local Log = {}
	for k=svn, self.svn do
		Log[k-svn+1] = self.log[k]
	end
	print("sv_ents/Log: ")
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

	local added = adtms

	for k, rem in pairs(removed) do
		local match = 0
		for k, add in pairs(adtms) do
			if (rem == add.num) then match = k break end
		end
		if (match != 0) then table.remove(adtms,match) else
			table.insert(final,rem)
		end
		InvDeleted(adtms,rem)
	end

	local mode
	if (table.Count(adtms) >= table.Count(self:GetItems())) then
		mode = false final = self:GetItems()
	else
		mode = true table.Add(final,adtms)
	end
	return final, mode
end

function ENTITY:SendItems(ply,svn,entsvn) // Entity calls this function to send its items to client
	local Log, mode = self:GetChanges(svn)
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveItems", {ENTID,Log,mode,svn} )
end

function ENTITY:SendFunctions(ply) // Entity calls this function to send its items to client
	local ENTID = self:EntIndex()
	local functions = self:GetFunctionNames()
	datastream.StreamToClients( ply,  "ReceiveFunctions", {ENTID,functions} )
end

/*---------------------------------------------
	USEFULL STUFF
-----------------------------------------------*/

function InvDeleted(ar,num)
	local doremove = true
	for k, v in pairs(ar) do
		if (v.num == num) then doremove = false break end
	end
	if (doremove) then
		for k, v in pairs(ar) do
			if (v.num > num) then v.num = v.num - 1 end
		end
	end
end
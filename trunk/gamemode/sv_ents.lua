local ENTITY = FindMetaTable("Entity")

/*----------------------------------------
	INTERFACE
----------------------------------------*/

function ENTITY:GetChanges(svn)
	if (!self.log) then return end
	if (table.Count(self.log) == svn) then return end
	local exit = {}
	print("svn:")
	print(svn)
	print("PrintTable(svn):")
	if (!tonumber(svn)) then PrintTable(svn) else print(svn) end
	local j = 0
	local changes = {}
	local added = {}
	local removed = {}
	for k=svn+1, table.Count(self.log) do
		j = j + 1
		changes[j] = self.log[k]
	end
	for k, v in pairs(changes) do
		if (!tonumber(v)) then
			local pos
			for i,n in pairs(self.Items) do
				if (n == v) then pos = k end
			end
			if (pos) then table.insert(added,pos) end
		end
	end
	
	for k, v in pairs(changes) do
		local numb = tonumber(v)
		if (numb) then
			table.insert(removed,-numb)
		end
	end

	for k, v in pairs(added) do
		for i, n in pairs(removed) do
			if (n == v) then added[k] = nil removed[n] = nil end
		end
	end
	for k, v in pairs(added) do
		if (v) then added[k] = self.Items[v] end
	end
	exit = table.Add(removed,added)
	print("Changes: ")
	PrintTable(exit)
	return exit
end

function ENTITY:SendItems(ply,svn,entsvn) // Entity calls this function to send its items to client
	local Log = self:GetChanges(svn)
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveItems", {ENTID,Log,entsvn} )
end
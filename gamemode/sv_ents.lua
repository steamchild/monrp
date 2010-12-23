local ENTITY = FindMetaTable("Entity")

/*----------------------------------------
	INTERFACE
----------------------------------------*/

function ENTITY:GetChanges(svn)
	return self:GetItems()
end

function ENTITY:SendItems(ply,svn,entsvn) // Entity calls this function to send its items to client
	local Log = self:GetChanges(svn)
	local ENTID = self:EntIndex()
	datastream.StreamToClients( ply,  "ReceiveItems", {ENTID,Log,-1} )
end

function ENTITY:SendFunctions(ply) // Entity calls this function to send its items to client
	local ENTID = self:EntIndex()
	local functions = self:GetFunctionNames()
	datastream.StreamToClients( ply,  "ReceiveFunctions", {ENTID,functions} )
end
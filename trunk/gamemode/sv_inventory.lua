function RequestItems( ply, handler, id, encoded, decoded )
	local ent = Entity(decoded[1])
	local svn = decoded[2]
	if (ent.RequestItems ) then ent:RequestItems(ply,svn) end
end
datastream.Hook( "RequestItems", RequestItems );
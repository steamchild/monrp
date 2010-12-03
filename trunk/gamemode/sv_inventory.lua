function RequestItems( ply, handler, id, encoded, decoded )
	local ent = Entity(decoded)
	if (ent.RequestItems ) then ent:RequestItems(ply) end
end
datastream.Hook( "RequestItems", RequestItems );
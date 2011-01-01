function CallOpen( ply, handler, id, encoded, decoded ) // Client opened interface
	local ent = Entity(decoded[1])
	local svn = decoded[2]
	if (ent.CallOpen ) then ent:CallOpen(ply,svn) end
end
datastream.Hook( "CallOpen", CallOpen );

function CallClose( ply, handler, id, encoded, decoded ) // Client opened interface
	local ent = Entity(decoded)
	if (ent.CallClose ) then ent:CallClose(ply) end
end
datastream.Hook( "CallClose", CallClose );

function CallFunction( ply, handler, id, encoded, decoded ) // Client requesting items
	local ent = Entity(decoded[1])
	local Toggled = decoded[2]
	local Toggled2 = table.Copy(Toggled)
	print("SERVER TOGGLED: ")
	PrintTable(Toggled2)
	local func = decoded[3]
	if (ent and ent:IsValid()) then
		ent.ToggleBuf = Toggled2
		for k, v in pairs(ent:GetFunctionNames()) do
			if (func == v) then print("CALLED") ent:GetFunctions()[k](ent,1) end
		end
	end
end
datastream.Hook( "CallFunction", CallFunction );

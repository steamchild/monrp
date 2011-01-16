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
	print("SV_INVENTORY: SERVER TOGGLED: ")
	PrintTable(Toggled2)
	local func = decoded[3]
	if (ent and ent:IsValid()) then
		for k, v in pairs(ent:GetFunctionNames()) do
			if (func == v) then print("SV_INVENTORY: CALLED") ent:GetFunctions()[k](ent,ply,Toggled2) end
		end
	end
end
datastream.Hook( "CallFunction", CallFunction );

function CallCommand( ply, handler, id, encoded, decoded ) // Client requesting items
	print("SV_CALLCOMMAND CALLED")
	local ent = Entity(decoded[1])
	local cmd = decoded[2]
	if (ent and ent:IsValid()) then
		for k, v in pairs(ent:GetCommandNames()) do
			if (cmd == v) then print("SV_INVENTORY: CALLED") ent:GetCommands()[k](ent,ply) end
		end
	end
end
datastream.Hook( "CallCommand", CallCommand );

function DoorDataReceive( handler, id, encoded, decoded )
	local door = decoded[1]
	if (decoded[2]) then door.Core = decoded[2] end
	if (decoded[3]) then door.TeamOwn = decoded[3] end
	if (decoded[4]) then door.MrpOwners = decided[4] end

end
datastream.Hook( "DDR", DoorDataReceive );

function DoorAddOwnerDataReceive( handler, id, encoded, decoded )
	print("ADDOWNER DATA RECEIVED")
	local door = decoded[1]
	local ply = decoded[2]
	door:MrpAddOwner(ply)
end
datastream.Hook( "DDRAO", DoorAddOwnerDataReceive );

function DoorRemoveOwnerDataReceive( handler, id, encoded, decoded )
	print("REMOVEOWNER DATA RECEIVED")
	local door = decoded[1]
	local ply = decoded[2]
	local k = decoded[3]
	if (k != door:MrpRemoveOwner(ply)) then end
end
datastream.Hook( "DDRRO", DoorRemoveOwnerDataReceive );

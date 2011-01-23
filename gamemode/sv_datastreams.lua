function SendDoorData(door,recep)
	datastream.StreamToClients(recep,"DDR",{door,door.mrp_door_group,door.TeamOwn,door.MrpOwners})
end


function SendDoorGroupData(door,recep)
	datastream.StreamToClients(recep,"DDR",{door, door.mrp_door_group})
end

function SendDoorTeamData(door,recep)
	datastream.StreamToClients(recep,"DDR",{door, nil , door.TeamOwn})
end

function SendDoorOwnersData(door,recep)
	datastream.StreamToClients(recep,"DDR",{door, nil, nil , door.MrpOwners})
end

function SendDoorAddOwner(door,ply,recep)
	datastream.StreamToClients(recep,"DDRAO",{door,ply})
end

function SendDoorRemoveOwner(door,ply,k,recep)
	datastream.StreamToClients(recep,"DDRRO",{door,ply,k})
end
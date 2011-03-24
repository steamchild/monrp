function DoorDataReceive( handler, id, encoded, decoded )
	local door = decoded[1]
	if (decoded[2]) then door.Core = decoded[2] end
	if (decoded[3]) then door.TeamOwn = decoded[3] end
	if (decoded[4]) then door.MrpOwners = decoded[4] end
end
datastream.Hook( "EDR", DoorDataReceive );

function AddOwnerDataReceive( handler, id, encoded, decoded )
	print("ADDOWNER DATA RECEIVED")
	local ent = decoded[1]
	local ply = decoded[2]
	if (!ent or !ply) then return end
	if (!ent.MrpOwners) then ent.MrpOwners = {} end
	ent:MrpAddOwner(ply)
end
datastream.Hook( "EDRAO", DoorAddOwnerDataReceive );

function RemoveOwnerDataReceive( handler, id, encoded, decoded )
	print("REMOVEOWNER DATA RECEIVED")
	local ent = decoded[1]
	local ply = decoded[2]
	local k = decoded[3]
	if (!ent or !ply or !k) then return end
	if (!ent.MrpOwners) then ent.MrpOwners = {} end
	if (k != ent:MrpRemoveOwner(ply)) then end
end
datastream.Hook( "EDRRO", DoorRemoveOwnerDataReceive );

function EntRandomDataReceiver( handler, id, encoded, decoded )
	local ent = decoded[1]
	local keynames = decoded[2]
	local values = decoded[3]
	for k, v in pairs(keynames) do
		ent[v] = values[k]
	end
end
datastream.Hook( "ERDR", EntRandomDataReceiver );

// ------------------------ PLAYER DATA------------------------------
function Stream( handle, id, encoded, decoded )
	for k, v in pairs(decoded[1]) do
		LocalPlayer():SetVar(decoded[1][k],decoded[2][k])
	end
	
	if (LocalPlayer().GroupID) then LocalPlayer().Group = Groups[LocalPlayer().GroupID] end

end
datastream.Hook( "Player_Data", Stream );

//--------------------------------------------------------------------

local function DisplayNotify(msg)
	local txt = msg:ReadString()
	GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

	-- Log to client console
	print(txt)
end
usermessage.Hook("_Notify", DisplayNotify)
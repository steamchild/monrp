function SendDoorData(door,recep)
	datastream.StreamToClients(recep,"EDR",{door,door.Core,door.TeamOwn,door.MrpOwners})
end


function SendGroupData(door,recep)
	datastream.StreamToClients(recep,"EDR",{door, door.Core})
end

function SendTeamData(door,recep)
	datastream.StreamToClients(recep,"EDR",{door, nil , door.TeamOwn})
end

function SendOwnersData(door,recep)
	datastream.StreamToClients(recep,"EDR",{door, nil, nil , door.MrpOwners})
end

function SendAddOwner(door,ply,recep)
	datastream.StreamToClients(recep,"EDRAO",{door,ply})
end

function SendRemoveOwner(door,ply,k,recep)
	datastream.StreamToClients(recep,"EDRRO",{door,ply,k})
end

function SendEntData(ent,keynames,recep)
	local values={}
	for k, v in pairs(keynames) do
		values[k] = ent[v]
	end
	datastream.StreamToClients(recep,"ERDR",{ent,keynames,values})
end

//-----------------------BUYING DOORS--------------------------------

local defdoorprice = 20
local AucUnOwned = CreateConVar( "rl_AuctionUnowned", "1", FCVAR_GAMEDLL )
function BuyEntAttempt( ply, handler, id, encoded, decoded )
	ent = decoded
	local ActEnt
	if (ent.Core) then ActEnt = ent.Core else ActEnt = ent end
	if (ply:MrpIsOwner(ActEnt)) then ply:Notify("You already own this") return end
	if ( !ActEnt:IsForSale() and ActEnt:MrpIsOwned() ) then ply:Notify("This is not for sale") return false end
		if (!ActEnt.Price) then ActEnt.Price = 0 end
		if (!ActEnt.Currency) then ActEnt.Currency = 1 end
		if (ActEnt:IsForSaleAuction() or (!ActEnt:MrpIsOwned() and AucUnOwned) ) then
				print("AUCTION!")
				AucOpn(ply,ActEnt)
		else
			if (ActEnt.Buy) then ActEnt:Buy(ply) else
				if (ply:TakeMoney(ActEnt.Price,ActEnt.Currency)) then
					ActEnt:OwnSingle(ply) return true
				else
					return false
				end
			end
		end
end
datastream.Hook( "BuyEnt", BuyEntAttempt );

function SendMessage(recep,text,id,len)
	umsg.Start("_Notify", recep)
		umsg.String(text)
		umsg.Short(id)
		umsg.Long(len)
	umsg.End()
end
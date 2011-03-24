local AuctionTime = CreateConVar( "mrp_auction_timer", "60", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

function Auc_AddPrice( ply, handler, id, encoded, decoded )
	local ent = decoded[1]
	local amm = decoded[2]
	if (ent and ent:IsValid()) then
		ent:SetPrice(ent:GetPrice()+amm)
		ent:SetBuyer(ply)
		ent.EndTime = CurTime()+AuctionTime:GetInt()
		timer.Simple( AuctionTime:GetInt(), AucTimeEnd, ent) end
	AucDataChanged(ent)
end
datastream.Hook( "Auc_AddPrice", Auc_AddPrice );

function AucOpn(ply,ent)
print("AucOpen entid: "..ent:EntIndex())
	if (ent.AucOpened and table.HasValue(ent.AucOpened,ply)) then return false end
	if (ent and ent:IsValid()) then
		if (ent.OnPlyOpenedAuc) then ent:OnPlyOpenedAuc(ply) end
		if (!ent.AucOpened) then ent.AucOpened = {ply} else
			if !table.HasValue(ent.AucOpened,ply) then table.insert(ent.AucOpened,ply) end
		end
		local recep = RecipientFilter() recep:AddPlayer(ply) AucSendData(recep,ent)
	end
end

function AucClz( ply, handler, id, encoded, decoded )
print("sv_auction: AUC_CLZ")
	local ent = decoded
	if (ent and ent:IsValid()) then
		print("sv_auction: Core Detected")
		if (ent.OnPlyClosed) then ent:OnPlyClosed(ply) end
		if (!ent.AucOpened) then ent.AucOpened = {} else
			for k, v in pairs(ent.AucOpened) do print("REMOVED_LOOP")
				if (v == ply) then print("REMOVED_FINALY") table.remove(ent.AucOpened,k) break end
			end
		end
	end
end
datastream.Hook( "AucClz", AucClz );

function AucSendData(recep,ent)
	local price = ent:GetPrice()
	local cur = ent:GetCurrency()
	local id = ent:EntIndex() print("AucSendData entid: "..id)
print("sv_auction: DATASENDED")
	umsg.Start("aucdata", recep)
		if (cur == 1) then umsg.Bool(false) else umsg.Bool(true) end
		umsg.Long(price)
		umsg.Long(ent.EndTime)
		umsg.Long(id)
	umsg.End()
end

function AucDataChanged(ent)
	recep = RecipientFilter()
	if (ent.AucOpened) then 
		for k, v in pairs(ent.AucOpened) do
			recep:AddPlayer(v)
		end
	end
	AucSendData(recep,ent)
end

function AucTimeEnd(ent)
	ent:ForceBuy()
	if (ent.OnBuy) then ent:OnBuy() end
	ent.buyer:Notify("You have just bought "..ent:GetNiceName(true))
end
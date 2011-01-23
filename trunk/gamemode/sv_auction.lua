CreateConVar( "mrp_auction_timer", "60", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

function Auc_AddPrice( ply, handler, id, encoded, decoded )
	local core = decoded[1]
	local amm = decoded[2]
	if (!core:GetPrice()) then core:SetPrice(amm) else
		core:SetBuyer(ply)
		core:AddPrice(amm)
		core:SetTimer(CurTime())
	end
end
datastream.Hook( "Auc_AddPrice", Auc_AddPrice );

function AucOpn( ply, handler, id, encoded, decoded )
	local core = decoded
	if (core and core:IsValid()) then
		core:PlyOpened(ply)
	end
end
datastream.Hook( "AucOpn", AucOpn );

function AucClz( ply, handler, id, encoded, decoded )
	local core = decoded
	if (core and core:IsValid()) then
		core:PlyClosed(ply)
	end
end
datastream.Hook( "AucClz", AucClz );
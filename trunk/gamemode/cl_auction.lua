function OpenAuction(data)
print("cl_auction_DataRECIEVED")
	local curid = data:ReadBool()
	local price = data:ReadLong() print("price: "..price)
	local EndTime = data:ReadLong() print("EndTime: "..EndTime)
	local entid = data:ReadLong() print("entid: " ..entid)
	
	local ent = Entity(entid)
	local cur
	if (curid) then cur = 0 else cur = 1 end

	ent.Price = price
	ent.Currency = cur
	ent.EndTime = EndTime
	if (VGUI_AUCTIONS[entid] and VGUI_AUCTIONS[entid]:IsValid() ) then
		VGUI_AUCTIONS[entid]:RefreshData()
	else
		local auc = vgui.Create("menu_auction")
			auc:SetEnt(ent)
			auc:RefreshData()
			VGUI_AUCTIONS[entid] = auc
	end
end
usermessage.Hook( "aucdata", OpenAuction )

VGUI_AUCTIONS = {}
local ENTITY = FindMetaTable("Entity")

//--------------------------------------------------
//	SIGNS
//--------------------------------------------------

function DrawSigns()
	if (!LocalPlayer()) then return end
	local Eyes = LocalPlayer():EyePos()
	local Found = ents.FindInSphere(Eyes,250)
	for k , v in pairs(Found) do
		if (v.MrpSign) then 
			local BBCent = v:OBBCenter()
			BBCent:Rotate(v:GetAngles())
			local RealPos = BBCent+v:GetPos()
			local ScreenPos = RealPos:ToScreen()
			if (ScreenPos.visible) then
				if (v.NextRender == nil) then v.NextRender = 0 end
				if (CurTime() > v.NextRender) then
					local tracedata = {}
					tracedata.start = RealPos
					tracedata.endpos = Eyes
					tracedata.filter = {v,LocalPlayer()}
					local trace = util.TraceLine( tracedata )
					v.NextRender = CurTime()+0.01
					v.visible = !trace.Hit
				end
				if (v.visible) then
					local fade = (250-Eyes:Distance(RealPos))/100
					if (fade < 0) then fade = 0 end
					if (fade > 1) then fade = 1 end
					local dotx=(ScreenPos.x-ScrW()/2)/(ScrW()/2)
					local doty=(ScreenPos.y-ScrH()/2)/(ScrH()/2)
					local dot = 1-math.sqrt(dotx*dotx+doty*doty)
					dot = dot*1.5
					if (dot < 0) then dot = 0 end
					if (dot > 1) then dot = 1 end
					BBCent:Rotate(v:GetAngles())
					local izi = {}
						izi.pos = {}
						izi.pos[1] = ScreenPos.x
						izi.pos[2] = ScreenPos.y
						izi.color = Color(255,255,255,fade*dot*255)
						izi.text = v.MrpSign
						izi.font = "TargetID"
						izi.xalign = TEXT_ALIGN_CENTER
						izi.yalign = TEXT_ALIGN_CENTER
					draw.Text( izi )
					draw.TextShadow( izi, 1,fade*dot*255)
				end
			end
		end
		local traceent = LocalPlayer():GetEyeTrace().Entity
		if (v.MrpSignEasy and traceent == v) then
			local izi = {}
			izi.pos = {}
			izi.pos[1] = ScrH()/2-26
			izi.pos[2] = ScrW()/2
			izi.color = Color(255,255,255,255)
			izi.text = v.MrpSignEasy
			izi.font = "TargetID"
			izi.xalign = TEXT_ALIGN_CENTER
			izi.yalign = TEXT_ALIGN_CENTER
			draw.Text( izi )
			draw.TextShadow( izi, 1, 200 )
		end
	end


	local traceent = LocalPlayer():GetEyeTrace().Entity
	local txtoffset = 32
	local Color1 = Color(255,255,255,255)
	local Color2 = Color(100,0,0,255)
	local centerx = ScrW()/2
	local centery = ScrH()/2-txtoffset
	if (traceent and traceent:IsValid() and traceent:IsDoor()) then
		if (traceent:IsOwner(LocalPlayer()) ) then
			local names
			if (traceent:MrpGetOwners()) then
				names = ""
				for k, v in pairs(traceent:MrpGetOwners()) do
					names = names..v:GetName().."\n"
				end
			end
			local text = "Owned By:\n"..names
					draw.DrawText(text, "TargetID", centerx , centery+1 , Color(0, 0, 0, 200), 1)
					draw.DrawText(text, "TargetID", centerx, centery, Color(255, 255, 255, 200), 1)
		else
			if (!names) then 
					draw.DrawText("Not Owned", "TargetID", centerx , centery+1 , Color(0, 0, 0, 255), 1)
					draw.DrawText("Not Owned", "TargetID", centerx, centery, Color(128, 30, 30, 255), 1)
			else 
					draw.DrawText("You Dont Own This", "TargetID", centerx , centery+1 , Color(0, 0, 0, 255), 1)
					draw.DrawText("You Dont Own This", "TargetID", centerx, centery, Color(128, 30, 30, 255), 1)
			end
		end
	end
end
hook.Add("HUDPaint", "DrawSigns", DrawSigns);


//--------------------------------------------------
//	INTERFACE
//--------------------------------------------------
function DrawInterFace()
	local Width = 500
	local Height = 800
	PlayerInv = INVENTORY:Create(ScrW()/2-Width/2,ScrH()/2-Height/2,Width,Height,LocalPlayer())
	for k=1,40 do
		PlayerInv:AddIcon(LocalPlayer():GetModel())
	end
	for k=1,20 do
		PlayerInv:RemoveItem(k)
	end
end

concommand.Add( "rl_drawinterface", DrawInterFace )

function OpenInterface(ID)
	local Width = 100
	local Height = 160
	Inv = INVENTORY:Create(ScrW()/2-Width/2,ScrH()/2-Height/2,Width,Height,ID)
end

function OpenCmd( data ) // Server asks to open interface
	local ID = data:ReadLong()
	OpenInterface(ID)
end
usermessage.Hook( "OpenInterface", OpenCmd );

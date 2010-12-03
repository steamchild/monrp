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
end
hook.Add("HUDPaint", "DrawSigns", DrawSigns);


//--------------------------------------------------
//	INTERFACE
//--------------------------------------------------
function DrawInterFace()
	local Width = 500
	local Height = 800
	inv = INVENTORY:Create(ScrW()/2-Width/2,ScrH()/2-Height/2,Width,Height,LocalPlayer())
	for k=1,40 do
		inv:AddIcon(LocalPlayer():GetModel())
	end
	for k=1,20 do
		inv:RemoveItem(k)
	end
end

concommand.Add( "rl_drawinterface", DrawInterFace )

function OpenInterface(ID)
	local Width = 100
	local Height = 160
	Inv = INVENTORY:Create(ScrW()/2-Width/2,ScrH()/2-Height/2,Width,Height,ID)
end

function OpenCmd( data )
	local ID = data:ReadLong()
	OpenInterface(ID)
end
usermessage.Hook( "OpenInterface", OpenCmd );

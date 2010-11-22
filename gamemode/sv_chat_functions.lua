function DropUSD(ply,arg,vel)
	local amount = tonumber(arg) or 0
	if (amount>0) then
		if ply:TakeMoneyUSD(amount) then 
			local trace = ply:GetEyeTraceNoCursor()
			local dist = 50
			if (vel) then dist=25 end
			local ang
			local pos
			if trace.Hit and trace.StartPos:Distance(trace.HitPos)<dist then
				ang = trace.HitNormal:Angle():Up()
				pos = trace.HitPos+trace.HitNormal*3
			else 
				ang = ply:GetAngles() 
				pos = ply:EyePos()+trace.Normal*dist
			end
			local money=SpawnMoney(ply, ang, pos, amount, CUR_USD) 
			if (vel) then money:GetPhysicsObject():AddVelocity( vel*trace.Normal ) end
		end 
	end
end
AddChatCommand("/dropusd",DropUSD)
AddChatCommand("/usd",DropUSD)

function DropEUR(ply,arg,vel)
	local amount = tonumber(arg) or 0
	if (amount>0) then
		if ply:TakeMoneyEUR(amount) then 
			local trace = ply:GetEyeTraceNoCursor()
			local dist = 50
			if (vel) then dist=25 end
			local ang
			local pos
			if trace.Hit and trace.StartPos:Distance(trace.HitPos)<dist then
				ang = trace.HitNormal:Angle():Up()
				pos = trace.HitPos+trace.HitNormal*3
			else 
				ang = ply:GetAngles() 
				pos = ply:EyePos()+trace.Normal*dist
			end
			local money=SpawnMoney(ply, ang, pos, amount, CUR_EUR) 
			if (vel) then money:GetPhysicsObject():AddVelocity( vel*trace.Normal ) end
		end 
	end
end
AddChatCommand("/dropeur",DropEUR)
AddChatCommand("/eur",DropEUR)

function ThrowUSD(ply,arg)
	DropUSD(ply,arg,650)
end
AddChatCommand("/throwusd",ThrowUSD)

function ThrowEUR(ply,arg)
	DropEUR(ply,arg,650)
end
AddChatCommand("/throweur",ThrowEUR)

function PutUSD(ply,arg)
	DropUSD(ply,arg,150)
end
AddChatCommand("/putusd",PutUSD)

function PutEUR(ply,arg)
	DropEUR(ply,arg,150)
end
AddChatCommand("/puteur",PutEUR)

function DropWep(ply,arg)
	if (ply:GetActiveWeapon()) then ply:MrpDropWeapon(ply:GetActiveWeapon()) end
end
AddChatCommand("/drop",DropWep)
AddChatCommand("/dropweapon",DropWep)
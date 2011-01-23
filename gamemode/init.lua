GM.Name		= "MonRp"
GM.Author	= "eMe"
GM.Email	= "fao10@yandex.ru"
GM.Website  = ""

DeriveGamemode("sandbox")
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_chat.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_functions.lua" )
AddCSLuaFile( "addstuff.lua" )
AddCSLuaFile( "cl_functions.lua" )
AddCSLuaFile( "cl_inventory.lua" )
AddCSLuaFile( "cl_datastreams.lua" )
AddCSLuaFile( "cl_ents.lua" )
AddCSLuaFile( "cl_special.lua" )

//VGUI
AddCSLuaFile( "vgui/DPanelListEnts.lua" )
AddCSLuaFile( "vgui/DInvIcon.lua" )
AddCSLuaFile( "vgui/mrp_vgui.lua" )
 
include( "shared.lua" )
include( "sv_player.lua" )
include( "addstuff.lua" )
include( "sh_functions.lua" )
include( "sv_chat.lua" )
include( "sv_chat_functions.lua" )
include( "sv_inventory.lua" )
include( "sv_ents.lua" )
include( "sv_auction.lua" )
include( "sv_datastreams.lua" )

local meta = FindMetaTable("Entity")

CreateConVar( "rl_showdeathnotice", "1", FCVAR_GAMEDLL )

function GM:PlayerSpawn( ply )
if (ply.Group == nil) then ply.Group = Groups[1] end
	ply:CrosshairEnable()
	ply:UnSpectate()
	self.BaseClass:PlayerSpawn( ply )
	ply:SetGravity(1)  
	ply:SetMaxHealth(ply.Group.Health, true )
	ply:SetHealth(ply.Group.Health)

	ply:SetWalkSpeed(ply.Group.WalkSpeed)  
	ply:SetRunSpeed(ply.Group.RunSpeed)

	ply.NormRunSpeed = ply.Group.RunSpeed
	ply.NormWalkSpeed = ply.Group.WalkSpeed
	ply.NormHungerSpeed = HungerSpeed
	ply.NormFatigueSpeed = FatigueSpeed
	ply.LastHungerCalc = CurTime()
	ply.LastFatigueCalc = CurTime()
	ply.HungerSpeed = HungerSpeed
	ply.FatigueSpeed = FatigueSpeed
	ply.Fatigue = 100
	ply.Hunger = 100
	
end
 
function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(2)
	ply:Spectate()
	ply.Group = Groups[2]
	if (!ply:LoadData()) then 
		ply.USD = 500 
		ply.EUR = 0 
		ply.Fatigue = 100 
		ply.Hunger = 100 
		ply.RPModel = ply.Group.Models[ math.random(1,table.Count(ply.Group.Models))]
		ply.MrpName=ply:GetName()
		ply:WriteValues(PlayerSaveKeyValues) 
	end
	ply:SendData( {"USD","EUR","GroupID","Fatigue","Hunger","MrpName"},{ply.USD,ply.EUR,ply.Group.ID,ply.Fatigue,ply.Hunger,ply.MrpName} )
	local recep = RecipientFilter()
		recep:AddPlayer(ply)
	for k, v in pairs(ents.FindDoors()) do
		v:SendDoorData(door,recep)
	end
	ply:SetName("unknown")
end
 
 
function GM:PlayerLoadout( ply )
	for k , v in pairs(ply.Group.Weapons) do
		ply:Give(v)
	end
end

function GM:PlayerSetModel(ply)
	local Model = ply.RPModel
	util.PrecacheModel(Model)
	ply:SetModel(Model)
end

function GM:PlayerDisconnected( ply )
	ply:WriteValues(PlayerSaveKeyValues)
end

function GM:Think()
	for k , v in pairs(player.GetAll()) do
		if (CurTime() > MrpOneSecTick) then
			v:CalcHunger()
			v:CalcFatigue()
		end
		if (v.SpeedRegenTime) then 
			v.SpeedRegenTime = v.SpeedRegenTime-1
			local smooth = 30
			local runsm = (v.NormRunSpeed/2)/smooth*(smooth-v.SpeedRegenTime)
			local walksm = (v.NormWalkSpeed/2)/smooth*(smooth-v.SpeedRegenTime)
			if (v.SpeedRegenTime<smooth) then v:SetRunSpeed(v.NormRunSpeed/2+runsm) v:SetWalkSpeed(v.NormRunSpeed/2+walksm) end
			if (v.SpeedRegenTime<=0) then v:SetRunSpeed(v.NormRunSpeed) v:SetWalkSpeed(v.NormWalkSpeed) end
		end
	end
	if (CurTime() > MrpOneSecTick) then
		MrpOneSecTick = CurTime()+1
	end
end

function GM:PlayerHurt( victim, Attacker, Health, Damage)
		victim:HitSpeed(60)
end 

function GM:KeyPress(ply, key)
	if (key == IN_JUMP and SERVER) then
		timer.Create( "HitSpeed_timer", 0.6, 1, function()
			ply:HitSpeed(60)
		end )
	end
end

function GM:OnPlayerHitGround( ply )
	if ply.SpeedRegenTime then
		if SERVER and ply.SpeedRegenTime > 100 then 
			if timer.IsTimer("HitSpeed_timer") then timer.Destroy("HitSpeed_timer") end
			ply.SpeedRegenTime = 100 
		end
	end
end

function GM:PlayerSay( player, text)
	MonrpDoSay(player,text)
	return ""
end

local WEAPON=FindMetaTable("Weapon")

HOOK_DEPLOY = true
function GMDeploy(wep)
	if (wep.Primary and wep.Primary.Ammo2 and wep.Primary.Ammo2 != "none" and wep.Owner) then
		local hazammoprim = (wep.Owner:GetAmmoCount(wep.Primary.Ammo2) != 0) or wep:Clip1() != 0 
		if (hazammoprim) then wep.Primary.Ammo = wep.Primary.Ammo2 end
	end
	if (wep.Secondary and wep.Secondary.Ammo2 and wep.Secondary.Ammo2 != "none" and wep.Owner) then
		local hazammosec = (wep.Owner:GetAmmoCount(wep.Secondary.Ammo2) != 0) or wep:Clip2() != 0
		if (hazammosec) then wep.Secondary.Ammo = wep.Secondary.Ammo2 end
	end
end

HOOK_HOLSTER = true
function GMHolster(wep)
	if (wep.Owner and wep.Primary) then 
		if (wep.Primary.Ammo != "none" and wep.Primary.Ammo2 ) then
			if (wep.Owner:GetAmmoCount(wep.Primary.Ammo) == 0 and wep:Clip1() == 0) then 
				wep.Primary.Ammo = "none" 
			end
		end
		if (wep.Secondary.Ammo != "none" and wep.Secondary.Ammo2 ) then
			if (wep.Owner:GetAmmoCount(wep.Secondary.Ammo) == 0 and wep:Clip1() == 0) then 
				wep.Secondary.Ammo = "none" 
			end
		end
	end
end

function GM:WeaponEquip(wep)
	timer.Simple(0, function() 
		GMHolster(wep)
	end) 
end

function GM:AmmoEquip()
	print("Ammo Equiped")
end


function GM:AmmoPick()
	print("Ammo Picked")
end

function GM:AmmoPickup()
	print("Ammo Pick uped")
end

function GM:AcceptStream ( pl, handler, id )
	if handler == "RequestItems" then
		if (!pl.LastRequest) then pl.LastRequest = 0 end
		if (pl.LastRequest<CurTime()-0.2) then pl.LastRequest = CurTime() return true end
	end
	if handler == "CallFunction" or handler == "CallCommand" or handler == "Auc_AddPrice" 
	or handler == "AucClz" or handler == "AucOpn"  then
		return true 
	end
	return false
end

function GM:EntityKeyValue(  ent,  key,  value )
	if (string.sub(key,0,4) == "lua_") then
		print("LUA_ DETECTED: "..key)
		ent[ string.sub(key,5) ]=value
	end
end
 
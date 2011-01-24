if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Keys"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "eMe"
SWEP.Instructions = "Left click to lock. Right click to unlock"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	ent = self.Owner:GetEyeTrace().Entity
	if (!ent or !ent:IsValid()) then return end
	if (self.Owner:EyePos():Distance(ent:GetPos()) > 65) then return end
	if (ent:IsDoor()) then
		if (ent:IsOwner(self.Owner)) then
			ent:Fire("lock", "", 0) -- Lock the door immediately so it won't annoy people
			self:EmitSound(self.Sound)
		else
			self.Owner:EmitSound("physics/wood/wood_crate_impact_hard3.wav", 100, math.random(90, 110))
		end
	end
end

function SWEP:SecondaryAttack()
	ent = self.Owner:GetEyeTrace().Entity
	if (!ent or !ent:IsValid()) then return end
	if (self.Owner:EyePos():Distance(ent:GetPos()) > 65) then return end
	if (ent:IsDoor()) then
		if (ent:IsOwner(self.Owner)) then
			ent:Fire("unlock", "", 0) -- unLock the door immediately so it won't annoy people
			self:EmitSound(self.Sound)
		else
			self.Owner:EmitSound("physics/wood/wood_crate_impact_hard3.wav", 100, math.random(90, 110))
		end
	end
end

SWEP.OnceReload = false
function SWEP:Reload()

end


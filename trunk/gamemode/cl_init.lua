require("datastream")

DeriveGamemode("sandbox")

include( 'shared.lua' )
include( 'sh_functions.lua' )
include( 'cl_chat.lua' )
include( 'addstuff.lua' )
include( 'cl_functions.lua' )
include( 'cl_inventory.lua' )
include( 'vgui/mrp_vgui.lua' )

local ArmorMoveTo = 0
local ArmorMoving = 0

function GM:Initialize()

	self.BaseClass:Initialize()
end

BGColorR = CreateClientConVar("rl_hud_background_r", "0", false, false)
BGColorG = CreateClientConVar("rl_hud_background_g", "0", false, false)
BGColorB = CreateClientConVar("rl_hud_background_b", "0", false, false)

MBGAlpha = CreateClientConVar("rl_hud_background_main_a", "120", false, false)
BGAlpha = CreateClientConVar("rl_hud_background_bars_a", "150", false, false)

--Health
HPColorR = CreateClientConVar("rl_hud_health_r", "0", false, false)
HPColorG = CreateClientConVar("rl_hud_health_g", "10", false, false)
HPColorB = CreateClientConVar("rl_hud_health_b", "100", false, false)
HPColorA = CreateClientConVar("rl_hud_health_a", "255", false, false)

HP2ColorR = CreateClientConVar("rl_hud_health2_r", "0", false, false)
HP2ColorG = CreateClientConVar("rl_hud_health2_g", "0", false, false)
HP2ColorB = CreateClientConVar("rl_hud_health2_b", "0", false, false)
HP2ColorA = CreateClientConVar("rl_hud_health2_a", "255", false, false)

HP3ColorR = CreateClientConVar("rl_hud_health3_r", "0", false, false)
HP3ColorG = CreateClientConVar("rl_hud_health3_g", "72", false, false)
HP3ColorB = CreateClientConVar("rl_hud_health3_b", "200", false, false)
HP3ColorA = CreateClientConVar("rl_hud_health3_a", "255", false, false)

HP4ColorR = CreateClientConVar("rl_hud_health4_r", "255", false, false)
HP4ColorG = CreateClientConVar("rl_hud_health4_g", "255", false, false)
HP4ColorB = CreateClientConVar("rl_hud_health4_b", "255", false, false)
HP4ColorA = CreateClientConVar("rl_hud_health4_a", "20", false, false)

--Armor
ARColorR = CreateClientConVar("rl_hud_armor_r", "0", false, false)
ARColorG = CreateClientConVar("rl_hud_armor_g", "10", false, false)
ARColorB = CreateClientConVar("rl_hud_armor_b", "100", false, false)
ARColorA = CreateClientConVar("rl_hud_armor_a", "255", false, false)

AR2ColorR = CreateClientConVar("rl_hud_armor2_r", "0", false, false)
AR2ColorG = CreateClientConVar("rl_hud_armor2_g", "0", false, false)
AR2ColorB = CreateClientConVar("rl_hud_armor2_b", "0", false, false)
AR2ColorA = CreateClientConVar("rl_hud_armor2_a", "255", false, false)


AR3ColorR = CreateClientConVar("rl_hud_armor3_r", "0", false, false)
AR3ColorG = CreateClientConVar("rl_hud_armor3_g", "72", false, false)
AR3ColorB = CreateClientConVar("rl_hud_armor3_b", "200", false, false)
AR3ColorA = CreateClientConVar("rl_hud_armor3_a", "255", false, false)

AR4ColorR = CreateClientConVar("rl_hud_armor4_r", "255", false, false)
AR4ColorG = CreateClientConVar("rl_hud_armor4_g", "255", false, false)
AR4ColorB = CreateClientConVar("rl_hud_armor4_b", "255", false, false)
AR4ColorA = CreateClientConVar("rl_hud_armor4_a", "20", false, false)

--Fatigue
FGColorR = CreateClientConVar("rl_hud_fatigue_r", "0", false, false)
FGColorG = CreateClientConVar("rl_hud_fatigue_g", "10", false, false)
FGColorB = CreateClientConVar("rl_hud_fatigue_b", "100", false, false)
FGColorA = CreateClientConVar("rl_hud_fatigue_a", "255", false, false)

FG2ColorR = CreateClientConVar("rl_hud_fatigue2_r", "0", false, false)
FG2ColorG = CreateClientConVar("rl_hud_fatigue2_g", "0", false, false)
FG2ColorB = CreateClientConVar("rl_hud_fatigue2_b", "0", false, false)
FG2ColorA = CreateClientConVar("rl_hud_fatigue2_a", "255", false, false)

FG3ColorR = CreateClientConVar("rl_hud_fatigue3_r", "0", false, false)
FG3ColorG = CreateClientConVar("rl_hud_fatigue3_g", "72", false, false)
FG3ColorB = CreateClientConVar("rl_hud_fatigue3_b", "200", false, false)
FG3ColorA = CreateClientConVar("rl_hud_fatigue3_a", "255", false, false)

FG4ColorR = CreateClientConVar("rl_hud_fatigue4_r", "255", false, false)
FG4ColorG = CreateClientConVar("rl_hud_fatigue4_g", "255", false, false)
FG4ColorB = CreateClientConVar("rl_hud_fatigue4_b", "255", false, false)
FG4ColorA = CreateClientConVar("rl_hud_fatigue4_a", "20", false, false)

--Hunger
HGColorR = CreateClientConVar("rl_hud_hunger_r", "0", false, false)
HGColorG = CreateClientConVar("rl_hud_hunger_g", "10", false, false)
HGColorB = CreateClientConVar("rl_hud_hunger_b", "100", false, false)
HGColorA = CreateClientConVar("rl_hud_hunger_a", "255", false, false)

HG2ColorR = CreateClientConVar("rl_hud_hunger2_r", "0", false, false)
HG2ColorG = CreateClientConVar("rl_hud_hunger2_g", "0", false, false)
HG2ColorB = CreateClientConVar("rl_hud_hunger2_b", "0", false, false)
HG2ColorA = CreateClientConVar("rl_hud_hunger2_a", "255", false, false)

HG3ColorR = CreateClientConVar("rl_hud_hunger3_r", "0", false, false)
HG3ColorG = CreateClientConVar("rl_hud_hunger3_g", "72", false, false)
HG3ColorB = CreateClientConVar("rl_hud_hunger3_b", "200", false, false)
HG3ColorA = CreateClientConVar("rl_hud_hunger3_a", "255", false, false)

HG4ColorR = CreateClientConVar("rl_hud_hunger4_r", "255", false, false)
HG4ColorG = CreateClientConVar("rl_hud_hunger4_g", "255", false, false)
HG4ColorB = CreateClientConVar("rl_hud_hunger4_b", "255", false, false)
HG4ColorA = CreateClientConVar("rl_hud_hunger4_a", "20", false, false)

--Text
HPTxColorR = CreateClientConVar("rl_hud_health_text_r", "255", false, false)
HPTxColorG = CreateClientConVar("rl_hud_health_text_g", "255", false, false)
HPTxColorB = CreateClientConVar("rl_hud_health_text_b", "255", false, false)
HPTxColorA = CreateClientConVar("rl_hud_health_text_a", "255", false, false)

ARTxColorR = CreateClientConVar("rl_hud_armor_text_r", "255", false, false)
ARTxColorG = CreateClientConVar("rl_hud_armor_text_g", "255", false, false)
ARTxColorB = CreateClientConVar("rl_hud_armor_text_b", "255", false, false)
ARTxColorA = CreateClientConVar("rl_hud_armor_text_a", "255", false, false)

FGTxColorR = CreateClientConVar("rl_hud_fatigue_text_r", "255", false, false)
FGTxColorG = CreateClientConVar("rl_hud_fatigue_text_g", "255", false, false)
FGTxColorB = CreateClientConVar("rl_hud_fatigue_text_b", "255", false, false)
FGTxColorA = CreateClientConVar("rl_hud_fatigue_text_a", "255", false, false)

HGTxColorR = CreateClientConVar("rl_hud_hunger_text_r", "255", false, false)
HGTxColorG = CreateClientConVar("rl_hud_hunger_text_g", "255", false, false)
HGTxColorB = CreateClientConVar("rl_hud_hunger_text_b", "255", false, false)
HGTxColorA = CreateClientConVar("rl_hud_hunger_text_a", "255", false, false)

JBTxColorR = CreateClientConVar("rl_hud_text_job_r", "20", false, false)
JBTxColorG = CreateClientConVar("rl_hud_text_job_g", "150", false, false)
JBTxColorB = CreateClientConVar("rl_hud_text_job_b", "255", false, false)
JBTxColorA = CreateClientConVar("rl_hud_text_job_a", "255", false, false)

JB2TxColorR = CreateClientConVar("rl_hud_text_job_bg_r", "0", false, false)
JB2TxColorG = CreateClientConVar("rl_hud_text_job_bg_g", "0", false, false)
JB2TxColorB = CreateClientConVar("rl_hud_text_job_bg_b", "0", false, false)
JB2TxColorA = CreateClientConVar("rl_hud_text_job_bg_a", "255", false, false)

WALTTxColorR = CreateClientConVar("rl_hud_text_wallet_r", "20", false, false)
WALTTxColorG = CreateClientConVar("rl_hud_text_wallet_g", "150", false, false)
WALTTxColorB = CreateClientConVar("rl_hud_text_wallet_b", "255", false, false)
WALTTxColorA = CreateClientConVar("rl_hud_text_wallet_a", "255", false, false)

WALT2TxColorR = CreateClientConVar("rl_hud_text_wallet_bg_r", "0", false, false)
WALT2TxColorG = CreateClientConVar("rl_hud_text_wallet_bg_g", "0", false, false)
WALT2TxColorB = CreateClientConVar("rl_hud_text_wallet_bg_b", "0", false, false)
WALT2TxColorA = CreateClientConVar("rl_hud_text_wallet_bg_a", "255", false, false)

USDColorR = CreateClientConVar("rl_hud_text_USD_r", "0", false, false)
USDColorG = CreateClientConVar("rl_hud_text_USD_g", "120", false, false)
USDColorB = CreateClientConVar("rl_hud_text_USD_b", "0", false, false)
USDColorA = CreateClientConVar("rl_hud_text_USD_a", "255", false, false)

EURColorR = CreateClientConVar("rl_hud_text_EUR_r", "120", false, false)
EURColorG = CreateClientConVar("rl_hud_text_EUR_g", "120", false, false)
EURColorB = CreateClientConVar("rl_hud_text_EUR_b", "0", false, false)
EURColorA = CreateClientConVar("rl_hud_text_EUR_a", "255", false, false)

HudWidth = CreateClientConVar("rl_hud_width", "150", false, false)
HudHeight = CreateClientConVar("rl_hud_height", "20", false, false)

surface.CreateFont("akbar", 18, 500, true, false, "HudTx")

surface.CreateFont("coolvetica", 18, 400, true, false, "Ñoolvetica18")
surface.CreateFont("coolvetica", 16, 400, true, false, "Ñoolvetica16")

local font = "TargetID"
local fontsize = 18
surface.CreateFont ("TargetID", 12, 400, true, false, "TargetID16")
local smallfont = "TargetID16"
local DistBtwUSDEUR = CreateClientConVar("rl_hud_distbtwUSDnEUR", "24", true, false)

groups = {}

function HudResetTextColor()
RunConsoleCommand("rl_hud_text_job_r", JBTxColorR:GetDefault())
RunConsoleCommand("rl_hud_text_job_g", JBTxColorG:GetDefault())
RunConsoleCommand("rl_hud_text_job_b", JBTxColorB:GetDefault())
RunConsoleCommand("rl_hud_text_job_a", JBTxColorA:GetDefault())

RunConsoleCommand("rl_hud_text_job_bg_r", JB2TxColorR:GetDefault())
RunConsoleCommand("rl_hud_text_job_bg_g", JB2TxColorG:GetDefault())
RunConsoleCommand("rl_hud_text_job_bg_b", JB2TxColorB:GetDefault())
RunConsoleCommand("rl_hud_text_job_bg_a", JB2TxColorA:GetDefault())

RunConsoleCommand("rl_hud_text_wallet_r", WALTTxColorR:GetDefault())
RunConsoleCommand("rl_hud_text_wallet_g", WALTTxColorG:GetDefault())
RunConsoleCommand("rl_hud_text_wallet_b", WALTTxColorB:GetDefault())
RunConsoleCommand("rl_hud_text_wallet_a", WALTTxColorA:GetDefault())

RunConsoleCommand("rl_hud_text_wallet_bg_r", WALT2TxColorR:GetDefault())
RunConsoleCommand("rl_hud_text_wallet_bg_g", WALT2TxColorG:GetDefault())
RunConsoleCommand("rl_hud_text_wallet_bg_b", WALT2TxColorB:GetDefault())
RunConsoleCommand("rl_hud_text_wallet_bg_a", WALT2TxColorA:GetDefault())
end

function HudResetArmorColor()
RunConsoleCommand("rl_hud_armor_r", ARColorR:GetDefault())
RunConsoleCommand("rl_hud_armor_g", ARColorG:GetDefault())
RunConsoleCommand("rl_hud_armor_b", ARColorB:GetDefault())
RunConsoleCommand("rl_hud_armor_a", ARColorA:GetDefault())

RunConsoleCommand("rl_hud_armor2_r", AR2ColorR:GetDefault())
RunConsoleCommand("rl_hud_armor2_g", AR2ColorG:GetDefault())
RunConsoleCommand("rl_hud_armor2_b", AR2ColorB:GetDefault())
RunConsoleCommand("rl_hud_armor2_a", AR2ColorA:GetDefault())

RunConsoleCommand("rl_hud_armor3_r", AR3ColorR:GetDefault())
RunConsoleCommand("rl_hud_armor3_g", AR3ColorG:GetDefault())
RunConsoleCommand("rl_hud_armor3_b", AR3ColorB:GetDefault())
RunConsoleCommand("rl_hud_armor3_a", AR3ColorA:GetDefault())

RunConsoleCommand("rl_hud_armor4_r", AR4ColorR:GetDefault())
RunConsoleCommand("rl_hud_armor4_g", AR4ColorG:GetDefault())
RunConsoleCommand("rl_hud_armor4_b", AR4ColorB:GetDefault())
RunConsoleCommand("rl_hud_armor4_a", AR4ColorA:GetDefault())
end

function HudResetHealthColor()
RunConsoleCommand("rl_hud_health_r", HPColorR:GetDefault())
RunConsoleCommand("rl_hud_health_g", HPColorG:GetDefault())
RunConsoleCommand("rl_hud_health_b", HPColorB:GetDefault())
RunConsoleCommand("rl_hud_health_a", HPColorA:GetDefault())

RunConsoleCommand("rl_hud_health2_r", HP2ColorR:GetDefault())
RunConsoleCommand("rl_hud_health2_g", HP2ColorG:GetDefault())
RunConsoleCommand("rl_hud_health2_b", HP2ColorB:GetDefault())
RunConsoleCommand("rl_hud_health2_a", HP2ColorA:GetDefault())

RunConsoleCommand("rl_hud_health3_r", HP3ColorR:GetDefault())
RunConsoleCommand("rl_hud_health3_g", HP3ColorG:GetDefault())
RunConsoleCommand("rl_hud_health3_b", HP3ColorB:GetDefault())
RunConsoleCommand("rl_hud_health3_a", HP3ColorA:GetDefault())

RunConsoleCommand("rl_hud_health4_r", HP4ColorR:GetDefault())
RunConsoleCommand("rl_hud_health4_g", HP4ColorG:GetDefault())
RunConsoleCommand("rl_hud_health4_b", HP4ColorB:GetDefault())
RunConsoleCommand("rl_hud_health4_a", HP4ColorA:GetDefault())
end

function HudResetFatigueColor()
RunConsoleCommand("rl_hud_fatigue_r", FGColorR:GetDefault())
RunConsoleCommand("rl_hud_fatigue_g", FGColorG:GetDefault())
RunConsoleCommand("rl_hud_fatigue_b", FGColorB:GetDefault())
RunConsoleCommand("rl_hud_fatigue_a", FGColorA:GetDefault())

RunConsoleCommand("rl_hud_fatigue2_r", FG2ColorR:GetDefault())
RunConsoleCommand("rl_hud_fatigue2_g", FG2ColorG:GetDefault())
RunConsoleCommand("rl_hud_fatigue2_b", FG2ColorB:GetDefault())
RunConsoleCommand("rl_hud_fatigue2_a", FG2ColorA:GetDefault())

RunConsoleCommand("rl_hud_fatigue3_r", FG3ColorR:GetDefault())
RunConsoleCommand("rl_hud_fatigue3_g", FG3ColorG:GetDefault())
RunConsoleCommand("rl_hud_fatigue3_b", FG3ColorB:GetDefault())
RunConsoleCommand("rl_hud_fatigue3_a", FG3ColorA:GetDefault())

RunConsoleCommand("rl_hud_fatigue4_r", FG4ColorR:GetDefault())
RunConsoleCommand("rl_hud_fatigue4_g", FG4ColorG:GetDefault())
RunConsoleCommand("rl_hud_fatigue4_b", FG4ColorB:GetDefault())
RunConsoleCommand("rl_hud_fatigue4_a", FG4ColorA:GetDefault())
end

function HudResetHungerColor()
RunConsoleCommand("rl_hud_hunger_r", HGColorR:GetDefault())
RunConsoleCommand("rl_hud_hunger_g", HGColorG:GetDefault())
RunConsoleCommand("rl_hud_hunger_b", HGColorB:GetDefault())
RunConsoleCommand("rl_hud_hunger_a", HGColorA:GetDefault())

RunConsoleCommand("rl_hud_hunger2_r", HG2ColorR:GetDefault())
RunConsoleCommand("rl_hud_hunger2_g", HG2ColorG:GetDefault())
RunConsoleCommand("rl_hud_hunger2_b", HG2ColorB:GetDefault())
RunConsoleCommand("rl_hud_hunger2_a", HG2ColorA:GetDefault())

RunConsoleCommand("rl_hud_hunger3_r", HG3ColorR:GetDefault())
RunConsoleCommand("rl_hud_hunger3_g", HG3ColorG:GetDefault())
RunConsoleCommand("rl_hud_hunger3_b", HG3ColorB:GetDefault())
RunConsoleCommand("rl_hud_hunger3_a", HG3ColorA:GetDefault())

RunConsoleCommand("rl_hud_hunger4_r", HG4ColorR:GetDefault())
RunConsoleCommand("rl_hud_hunger4_g", HG4ColorG:GetDefault())
RunConsoleCommand("rl_hud_hunger4_b", HG4ColorB:GetDefault())
RunConsoleCommand("rl_hud_hunger4_a", HG4ColorA:GetDefault())
end

function HudResetAll()
HudResetArmorColor()
HudResetHealthColor()
HudResetHungerColor()
HudResetFatigueColor()
HudResetTextColor()
RunConsoleCommand("rl_hud_width", HudWidth:GetDefault())
RunConsoleCommand("rl_hud_height", HudHeight:GetDefault())
end

function Clamp(to,cur)
	if (to == nil or cur == nil) then return end
	if (cur > to) then cur = cur - 1 end
	if (cur < to) then cur = cur + 1 end
	return cur
end

function PaintYGrad(X,Y,Width,Height,color1,color2)
	local addred=(color2.r-color1.r)/(Height-1)
	local addgreen=(color2.g-color1.g)/(Height-1)
	local addblue=(color2.b-color1.b)/(Height-1)
	local addalpha=(color2.a-color1.a)/(Height-1)
	local red = color1.r
	local green = color1.g
	local blue = color1.b
	local alpha = color1.a
		for k=0, Height-1 do
			surface.SetDrawColor( red, green, blue, alpha)
			surface.DrawLine(X,Y+k,X+Width,Y+k)
			red=red+addred
			green=green+addgreen
			blue=blue+addblue
			alpha=alpha+addalpha
		end
end

//Draw main capsule function
function PaintCapsule(X,Y,Width,Height,Fullness,bgcolor,color,color2,Board,Alpha,color3,Text,TextColor,Font,Refl)
	X=math.Round(X)
	Y=math.Round(Y)
	Width=math.Round(Width)
	Height=math.Round(Height)
	Board=math.Round(Board)
	local BgAlpha = Alpha*(bgcolor.a/255)
	local ColorAlpha = Alpha*(color.a/255)
	local Color2Alpha = Alpha*(color2.a/255)
	local Color3Alpha = Alpha*(color3.a/255)
	local TextAlpha=Alpha*(TextColor.a/255)
	local TextColorFix = Color(TextColor.r,TextColor.g,TextColor.b,TextAlpha)
	
	surface.SetDrawColor(  bgcolor.r,   bgcolor.g, bgcolor.b, BgAlpha )
	surface.DrawRect(X , Y, Width, Height )
	
	if (Board > 0) then
		surface.SetDrawColor(  color2.r,   color2.g, color2.b, Color2Alpha )
		surface.DrawRect(X , Y, Width, Board )
		surface.DrawRect(X , Y+Height-Board, Width, Board )
		surface.DrawRect(X, Y+Board, Board, Height-Board )
		surface.DrawRect(X+Width-Board, Y+Board, Board, Height-Board )
	end
	
	if (Fullness > 0) then
		local Cont={}
			Cont.Height = Height-Board*2
			Cont.Width = 2+(Fullness*(Width-2))-Board*2
			Cont.X=X+Board
			Cont.Y=Y+Board
		PaintYGrad(Cont.X,Cont.Y,Cont.Width-1,Cont.Height,color,color3)
	
		if (Refl) then
			local Refl2={}
				Refl2.Height = Cont.Height/2
				Refl2.Width = Cont.Width
				Refl2.X = Cont.X
				Refl2.Y = Cont.Y
				Refl2.Color = Refl
				surface.SetDrawColor(Refl2.Color)
				surface.DrawRect(Refl2.X, Refl2.Y, Refl2.Width, Refl2.Height)
		end
	end
	
	if (Text != nil) then
		local struc = {}
		struc.pos = {}
		struc.pos[1] = X+Width/2
		struc.pos[2] = Y+Height/2
		struc.color = TextColorFix
		struc.text = Text
		struc.font = Font
		struc.xalign = TEXT_ALIGN_CENTER
		struc.yalign = TEXT_ALIGN_CENTER
		draw.Text( struc )
	end
	
end

function DrawTextBox(Text,X,Y,Height,Width,font,Board,TxColor,BoxColor,Refl,Texture)

draw.RoundedBox( Board, X, Y, Width, Height, BoxColor)

local Tex = {}
if (Texture != "" and Texture != nil) then
	Tex.mat = surface.GetTextureID(Texture)
	Tex.Width = 18
	Tex.Height = 18
	Tex.Y = Y
	Tex.X = X+Board
else 
	Tex.X = X
	Tex.Width = 0
end

	local struc = {}
		struc.pos = {}
		struc.pos[1] = Tex.X+Tex.Width+Board+2
		struc.pos[2] = Y+Height/2
		struc.color = TxColor
		struc.text = Text -- Text
		struc.font = font
		struc.xalign = TEXT_ALIGN_LEFT -- Horizontal Alignment
		struc.yalign = TEXT_ALIGN_CENTER -- Vertical Alignment
	draw.Text( struc )

if (Texture != "" and Texture != nil) then
	surface.SetTexture(Tex.mat)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(Tex.X, Tex.Y, Tex.Width, Tex.Height)
end

//draw.RoundedBox( Board, X, Y, Width, Height/2, Color(255,255,255,50))
 
end

function RefreshText()
	EURtx = {}
		EURtx.Width = 100
		EURtx.Height = FatigueBar.Height
		EURtx.Y = FatigueBar.Y
		EURtx.X = FatigueBar.X + FatigueBar.Width + HUD.Boarder*3
		EURtx.Font = font
		EURtx.Board = 2
		EURtx.BoxColor = Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt() )
		EURtx.TxColor = Color( EURColorR:GetInt(), EURColorG:GetInt(), EURColorB:GetInt(), EURColorA:GetInt() )
		EURtx.Refl = true
		EURtx.Tex = "hud/icon_euro_small"
	USDtx = {}
		USDtx.Width = EURtx.Width
		USDtx.Height = EURtx.Height
		USDtx.Y = EURtx.Y - USDtx.Height - DistBtwUSDEUR:GetInt()
		USDtx.X = EURtx.X
		USDtx.Font = font
		USDtx.Board = 2
		USDtx.BoxColor = Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt() )
		USDtx.TxColor = Color( USDColorR:GetInt(), USDColorG:GetInt(), USDColorB:GetInt(), USDColorA:GetInt() )
		USDtx.Refl = true
		USDtx.Tex = "hud/icon_dollar_small"
	JobTx = {}
		JobTx.X = USDtx.X
		JobTx.Y = Hic.Y
		JobTx.Color = Color( JBTxColorR:GetInt(), JBTxColorG:GetInt(), JBTxColorB:GetInt(), JBTxColorA:GetInt() )
		JobTx.BgColor = Color( JB2TxColorR:GetInt(), JB2TxColorG:GetInt(), JB2TxColorB:GetInt(), JB2TxColorA:GetInt() )
		JobTx.Text = "Job:"
	WltTx = {}
		WltTx.X = USDtx.X
		WltTx.Y = USDtx.Y - fontsize - 4
		WltTx.Color = Color( WALTTxColorR:GetInt(), WALTTxColorG:GetInt(), WALTTxColorB:GetInt(), WALTTxColorA:GetInt() )
		WltTx.BgColor = Color( WALT2TxColorR:GetInt(), WALT2TxColorG:GetInt(), WALT2TxColorB:GetInt(), WALT2TxColorA:GetInt() )
		WltTx.Text = "Wallet:"
end

--This Functions created in case lua function can consist only 60 upvalues---
function RefreshP3()
	ModelBar={}
		ModelBar.Boarder = 4
		ModelBar.ModelWidth = 64
		ModelBar.ModelHeight = 64
		ModelBar.ModelX = ScrW()-ModelBar.ModelWidth-ModelBar.Boarder*2
		ModelBar.ModelY = ModelBar.Boarder*2

		ModelBar.Width = 200
		ModelBar.Y = ModelBar.ModelY/2
		ModelBar.Height = ModelBar.ModelHeight + ModelBar.Y*2
		ModelBar.X = ModelBar.ModelX+ModelBar.ModelWidth+ModelBar.Boarder-ModelBar.Width
		ModelBar.Board = 6
end

function RefreshP2()
	Hic = {}
		Hic.tex = surface.GetTextureID("hud/icon_cross")
		Hic.texcolor=Color( HPColorR:GetInt(), HPColorG:GetInt(), HPColorB:GetInt(), HPColorA:GetInt() )
		Hic.Width, Hic.Height = 32, 32
		Hic.X = HUD.Left+HUD.Boarder
		Hic.Y = Fatigueic.Y - 8 - Hic.Height
		Hic.shadow = surface.GetTextureID("hud/icon_cross_shadow")
		Hic.shadowcolor = Color( HP3ColorR:GetInt(), HP3ColorG:GetInt(), HP3ColorB:GetInt(), HP3ColorA:GetInt() )
		Hic.refl = surface.GetTextureID("hud/icon_cross_refl")
		Hic.reflcolor = Color( HP4ColorR:GetInt(), HP4ColorG:GetInt(), HP4ColorB:GetInt(), HP4ColorA:GetInt() )
		Hic.boarder = surface.GetTextureID("hud/icon_cross_boarder")
		Hic.boardercolor = Color(0,0,0,255)

	HealthBar = {}
		HealthBar.Height = Hic.Height / 2
		HealthBar.Width = HudWidth:GetInt()
		HealthBar.X = Hic.X + Hic.Width + 6 
		HealthBar.Y = Hic.Y + Hic.Height - HealthBar.Height
		HealthBar.bgcolor = Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt() )
		HealthBar.color = Color( HPColorR:GetInt(), HPColorG:GetInt(), HPColorB:GetInt(), HPColorA:GetInt() )
		HealthBar.color2 = Color( HP3ColorR:GetInt(), HP3ColorG:GetInt(), HP3ColorB:GetInt(), HP3ColorA:GetInt() )
		HealthBar.BoardColor = Color( HP2ColorR:GetInt(), HP2ColorG:GetInt(), HP2ColorB:GetInt(), HP2ColorA:GetInt() )
		HealthBar.Refl = Color( HP4ColorR:GetInt(), HP4ColorG:GetInt(), HP4ColorB:GetInt(), HP4ColorA:GetInt() )
		HealthBar.Board = 1
		HealthBar.Font = font
		HealthBar.TxColor = Color( HPTxColorR:GetInt(), HPTxColorG:GetInt(), HPTxColorB:GetInt(), HPTxColorA:GetInt() )

	ArmorBar = {}
		ArmorBar.Height = 12
		ArmorBar.Width = HealthBar.Width / 2
		ArmorBar.X = HealthBar.X + HealthBar.Width/2 - ArmorBar.Width/2
		ArmorBar.Y = HealthBar.Y - 2 - ArmorBar.Height
		ArmorBar.bgcolor = Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt() )
		ArmorBar.color = Color( ARColorR:GetInt(), ARColorG:GetInt(), ARColorB:GetInt(), ARColorA:GetInt() )
		ArmorBar.color2 = Color( AR3ColorR:GetInt(), AR3ColorG:GetInt(), AR3ColorB:GetInt(), AR3ColorA:GetInt() )
		ArmorBar.BoardColor = Color( AR2ColorR:GetInt(), AR2ColorG:GetInt(), AR2ColorB:GetInt(), AR2ColorA:GetInt() )
		ArmorBar.Refl = Color( AR4ColorR:GetInt(), AR4ColorG:GetInt(), AR4ColorB:GetInt(), AR4ColorA:GetInt() )
		ArmorBar.Board = 1
		ArmorBar.RealY = ArmorBar.Y
		ArmorBar.MaxY = ArmorBar.Y
		ArmorBar.MinY = HealthBar.Y
		ArmorBar.Alpha = 0
		ArmorBar.Font = smallfont
		ArmorBar.TxColor = Color( ARTxColorR:GetInt(), ARTxColorG:GetInt(), ARTxColorB:GetInt(), ARTxColorA:GetInt() )

	Aic = {}
		Aic.tex = surface.GetTextureID("gui/silkicons/shield")
		Aic.Width, Aic.Height = 16, 16
		Aic.X = ArmorBar.X - Aic.Width - 4
		Aic.Y = ArmorBar.Y+ArmorBar.Height-Aic.Height
end

function HudRefresh()
	HUD = {}
		HUD.Bottom = ScrH() - 20
		HUD.Left = 20
		HUD.Boarder = 6

----Fatihue/Hunger Properties----
	Fatigueic = {}
		Fatigueic.tex = surface.GetTextureID("hud/icon_fatigue")
		Fatigueic.texcolor=Color( FGColorR:GetInt(), FGColorG:GetInt(), FGColorB:GetInt(), FGColorA:GetInt() )
		Fatigueic.Width, Fatigueic.Height = 32, 32
		Fatigueic.X = HUD.Left+HUD.Boarder
		Fatigueic.Y = HUD.Bottom - HUD.Boarder - Fatigueic.Height
		Fatigueic.shadow = surface.GetTextureID("hud/icon_fatigue_shadow")
		Fatigueic.shadowcolor = Color( FG3ColorR:GetInt(), FG3ColorG:GetInt(), FG3ColorB:GetInt(), FG3ColorA:GetInt() )
		Fatigueic.refl = surface.GetTextureID("hud/icon_fatigue_refl")
		Fatigueic.reflcolor = Color( FG4ColorR:GetInt(), FG4ColorG:GetInt(), FG4ColorB:GetInt(), FG4ColorA:GetInt() )
		Fatigueic.boarder = surface.GetTextureID("hud/icon_fatigue_boarder")
		Fatigueic.boardercolor = Color(0,0,0,255)

	FatigueBar = {}
		FatigueBar.Height = Fatigueic.Height / 2
		FatigueBar.Width = HudWidth:GetInt()
		FatigueBar.X = Fatigueic.X + Fatigueic.Width + 6 
		FatigueBar.Y = Fatigueic.Y + Fatigueic.Height - FatigueBar.Height
		FatigueBar.bgcolor = Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt() )
		FatigueBar.color = Color( FGColorR:GetInt(), FGColorG:GetInt(), FGColorB:GetInt(), FGColorA:GetInt() )
		FatigueBar.color2 = Color( FG3ColorR:GetInt(), FG3ColorG:GetInt(), FG3ColorB:GetInt(), FG3ColorA:GetInt() )
		FatigueBar.BoardColor = Color( FG2ColorR:GetInt(), FG2ColorG:GetInt(), FG2ColorB:GetInt(), FG2ColorA:GetInt() )
		FatigueBar.Refl = Color( FG4ColorR:GetInt(), FG4ColorG:GetInt(), FG4ColorB:GetInt(), FG4ColorA:GetInt() )
		FatigueBar.Board = 1
		FatigueBar.Font = font
		FatigueBar.TxColor = Color( FGTxColorR:GetInt(), FGTxColorG:GetInt(), FGTxColorB:GetInt(), FGTxColorA:GetInt() )


	HungerBar = {}
		HungerBar.Height = 12
		HungerBar.Width = FatigueBar.Width / 2
		HungerBar.X = FatigueBar.X + FatigueBar.Width/2 - HungerBar.Width/2
		HungerBar.Y = FatigueBar.Y - 2 - HungerBar.Height
		HungerBar.bgcolor = Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt() )
		HungerBar.color = Color( HGColorR:GetInt(), HGColorG:GetInt(), HGColorB:GetInt(), HGColorA:GetInt() )
		HungerBar.color2 = Color( HG3ColorR:GetInt(), HG3ColorG:GetInt(), HG3ColorB:GetInt(), HG3ColorA:GetInt() )
		HungerBar.BoardColor = Color( HG2ColorR:GetInt(), HG2ColorG:GetInt(), HG2ColorB:GetInt(), HG2ColorA:GetInt() )
		HungerBar.Refl = Color( HG4ColorR:GetInt(), HG4ColorG:GetInt(), HG4ColorB:GetInt(), HG4ColorA:GetInt() )
		HungerBar.Board = 1
		HungerBar.Font = smallfont
		HungerBar.TxColor = Color( HGTxColorR:GetInt(), HGTxColorG:GetInt(), HGTxColorB:GetInt(), HGTxColorA:GetInt() )

	Hungeric = {}
		Hungeric.tex = surface.GetTextureID("hud/icon_cookie")
		Hungeric.Width, Hungeric.Height = 16, 16
		Hungeric.X = HungerBar.X - Hungeric.Width - 4
		Hungeric.Y = HungerBar.Y+HungerBar.Height-Hungeric.Height

----Health/Armor Properties----
	RefreshP2()
----Text Properties-----------
	RefreshText()
----Misc Shit----------------
	RefreshP3()
----
	ArmorMoving = ArmorBar.Y
	ArmorMoveTo = ArmorBar.Y
end

function GM:HUDPaint()
if (HUD == nil) then HudRefresh() end
if (LocalPlayer():GetActiveWeapon()) then
	if (LocalPlayer():GetActiveWeapon():GetClass() == "gmod_camera") then
		if (SkinIcon:IsVisible()) then SkinIcon:SetVisible(false) end
		return 
	else
		if (!SkinIcon:IsVisible()) then SkinIcon:SetVisible(true) end
	end
end
	
	USD = LocalPlayer().USD or 0
	EUR = LocalPlayer().EUR or 0
	FG = LocalPlayer().Fatigue or 0 
	HG = LocalPlayer().Hunger or 0
	GroupID = LocalPlayer().GroupID or 1

	SELF = LocalPlayer()
	Group = Groups[GroupID]
	MaxHP = Group.Health
	HP = SELF:Health()
	AR = SELF:Armor()
	if (HP > MaxHP) then HP = MaxHP end

	local topelement = Hic
	local rightelement = HealthBar

	local MainBar = {}
		MainBar.Board = 4
		MainBar.Height = HUD.Bottom-topelement.Y+HUD.Boarder
		MainBar.X = HUD.Left
		MainBar.Width = HUD.Boarder*2+FatigueBar.Width+FatigueBar.X-Fatigueic.X
		MainBar.Y = HUD.Bottom - MainBar.Height
	local MainBar2 = {}
		MainBar2.Board = 4
		MainBar2.Y = USDtx.Y - fontsize - HUD.Boarder
		MainBar2.X = EURtx.X - HUD.Boarder
		MainBar2.Width = EURtx.Width+HUD.Boarder*2
		MainBar2.Height = (EURtx.Y+EURtx.Height+HUD.Boarder)-(MainBar2.Y)


	HealthBar.HP = HP/MaxHP
	ArmorBar.AR = AR/100
	FatigueBar.FG = FG/100
	HungerBar.HG = HG/100
	FatigueBar.Text = "Fatigue: "..math.Round(FG)
	HungerBar.Text = "Hunger: "..math.Round(HG)
	HealthBar.Text = "Health: "..math.Round(HP)
	ArmorBar.Text = "Armor: "..math.Round(AR)
	USDtx.Text = MoneyToString(USD)
	EURtx.Text = MoneyToString(EUR)

	if (AR != 0) then ArmorMoveTo = ArmorBar.MaxY else ArmorMoveTo = ArmorBar.MinY end
	ArmorBar.RealY =  ArmorMoving or ArmorBar.Y
	ArmorBar.Alpha =  255*(math.abs(ArmorBar.MinY-ArmorBar.RealY)/math.abs(ArmorBar.MaxY - ArmorBar.MinY))
	Aic.Y = ArmorBar.RealY+ArmorBar.Height-Aic.Height	
----------Drawing
	
	draw.RoundedBox( MainBar.Board, MainBar.X, MainBar.Y, MainBar.Width, MainBar.Height,
		Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), MBGAlpha:GetInt() ))
	draw.RoundedBox( MainBar2.Board, MainBar2.X, MainBar2.Y, MainBar2.Width, MainBar2.Height,
		Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), MBGAlpha:GetInt() ))	

	surface.SetDrawColor(BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt())
	surface.DrawRect(Hic.X , Hic.Y, Hic.Width, Hic.Height )
	surface.SetDrawColor(HealthBar.BoardColor.r, HealthBar.BoardColor.g, HealthBar.BoardColor.b, HealthBar.BoardColor.a)
	surface.DrawRect(Hic.X-1 , Hic.Y-1, Hic.Width+2, 1 )
	surface.DrawRect(Hic.X-1 , Hic.Y+Hic.Height, Hic.Width+2, 1 )
	surface.DrawRect(Hic.X-1 , Hic.Y, 1, Hic.Height )
	surface.DrawRect(Hic.X+Hic.Width, Hic.Y, 1, Hic.Height )
	surface.SetTexture(Hic.boarder)
	surface.SetDrawColor(Hic.boardercolor.r,Hic.boardercolor.g,Hic.boardercolor.b,Hic.boardercolor.a)
	surface.DrawTexturedRect(Hic.X, Hic.Y, Hic.Width, Hic.Height)
	surface.SetTexture(Hic.tex)
	surface.SetDrawColor(Hic.texcolor.r,Hic.texcolor.g,Hic.texcolor.b,Hic.texcolor.a)
	surface.DrawTexturedRect(Hic.X, Hic.Y, Hic.Width, Hic.Height)
	surface.SetTexture(Hic.shadow)
	surface.SetDrawColor(Hic.shadowcolor.r,Hic.shadowcolor.g,Hic.shadowcolor.b,Hic.shadowcolor.a)
	surface.DrawTexturedRect(Hic.X, Hic.Y, Hic.Width, Hic.Height)
	surface.SetTexture(Hic.refl)
	surface.SetDrawColor(Hic.reflcolor.r,Hic.reflcolor.g,Hic.reflcolor.b,Hic.reflcolor.a)
	surface.DrawTexturedRect(Hic.X, Hic.Y, Hic.Width, Hic.Height)


	surface.SetDrawColor(BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), BGAlpha:GetInt())
	surface.DrawRect(Fatigueic.X , Fatigueic.Y, Fatigueic.Width, Fatigueic.Height )
	surface.SetDrawColor(FatigueBar.BoardColor.r, FatigueBar.BoardColor.g, FatigueBar.BoardColor.b, FatigueBar.BoardColor.a)
	surface.DrawRect(Fatigueic.X-1 , Fatigueic.Y-1, Fatigueic.Width+2, 1 )
	surface.DrawRect(Fatigueic.X-1 , Fatigueic.Y+Fatigueic.Height, Fatigueic.Width+2, 1 )
	surface.DrawRect(Fatigueic.X-1 , Fatigueic.Y, 1, Fatigueic.Height )
	surface.DrawRect(Fatigueic.X+Fatigueic.Width, Fatigueic.Y, 1, Fatigueic.Height )
	surface.SetTexture(Fatigueic.boarder)
	surface.SetDrawColor(Fatigueic.boardercolor.r,Fatigueic.boardercolor.g,Fatigueic.boardercolor.b,Fatigueic.boardercolor.a)
	surface.DrawTexturedRect(Fatigueic.X, Fatigueic.Y, Fatigueic.Width, Fatigueic.Height)
	surface.SetTexture(Fatigueic.tex)
	surface.SetDrawColor(Fatigueic.texcolor.r,Fatigueic.texcolor.g,Fatigueic.texcolor.b,Fatigueic.texcolor.a)
	surface.DrawTexturedRect(Fatigueic.X, Fatigueic.Y, Fatigueic.Width, Fatigueic.Height)
	surface.SetTexture(Fatigueic.shadow)
	surface.SetDrawColor(Fatigueic.shadowcolor.r,Fatigueic.shadowcolor.g,Fatigueic.shadowcolor.b,Fatigueic.shadowcolor.a)
	surface.DrawTexturedRect(Fatigueic.X, Fatigueic.Y, Fatigueic.Width, Fatigueic.Height)
	surface.SetTexture(Fatigueic.refl)
	surface.SetDrawColor(Fatigueic.reflcolor.r,Fatigueic.reflcolor.g,Fatigueic.reflcolor.b,Fatigueic.reflcolor.a)
	surface.DrawTexturedRect(Fatigueic.X, Fatigueic.Y, Fatigueic.Width, Fatigueic.Height)

	surface.SetTexture(Hungeric.tex)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(Hungeric.X, Hungeric.Y, Hungeric.Width, Hungeric.Height)

	PaintCapsule(HealthBar.X,HealthBar.Y,HealthBar.Width,HealthBar.Height,HealthBar.HP,
		HealthBar.bgcolor,HealthBar.color,HealthBar.BoardColor,
		HealthBar.Board,255,HealthBar.color2,HealthBar.Text,HealthBar.TxColor,HealthBar.Font,HealthBar.Refl)

	PaintCapsule(FatigueBar.X,FatigueBar.Y,FatigueBar.Width,FatigueBar.Height,FatigueBar.FG,
		FatigueBar.bgcolor,FatigueBar.color,FatigueBar.BoardColor,
		FatigueBar.Board,255,FatigueBar.color2,FatigueBar.Text,FatigueBar.TxColor,FatigueBar.Font,FatigueBar.Refl)

	PaintCapsule(HungerBar.X,HungerBar.Y,HungerBar.Width,HungerBar.Height,HungerBar.HG,
		HungerBar.bgcolor,HungerBar.color,HungerBar.BoardColor,
		HungerBar.Board,255,HungerBar.color2,HungerBar.Text,HungerBar.TxColor,HungerBar.Font,HungerBar.Refl)

	if (ArmorBar.Alpha != 0) then
		surface.SetTexture(Aic.tex)
		surface.SetDrawColor(255,255,255,ArmorBar.Alpha)
		surface.DrawTexturedRect(Aic.X, Aic.Y, Aic.Width, Aic.Height)
		PaintCapsule(ArmorBar.X,ArmorBar.RealY,ArmorBar.Width,ArmorBar.Height,ArmorBar.AR,
			ArmorBar.bgcolor,ArmorBar.color,ArmorBar.BoardColor,
			ArmorBar.Board,255,ArmorBar.color2,ArmorBar.Text,ArmorBar.TxColor,ArmorBar.Font,ArmorBar.Refl)
	end

	DrawTextBox(USDtx.Text,USDtx.X,USDtx.Y,USDtx.Height,USDtx.Width,USDtx.Font,USDtx.Board,USDtx.TxColor,USDtx.BoxColor,USDtx.Refl,USDtx.Tex)
	DrawTextBox(EURtx.Text,EURtx.X,EURtx.Y,EURtx.Height,EURtx.Width,EURtx.Font,EURtx.Board,EURtx.TxColor,EURtx.BoxColor,EURtx.Refl,EURtx.Tex)

	draw.DrawText(WltTx.Text, font,  WltTx.X,  WltTx.Y, WltTx.Color, TEXT_ALIGN_LEFT)
	draw.DrawText(WltTx.Text, font,  WltTx.X+1,  WltTx.Y+1, WltTx.BGColor, TEXT_ALIGN_LEFT)

	self.BaseClass:HUDPaint()
	
	draw.RoundedBox( ModelBar.Board, ModelBar.X, ModelBar.Y, ModelBar.Width, ModelBar.Height,
		Color( BGColorR:GetInt(), BGColorG:GetInt(), BGColorB:GetInt(), MBGAlpha:GetInt() ))
	
end

function ClDrawPlayerModel(model)
if SkinIcon and model != SkinIcon.model then SkinIcon:SetModel( model ) SkinIcon.model = model return true end

if SkinIcon then return false end; 

SkinIcon = vgui.Create( "Spawnicon")
SkinIcon:SetModel( model )
SkinIcon:SetSize( ModelBar.ModelWidth, ModelBar.ModelHeight )
SkinIcon:SetPos(ModelBar.ModelX,ModelBar.ModelY)
SkinIcon:MakePopup()
SkinIcon:SetKeyBoardInputEnabled(false)
SkinIcon:SetMouseInputEnabled(false)
SkinIcon.model = model

return true

end


function GM:Think( )
		if (ArmorMoving == nil) then ArmorMoving = ArmorBar.Y end
		if (ArmorMoveTo != nil) then
		ArmorMoving = Clamp(ArmorMoveTo,ArmorMoving)
		else print("ArmorMoveTo == nil") end
		if (ModelBar) then ClDrawPlayerModel(LocalPlayer():GetModel()) end
end

function GM:HUDShouldDraw(name)
if name == "CHudHealth" or
		name == "CHudBattery" or
		name == "CHudSuitPower" then
			return false
	else
		return true
	end

end

function Stream( handle, id, encoded, decoded )
for k, v in pairs(decoded[1]) do
	LocalPlayer():SetVar(decoded[1][k],decoded[2][k])
end
end
datastream.Hook( "Player_Data", Stream );

function GM:DrawDeathNotice(x,y)
	self.BaseClass:DrawDeathNotice(x, y)
end

local function DisplayNotify(msg)
	local txt = msg:ReadString()
	GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

	-- Log to client console
	print(txt)
end
usermessage.Hook("_Notify", DisplayNotify)

function GM:Initialize()
	PixVis = util.GetPixelVisibleHandle();
end
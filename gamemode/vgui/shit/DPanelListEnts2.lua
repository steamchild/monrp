/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DPanelListEnts

*/
local PANEL = {}

AccessorFunc( PANEL, "m_bPaintBackground", 		"PaintBackground" )
AccessorFunc( PANEL, "m_bDisabled", 			"Disabled" )
AccessorFunc( PANEL, "m_bgColor", 		"BackgroundColor" )

Derma_Hook( PANEL, "PerformLayout", "Layout", "Panel" )

/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:Init()
	self.HeaderHeight = 20
	self.SY = 0
	self.SX = 0
	self.mulx = 0
	self.muly = 0
	self.RowHeight = 64
	self.CountRowHeight = 18
	self.Rows=0
	self.Items = {}
	self.OldTall = 0
	self.OldWide = 0
	self.Scaping = 0
	self:SetPaintBackground( true )

	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
end

function PANEL:Paint()
	local x, y = self:GetPos()
	local w, h = self:GetSize()
	local skin = self:GetSkin()
	local BgColor = skin.bg_alt1 or Color(255,0,0,255)
	local ForeColor = skin.panel_transback or Color(255,255,0,255)

	surface.SetDrawColor( BgColor.r, BgColor.g, BgColor.b, BgColor.a)
	surface.DrawRect( 0, self.SY, w, h-self.SY )
	local curline
	local k = 0
	while k<self.Rows do 
		k = k + 1
		local height = self.CountRowHeight
		local y = (height*(k-1)) + (self.RowHeight*k) + self.SY
		if (y < self:GetTall()) then
			if (y+height) > self:GetTall() then height=self:GetTall() end
			surface.SetDrawColor( ForeColor.r, ForeColor.g, ForeColor.b, ForeColor.a)
			surface.DrawRect( 0, y, w, height )
		else
			break
		end
	end 
end
/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:PerformLayout( )
	if (self.header) then
		self.header:SetSize(self:GetWide(), self.HeaderHeight )
		self.header:SetPos(0,0)
		self.header:SetText( self:GetName() )
	end
	self.SX = self:GetWide()
	self.ElmCnt, self.Scaping = math.modf(self.SX / self.RowHeight)
	self.Scaping = (self.Scaping* self.RowHeight) / (self.ElmCnt-1)
	self.mulx = self.RowHeight+self.Scaping
	self.muly = self.RowHeight+self.CountRowHeight
	self.OldWide = self:GetWide()
	self.OldTall = self:GetTall()
	self:RefreshIconsPos()
end

function PANEL:EnableHeader( bHeader)
	if (bHeader) then
		self.header = vgui.Create( "DButton", self)
		self.header:SetSize(self:GetWide(), self.HeaderHeight )
		self.header:SetPos(0,0)
		self.header:SetText( self:GetName() )
		self.header.DoClick = function( button )
			chat.AddText("Datastream sucks")
			chat.PlaySound()
		end
		self.header:SetMouseInputEnabled(true)
		self.SY = self.HeaderHeight
	end
	if (!bHeader and self.header) then self.header:Remove() self.SY = 0 end
end

function PANEL:AddIcon(Model)
		local ent = {}
		ent.model = Model
		ent.Icon = vgui.Create("SpawnIcon",self)
		table.insert(self.Items,ent)
		local x, y = self:GetIconPos( table.Count(self.Items) )
		self.Items[table.Count(self.Items)].x = x
		self.Items[table.Count(self.Items)].y = y
		self.Items[table.Count(self.Items)].Icon:SetPos(x, y)
		self.Items[table.Count(self.Items)].Icon:SetModel(ent.model)
end

function PANEL:LoadItems(data)
	local Items = data.Items
	local Wide = data.Wide
	local Tall = data.Tall

	if (!Items) then return false end
	self.Items = Items
	self.OldWide = Wide
	self.OldTall = Tall
	for k, v in pairs(self.Items) do
		v.Icon = vgui.Create("SpawnIcon",self)
		v.Icon:SetModel(v.model)
		v.Icon:SetPos(v.x, v.y)
	end
end

function PANEL:GetSaveData()
	local data = {}
	data.Items = self.Items
	data.Wide = self.OldWide
	data.Tall = self.OldTall	
	return data
end

function PANEL:GetItems()
	return self.Items
end

function PANEL:RefreshIconsPos()
	for k, v in pairs(self.Items) do
		if (v) then 
			v.x, v.y = self:GetIconPos( k )
			if (v.Icon and v.Icon:IsValid( ) ) then v.Icon:SetPos(v.x,v.y) end
		end
	end
local x,y,rows,pos = self:GetIconPos(table.Count(self.Items))
if (table.Count(self.Items)>0) then rows = rows + 1 end
self.Rows = rows
end

function PANEL:GetIconPos(Num)
	if (!self.SX or self.SX == 0) then return end
	local ScapingNum = Num - math.modf((Num-1)/self.ElmCnt) - 1

	local row, pos = math.modf( (Num-1) / self.ElmCnt )
	pos = pos*self.ElmCnt

	local x = pos*self.mulx
	local y = row*self.muly + self.SY

	return x, y, row, pos
end

derma.DefineControl( "DPanelListEnts", "", PANEL, "Panel" )
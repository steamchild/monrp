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
	self.SY = 0
	self.RowHeight = 64
	self.HeaderHeight = 18
	self.List = vgui.Create( "DPanelListFix", self )
	self.List:SetPos(0,self.SY)
	self.List:SetSize(0,0)
	self.List:SetPadding( 0 )
	self.List:EnableHorizontal( true )
	self.List:EnableVerticalScrollbar( true )
end

function PANEL:Paint()
	
end
/*---------------------------------------------------------
	
---------------------------------------------------------*/
function PANEL:PerformLayout( )
	if (!self.SY) then self.SY = 0 end
	local w,h = self:GetSize()
	h = h - self.SY
	self.List:SetSize(w,h)	
	self.List:SetPos(0,self.SY)
	self.List:SetPadding(0)
	if (self.header) then
		self.header:SetSize(self:GetWide(), self.HeaderHeight )
		self.header:SetText( self:GetName() )
	end
end

function PANEL:EnableHeader( bHeader)
	bHeader = false
	if (bHeader) then
		self.header = vgui.Create( "DButton", self)
		self.header:SetSize(self:GetWide(), self.HeaderHeight )
		self.header:SetText( self:GetName() )
		self.header.DoClick = function( button )
			chat.AddText("Datastream sucks")
			chat.PlaySound()
		end
		self.header:SetMouseInputEnabled(true)
		self.SY = self.HeaderHeight
	end
	if (!bHeader and self.header) then self.header:Remove() self.SY = 0 end
	self.List:SetPos(0,self.SY)
	self.List:SetTall(self:GetTall()-self.SY)
end

function PANEL:AddIcon(Model)
	local Icon = vgui.Create("SpawnIcon",self)
		Icon:SetModel(Model)
	self.List:AddItem(Icon)
end

function PANEL:LoadItems(data)
	
end

function PANEL:GetItems()

end

function PANEL:RefreshIconsPos()

end

derma.DefineControl( "DPanelListEnts", "", PANEL, "Panel" )
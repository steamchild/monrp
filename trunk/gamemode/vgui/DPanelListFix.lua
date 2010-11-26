/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	DPanelList
	
	A window.

*/
local PANEL = {}

AccessorFunc( PANEL, "m_bSizeToContents", 		"AutoSize" )
AccessorFunc( PANEL, "m_bStretchHorizontally", 		"StretchHorizontally" )
AccessorFunc( PANEL, "m_bBackground", 			"DrawBackground" )
AccessorFunc( PANEL, "m_bBottomUp", 			"BottomUp" )
AccessorFunc( PANEL, "m_bNoSizing", 			"NoSizing" )

AccessorFunc( PANEL, "Spacing", 	"Spacing" )
AccessorFunc( PANEL, "Padding", 	"Padding" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.HeaderHeight = 18

	self.pnlCanvas 	= vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.InvalidateLayout = function() self:InvalidateLayout() end
	self.pnlCanvas:SetWide(0)
	self.pnlCanvas:SetTall(0)

	self.Items = {}
	self.YOffset = 0
	self.RowSpacing = 4
	self.RowHeight = 64
	self.DoClick = function(self) print(self) print("FUCK") end
	self:SetSpacing( 0 )
	self:SetPadding( 0 )
	self:EnableHorizontal( false )
	self:SetAutoSize( false )
	self:SetDrawBackground( true )
	self:SetBottomUp( false )
	self:SetNoSizing( false )
	
	self:SetMouseInputEnabled( true )
	
	// This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

/*---------------------------------------------------------
   Name: SizeToContents
---------------------------------------------------------*/
function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )
	
end

/*---------------------------------------------------------
   Name: GetItems
---------------------------------------------------------*/
function PANEL:GetItems()

	// Should we return a copy of this to stop 
	// people messing with it?
	return self.Items
	
end

/*---------------------------------------------------------
   Name: EnableHorizontal
---------------------------------------------------------*/
function PANEL:EnableHorizontal( bHoriz )

	self.Horizontal = bHoriz
	
end

/*---------------------------------------------------------
   Name: EnableVerticalScrollbar
---------------------------------------------------------*/
function PANEL:EnableVerticalScrollbar()

	if (self.VBar) then return end
	
	self.VBar = vgui.Create( "DVScrollBar", self )
	
end

/*---------------------------------------------------------
   Name: GetCanvas
---------------------------------------------------------*/
function PANEL:GetCanvas()

	return self.pnlCanvas

end

/*---------------------------------------------------------
   Name: GetCanvas
---------------------------------------------------------*/
function PANEL:Clear()

	for k, panel in pairs( self.Items ) do
	
		if ( panel && panel:IsValid() ) then
				panel:Remove()
		end
		
	end
	
	self.Items = {}

end

/*---------------------------------------------------------
   Name: AddItem
---------------------------------------------------------*/
function PANEL:AddIcon(Model)
	local Icon = vgui.Create("SpawnIcon",self)
		Icon:SetModel(Model)
		Icon.DoClick2 = Icon.DoClick
		Icon.DoClick = self.DoClick
	self:AddItem(Icon)
end
function PANEL:AddItem( item )

	if (!item || !item:IsValid()) then return end

	item:SetVisible( true )
	item:SetParent( self:GetCanvas() )
	item.num = table.insert( self.Items, item )
	self.Items[item.num].num = item.num
	
	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: RemoveItem
---------------------------------------------------------*/
function PANEL:RemoveItem( item )

	for k, panel in pairs( self.Items ) do
	
		if ( panel == item ) then
		
			table.remove( self.Items, k)
			
			panel:Remove()
		
			self:InvalidateLayout()
		
		end
	
	end

end
/*---------------------------------------------------------
   Name: Rebuild
---------------------------------------------------------*/
function PANEL:SetRowSpacing(Num)
	self.RowSpacing = Num
end
/*---------------------------------------------------------
   Name: Rebuild
---------------------------------------------------------*/
function PANEL:Rebuild()

	local Offset = 0
	
	if ( self.Horizontal ) then
	
		local CWide = self:GetCanvas():GetWide()

		local x, y = self.Padding, self.Padding;

		if (self.DynamicSpace) then
			local ElmCnt2, Spacing2 = math.modf(self:GetWide() / self.RowHeight)
			if (ElmCnt2 > 1) then
				local Spacing2 = (Spacing2*self.RowHeight) / (ElmCnt2-1)
			else
				Spacing2 = 0
			end
			local rows, pos = math.modf(table.Count(self.Items)/ElmCnt2)
	
			if ( (rows+1) * (self.RowHeight+Spacing2) <= self:GetTall() ) then
				self.ElmCnt = ElmCnt2
				self.Spacing = Spacing2
				CWide = self:GetWide()
			else
				self.ElmCnt, self.Spacing = math.modf(CWide / self.RowHeight)
				if (self.ElmCnt > 1) then
					self.Spacing = (self.Spacing*self.RowHeight) / (self.ElmCnt-1)
				else
					self.Spacing = 0
				end
			end
		end

		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
			
				local w = panel:GetWide()
				local h = panel:GetTall()
				
				if x + w  > CWide then
					if (x+w > CWide +1) then
						y = y + h + self.Spacing
						x = self.Padding
					else
						x = CWide - w
						panel:SetPos( x, y )
					end
				end
				
				panel:SetPos( x, y )
				x = x + w + self.Spacing
				
				Offset = y + h + self.Spacing
			
			end
		
		end
	
	else
	
		for k, panel in pairs( self.Items ) do
		
			if ( panel:IsVisible() ) then
				
				if ( self.m_bNoSizing ) then
					panel:SizeToContents()
					panel:SetPos( (self:GetCanvas():GetWide() - panel:GetWide()) * 0.5, self.Padding + Offset )
				else
					panel:SetSize( self:GetCanvas():GetWide() - self.Padding * 2, panel:GetTall() )
					panel:SetPos( self.Padding, self.Padding + Offset )
				end
				
				// Changing the width might ultimately change the height
				// So give the panel a chance to change its height now, 
				// so when we call GetTall below the height will be correct.
				// True means layout now.
				panel:InvalidateLayout( true )
				
				Offset = Offset + panel:GetTall() + self.Spacing
				
			end
		
		end
		
		Offset = Offset + self.Padding
		
	end
	
	self:GetCanvas():SetTall( Offset + (self.Padding) - self.Spacing ) 
	
	// This is a quick hack, ideally this setting will position the panels from the bottom upwards
	// This back just aligns the panel to the bottom
	if ( self.m_bBottomUp ) then
		self:GetCanvas():AlignBottom( self.Spacing )
	end

	// Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5)
	
	end
	
end

/*---------------------------------------------------------
   Name: OnMouseWheeled
---------------------------------------------------------*/
function PANEL:OnMouseWheeled( dlta )

	if ( self.VBar ) then
		return self.VBar:OnMouseWheeled( dlta )
	end
	
end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()
	
	derma.SkinHook( "Paint", "PanelList", self )
	return true
	
end

/*---------------------------------------------------------
   Name: OnVScroll
---------------------------------------------------------*/
function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset)
	
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local YPos = 0
	
	if ( !self.Rebuild ) then
		debug.Trace()
	end
	
	if ( self.VBar && !m_bSizeToContents ) then

		self.VBar:SetPos( self:GetWide() - 16, 0 )
		self.VBar:SetSize( 16, self:GetTall() )
		self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
		self.YOffset = self.VBar:GetOffset()
		
		if ( self.VBar.Enabled ) then Wide = Wide - 16 end

	end

	self.pnlCanvas:SetPos( 0, YPos)
	self.pnlCanvas:SetWide( Wide )
	
	if ( self:GetAutoSize() ) then
	
		self:SetTall( self.pnlCanvas:GetTall() )
		self.pnlCanvas:SetPos( 0, 0)
	
	end
	
	self:Rebuild()

end

/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:OnMousePressed( mcode )

	// Loop back if no VBar
	if ( !self.VBar && self:GetParent().OnMousePressed ) then
		return self:GetParent():OnMousePressed( mcode )
	end

	if ( mcode == MOUSE_RIGHT && self.VBar ) then
		self.VBar:Grip()
	end
	
end

/*---------------------------------------------------------
   Name: Sort
---------------------------------------------------------*/
function PANEL:Sort()

	for k, v in pairs(self.Items) do 
		print("DPanelListFix: k: "..k)
		if (v == nil) then print("DPanelListFix: found nill element in self.Items{} ")
	end

end

derma.DefineControl( "DPanelListFix", "A Panel that neatly organises other panels", PANEL, "Panel" )


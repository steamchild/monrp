
local matHover = Material( "vgui/spawnmenu/hover" )

local PANEL = {}

AccessorFunc( PANEL, "m_iIconSize", 		"IconSize" )

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()

	self.Icon = vgui.Create( "ModelImage", self )
	self.Icon:SetMouseInputEnabled( false )
	self.Icon:SetKeyboardInputEnabled( false )
	self.PaintOver = self.PaintOverHovered
	self.Toggled = false
	
	self.animPress = Derma_Anim( "Press", self, self.PressedAnim )
	
	self:SetIconSize( 64 ) // Todo: Cookie!

end

/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:ToggleIn()
	self.Toggled = true
end

function PANEL:ToggleOut()
	self.Toggled = false
end

function PANEL:Toggle()
	self.Toggled = !self.Toggled
end

function PANEL:OnMousePressed( mcode )

	if ( mcode == MOUSE_LEFT ) then
		self:DoClick()
		self.animPress:Start( 0.2 )
	end
	
	if ( mcode == MOUSE_RIGHT ) then
		self:OpenMenu()
	end

end

function PANEL:OnMouseReleased()

	

end

/*---------------------------------------------------------
   Name: DoClick
---------------------------------------------------------*/
function PANEL:DoClick()
end

/*---------------------------------------------------------
   Name: OpenMenu
---------------------------------------------------------*/
function PANEL:OpenMenu()
end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorEntered()

end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:OnCursorExited()

end

/*---------------------------------------------------------
   Name: PaintOverHovered
---------------------------------------------------------*/
function PANEL:PaintOverHovered()

	if (!self.Toggled) then return end
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( matHover )
	self:DrawTexturedRect()

end

/*---------------------------------------------------------
   Name: OnMouseReleased
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( self.m_iIconSize, self.m_iIconSize )	
	self.Icon:StretchToParent( 0, 0, 0, 0 )

end

/*---------------------------------------------------------
   Name: PressedAnim
---------------------------------------------------------*/
function PANEL:SetModel( mdl, iSkin )

	if (!mdl) then debug.Trace() return end

	self.Icon:SetModel( mdl, iSkin )

end


/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()

	self.animPress:Run()

end

/*---------------------------------------------------------
   Name: PressedAnim
---------------------------------------------------------*/
function PANEL:PressedAnim( anim, delta, data )

	if ( anim.Started ) then
	end
	
	if ( anim.Finished ) then
		self.Icon:StretchToParent( 0, 0, 0, 0 )
	return end

	local border = math.sin( delta * math.pi ) * ( self.m_iIconSize * 0.1 )
	self.Icon:StretchToParent( border, border, border, border )

end

/*---------------------------------------------------------
   Name: RebuildSpawnIcon
---------------------------------------------------------*/
function PANEL:RebuildSpawnIcon()

	self.Icon:RebuildSpawnIcon()

end


vgui.Register( "SpawnIconToggle", PANEL, "Panel" )

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
	self.currency = 1

	self:SetDrawBorder( false )
	self:SetDrawBackground( false )
	self:SetSize(300,150)
	self:Center()

	self.DFrame = vgui.Create( "DFrame",self) -- Creates the frame itself
		self.DFrame:SetSize( 300, 150 ) -- Size of the frame
		self.DFrame:SetPos(0,0)
		self.DFrame:SetTitle( "Auction" ) -- Title of the frame	
		self.DFrame:SetVisible( true )
		self.DFrame:SetDraggable( true ) -- Draggable by mouse?
		self.DFrame:ShowCloseButton( true ) -- Show the close button?
		self.DFrame:MakePopup() -- Show the frame
		self.DFrame.Close2 = self.DFrame.Close
		self.DFrame.Close = function(self)
			self:GetParent():OnRemove()
			self:GetParent():Remove()
		end

	slef.Slider = vgui.Create( "DNumSlider", self.DFrame )
		slef.Slider:SetPos( 10,34 )
		slef.Slider:SetWide( 160 )
		slef.Slider:SetText( "Max Props" )
		slef.Slider:SetMin( 10 ) -- Minimum number of the slider
		slef.Slider:SetMax( 100 ) -- Maximum number of the slider
		slef.Slider:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
		NumSlider.OnValueChanged = function( self, val )
			if (val < self:GetMin()) then self:SetValue(self:GetMin()) end
			if (val > self:GetMax()*1.5) then self:SetValue( self:GetMax()*1.5) end
		end 

	self.button = vgui.Create( "DButton", self.DFrame )
		button:SetSize( 100, 22 )
		button:SetPos( 190, 34 )
		button:SetText( "Test Button" )
		button.DoClick = function( self )
			if (!self:GetPrent():GetCore()) then return end
				datastream.StreamToServer( "Auc_AddPrice", {self:GetPrent():GetCore(), self:GetParent():GetCount()});
		end

	
	self.Label= vgui.Create("DLabel", myParent)
		self.Label:SetText("")
		self.Label:SetPos(10,60)
		self.Label:setSize(22,100)
end

function PANEL:SetCore(core)
	self.Core = core
	datastream.StreamToServer("AucOpn", core);
end


function PANEL:GetCore()
	return self.Core
end

function PANEL:GetCount()
	return slef.Slider:GetValue()
end

function PANEL:SetMax(val)
	self.Slider:SetMax( val )
	if (self.Slider:GetValue() > val*1.5) then self.Slider:SetValue(val*1.5) end
end

function PANEL:SetMin(val)
	self.Slider:SetMin( val )
	if (self.Slider:GetValue() < val) then self.Slider:SetValue(val) end
end

function PANEL:SetPriceCoof(price)
	self:SetMax( price*0.8 )
	self:SetMin( price*0.1 )
end

function PANEL:SetCurrentPrice(price,bautominmax)
	self.Price = price
	if (self.OnPriceChanged) then self:OnPriceChanged(price) end
	if (bautominmax) then self:SetPriceCoof(price) end
	local Cur
	if (self:GetCurrency() == 1) then Cur = "USD" else Cur = "EUR" end
	self.Label:SetText("Current Price: "..Cur..tostring(price))
end

function PANEL:GetPrice()
	return self.Price
end

function PANEL:SetCurrency(cur_enum)
	if (cur_enum != 1 or cur_enum != 2) then return end
	self.currency = cur_enum
	if (self:GetCurrency() == 1) then Cur = "USD" else Cur = "EUR" end
	self.Label:SetText("Current Price: "..Cur..tostring(self:GetPrice()))
end

function PANEL:GetCurrency()
	return self.currency
end

function PANEL:OnRemove()
	datastream.StreamToServer("AucClz", self:GetCore());
end

derma.DefineControl( "DPanelListFix", "A menu that helps you buying realty", PANEL, "Panel" )

function AucData( um )
	local ent = Entity(um:ReadShort())
	local cur = um:ReadBool()
	local price = um:ReadLong()
	if (!price) then price = um:ReadShort() end
	local time = um:ReadShort()

	print("UMSG DATA RECEIVED: ")
	print(ent)
	print(cur)
	print(price)
	print(time)
end
usermessage.Hook("aucdata", AucData)


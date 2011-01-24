/*   _                                
    ( )                               
   _| |   __   _ __   ___ ___     _ _ 
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_) 

	MENU_AUCTION
	
	AUCTION

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
	self.LastTime = 0

	self:SetSize(300,150)
	self:Center()
	self.TimeText = ""
	self.PriceText = ""
	self.Timer = 0
	self.Price = 0

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

	self.Slider = vgui.Create( "DNumSlider", self.DFrame )
		self.Slider:SetPos( 10,34 )
		self.Slider:SetWide( 160 )
		self.Slider:SetText( "Add Price" )
		self.Slider:SetMin( 10 ) -- Minimum number of the slider
		self.Slider:SetMax( 100 ) -- Maximum number of the slider
		self.Slider:SetValue(10)
		self.Slider:SetDecimals( 0 ) -- Sets a decimal. Zero means it's a whole number
		self.Slider.OnValueChanged = function( self, val )
			//if (tonumber(val) < self.Wang:GetMin()) then self:SetValue(self.Wang:GetMin()) end
			//if (tonumber(val) > self.Wang:GetMax()*1.5) then self:SetValue( self.Wang:GetMax()*1.5) end
		end 

	self.button = vgui.Create( "DButton", self.DFrame )
		self.button:SetSize( 100, 22 )
		self.button:SetPos( 190, 34 )
		self.button:SetText( "Apply" )
		self.button.DoClick = function( self )
			if (!self:GetParent():GetParent():GetCore()) then return end
				datastream.StreamToServer( "Auc_AddPrice", {self:GetParent():GetParent():GetCore(),
					self:GetParent():GetParent():GetCount()});
		end

	
	self.Label= vgui.Create("DLabel", self.DFrame)
		self.Label:SetText("")
		self.Label:SetPos(10,60)
		self.Label:SetSize(200,44)
end

function PANEL:SetCore(core)
	self.Core = core
	self:SetIndex(core:EntIndex())
	datastream.StreamToServer("AucOpn", core);
	self:UpdateText()
end


function PANEL:GetCore()
	return self.Core
end

function PANEL:GetCount()
	return self.Slider:GetValue()
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
	local Min = price*0.1
	local Max = price*0.8
	if (Max > 100) then self:SetMax(Max) else self:SetMax(100) end
	if (Min > 1) then self:SetMin(Min) else self:SetMin(1) end
end

function PANEL:SetCurrentPrice(price,bautominmax)
	self.Price = price
	if (self.OnPriceChanged) then self:OnPriceChanged(price) end
	if (bautominmax) then self:SetPriceCoof(price) end
	self:UpdateText()
end

function PANEL:GetPrice()
	return self.Price
end

function PANEL:SetCurrency(cur_enum)
	if (cur_enum != 1 or cur_enum != 2) then return end
	self.currency = cur_enum
	self.Label:SetText("Current Price: "..Cur..tostring(self:GetPrice()))
	self:UpdateText()
end

function PANEL:GetCurrency()
	return self.currency
end

function PANEL:OnRemove()
	datastream.StreamToServer("AucClz", self:GetCore());
	if (self.Index) then
		VGUI_AUCTIONS[self.Index] = nil
	end
end

function PANEL:SetIndex(ind)
	if (self.Index and VGUI_AUCTIONS[self.Index]) then VGUI_AUCTIONS[self.Index] = nil end
	self.Index = ind
	VGUI_AUCTIONS[self.Index] = self
end


function PANEL:GetIndex()
	return self.Index
end

function PANEL:Think( )
	if (self.LastTime+1<=CurTime()) then
		self:TimeTick()
		self.LastTime = CurTime()
	end
end

function PANEL:TimeTick()
	if (self.Timer and self.Timer >= 1) then self.Timer = self.Timer - 1 else
		if (self.Timer and self.Timer > 0) then self.Timer = 0 end 
	end	
	self:UpdateText()
end

function PANEL:SetTimer(time)
	self.Timer = time
end

function PANEL:GetTimer()
	return self.Timer
end

function PANEL:UpdateText()
	local Cur
	if (self:GetCurrency() == 1) then Cur = "USD" else Cur = "EUR" end
	self.Label:SetText("Current Price: "..Cur..self.Price.."\nTime Left:"..self.Timer)
end

derma.DefineControl( "menu_auction", "A menu that helps you buying realty", PANEL, "Panel" )

VGUI_AUCTIONS = {}

function AucData( um )
	local ent = Entity(um:ReadShort())
	local cur = um:ReadBool()
	local priceformat = um:ReadBool()
	local price
	if (priceformat) then price = um:ReadShort() else price = um:ReadLong() end
	local time = um:ReadShort()

	print("UMSG DATA RECEIVED: ")
	print(ent)
	print("Currency:")
	print(cur)
	print("Price:")
	print(price)
	print("Yime left:")
	print(time)

	local AUC = VGUI_AUCTIONS[ent:EntIndex()]
	if (AUC and AUC:IsValid() ) then 
		if (cur) then
			AUC:SetCurrency(1)
		else
			AUC:SetCurrency(1)	
		end
		AUC:SetCurrentPrice(price,true)
		AUC:SetTimer(time)
	end
end
usermessage.Hook("aucdata", AucData)


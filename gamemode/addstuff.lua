resource.AddFile("materials/hud/USD_icon.vmt")
resource.AddFile("materials/hud/USD_icon.vtf")
resource.AddFile("materials/hud/icon_cookie.vtf")
resource.AddFile("materials/hud/icon_cookie.vmt")
resource.AddFile("materials/hud/icon_dollar_small.vtf")
resource.AddFile("materials/hud/icon_dollar_small.vmt")
resource.AddFile("materials/hud/icon_euro_small.vtf")
resource.AddFile("materials/hud/icon_euro_small.vmt")
resource.AddFile("materials/hud/icon_wallet.vtf")
resource.AddFile("materials/hud/icon_wallet.vmt")

resource.AddFile("materials/hud/icon_cross.vtf")
resource.AddFile("materials/hud/icon_cross.vmt")
resource.AddFile("materials/hud/icon_cross_refl.vtf")
resource.AddFile("materials/hud/icon_cross_refl.vmt")
resource.AddFile("materials/hud/icon_cross_shadow.vtf")
resource.AddFile("materials/hud/icon_cross_shadow.vmt")
resource.AddFile("materials/hud/icon_cross_boarder.vtf")
resource.AddFile("materials/hud/icon_cross_boarder.vmt")

resource.AddFile("materials/hud/icon_fatigue.vtf")
resource.AddFile("materials/hud/icon_fatigue.vmt")
resource.AddFile("materials/hud/icon_fatigue_refl.vtf")
resource.AddFile("materials/hud/icon_fatigue_refl.vmt")
resource.AddFile("materials/hud/icon_fatigue_shadow.vtf")
resource.AddFile("materials/hud/icon_fatigue_shadow.vmt")
resource.AddFile("materials/hud/icon_fatigue_boarder.vtf")
resource.AddFile("materials/hud/icon_fatigue_boarder.vmt")

resource.AddFile("sound/Monrp/money1.wav")
resource.AddFile("sound/Monrp/money2.wav")
resource.AddFile("sound/Monrp/money3.wav")

MaxCarryMoney = CreateConVar("rl_maxcarrymoney",100000)
HungerSpeed = CreateConVar("rl_hungerspeed",0.1)
HungerChangeSpeed = CreateConVar("rl_hungerchangespeed",0.1)

FatigueSpeed = CreateConVar("rl_fatiguespeed",0.1)
FatigueChangeSpeed = CreateConVar("rl_fatiguechangespeed",0.1)

MoneySounds={
"monrp/money1.wav",
"monrp/money2.wav",
"monrp/money3.wav"
}

CUR_USD = 1
CUR_EUR = 2

CHAT_NORM = 1
CHAT_OOC = 2
CHAT_ADVERT = 3

MrpOneSecTick = 1

PlayerSaveKeyValues={"USD","EUR","Fatigue","Hunger","RPModel","MrpName"}
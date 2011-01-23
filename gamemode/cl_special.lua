function KeyThink()
	if (input.IsKeyDown(KEY_F1)) then SpecialF1() return end
	if (input.IsKeyDown(KEY_F2)) then SpecialF2() return end
	if (input.IsKeyDown(KEY_F3)) then SpecialF3() return end
	if (input.IsKeyDown(KEY_F4)) then SpecialF4() return end
end
hook.Add("Think", "KeyThink", KeyThink)
 

function SpecialF1()
	print("Pressed F1")
end

function SpecialF2()
	print("Pressed F2")
	if (LocalPlayer():GetEyeTrace().
end

function SpecialF3()
	print("Pressed F3")
end

function SpecialF4()
	print("Pressed F4")
end
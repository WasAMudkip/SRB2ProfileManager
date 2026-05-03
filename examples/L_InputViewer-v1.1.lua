-- InputViewer version 1.1.
-- Lianvee: Code ported over from source, and with some care put into (within my abilities), this cute little script will allow you to see other players' (including your own if you want!) inputs in a multiplayer game.

--
-- <Changelog>
-- 1.0:
--	First release.
--
-- 1.1:
--	Added more buttons for input viewing if JUMP and SPIN aren't enough - this is toggled through a console variable.
--	Players can now customize the positioning of the input viewer! This is controlled via console variables. Gotta love customization!
--

local InputsSNAP = CV_RegisterVar{
	name = "inputs_snapto",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = {Center=0, Top=1, TopRight=2, Right=3, BottomRight=4, Bottom=5, BottomLeft=6, Left=7, TopLeft=8},
	defaultvalue = "BottomLeft",
}
local InputsY = CV_RegisterVar{
	name = "inputs_y",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = {MIN = 0, MAX = 200},
	defaultvalue = "156",
}
local InputsX = CV_RegisterVar{
	name = "inputs_x",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = {MIN = 0, MAX = 320},
	defaultvalue = "16",
}

local Inputsmore = CV_RegisterVar{
	name = "inputs_more",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = CV_OnOff,
	defaultvalue = "On",
}
local InputsJoy = CV_RegisterVar{
	name = "inputs_showjoy",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = CV_OnOff,
	defaultvalue = "On",
}
local InputsSelf = CV_RegisterVar{
	name = "inputs_self",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = CV_OnOff,
	defaultvalue = "On",
}
local Inputs = CV_RegisterVar{
	name = "inputs",
	flags = CV_MODIFIED|CV_SHOWMODIF,
	PossibleValue = CV_OnOff,
	defaultvalue = "On",
}

local SNAPTOtable = {}
SNAPTOtable[0] = 0
SNAPTOtable[1] = V_SNAPTOTOP
SNAPTOtable[2] = V_SNAPTOTOP|V_SNAPTORIGHT
SNAPTOtable[3] = V_SNAPTORIGHT
SNAPTOtable[4] = V_SNAPTOBOTTOM|V_SNAPTORIGHT
SNAPTOtable[5] = V_SNAPTOBOTTOM
SNAPTOtable[6] = V_SNAPTOBOTTOM|V_SNAPTOLEFT
SNAPTOtable[7] = V_SNAPTOLEFT
SNAPTOtable[8] = V_SNAPTOTOP|V_SNAPTOLEFT

local function DrawDigitalPad(v, player, x, y, flags, color)
-- Arrows! Shows input controls.
	local offs, col
	-- This is the joystick/joypad part.
	-- O backing.
	v.drawFill(x, y,    16, 16, flags|20)
	v.drawFill(x, y+16, 16,  1, flags|29)
	
	-- Arrows!
	-- <
	if (player.cmd.sidemove < 0)
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(x-2, y+11,  6,  1, flags|29)
		v.drawFill(x+4, y+10,  1,  1, flags|29)
		v.drawFill(x+5,  y+9,  1,  1, flags|29)
	end
	v.drawFill(x-2, y+6-offs,  6,  6, col)
	v.drawFill(x+4, y+7-offs,  1,  4, col)
	v.drawFill(x+5, y+8-offs,  1,  2, col)
	
	-- ^
	if (player.cmd.forwardmove > 0)
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(x+5,  y+4,  1,  1, flags|29)
		v.drawFill(x+6,  y+5,  1,  1, flags|29)
		v.drawFill(x+7,  y+6,  2,  1, flags|29)
		v.drawFill(x+9,  y+5,  1,  1, flags|29)
		v.drawFill(x+10, y+4,  1,  1, flags|29)
	end
	v.drawFill(x+5, (y-1)-offs,  6,  6, col)
	v.drawFill(x+6, (y+5)-offs,  4,  1, col)
	v.drawFill(x+7, (y+6)-offs,  2,  1, col)
	
	-- >
	if (player.cmd.sidemove > 0)
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(x+12, y+11,  6,  1, flags|29)
		v.drawFill(x+11, y+10,  1,  1, flags|29)
		v.drawFill(x+10,  y+9,  1,  1, flags|29)
	end
	v.drawFill(x+12, (y+6)-offs,  6,  6, col)
	v.drawFill(x+11, (y+7)-offs,  1,  4, col)
	v.drawFill(x+10, (y+8)-offs,  1,  2, col)
	
	-- v
	if (player.cmd.forwardmove < 0)
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(x+5, y+18,  6,  1, flags|29)
	end
	v.drawFill(x+ 5, (y+13)-offs,  6,  6, col)
	v.drawFill(x+ 6, (y+12)-offs,  4,  1, col)
	v.drawFill(x+ 7, (y+11)-offs,  2,  1, col)
end

local function DrawJoystick(v, player, x, y, flags, color)
-- Joystick render! Shows input controls.
	-- O backing.
	v.drawFill(x, y, 16, 16, flags|20)
	v.drawFill(x, y+16, 16, 1, flags|29)
	if (player.cmd.sidemove or player.cmd.forwardmove)
	-- If we have movement inputs...
		-- Joystick hole.
		v.drawFill(x+5, y+5, 6, 6, flags|29)
		-- Joystick top
		v.drawFill(
			x+3 + player.cmd.sidemove/12,
			y+3 - player.cmd.forwardmove/12,
			10, 10, flags|29
		)
		v.drawFill(
			x+3+player.cmd.sidemove/9,
			y+2-player.cmd.forwardmove/9,
			10, 10, flags|color
		)
	else
	-- If our movement inputs are neutral...
		-- Just a limited, greyed out joystick top.
		v.drawFill(x+3, y+12, 10, 1, flags|29)
		v.drawFill(x+3, y+2, 10, 10, flags|16)
	end
end

local function DrawButton(v, player, x, y, flags, color, butt, symb, strngtype)
-- Buttons! Shows input controls.
-- butt parameter is the button cmd in question.
-- symb represents the button via drawn string.
	local offs, col
	if (butt) and (player.cmd.buttons & butt) then
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(
			(x), (y+9),
			10, 1, flags|29
		)
	end
	v.drawFill(
		(x), (y)-offs,
		10, 10,	col
	)
	
	local stringx, stringy = 1, 1
	if (strngtype == 'thin') then
		stringx, stringy = 0, 2
	end
	
	v.drawString(
		(x+stringx), (y+stringy)-offs,
		symb, flags, strngtype
	)
end

local function DrawMiniButton(v, player, x, y, flags, color, butt, symb, strngtype)
-- This is identical to above. Only mini, when you need to have it small.
-- butt parameter is the button cmd in question.
-- symb represents the button via drawn string.
	local offs, col
	if (butt) and (player.cmd.buttons & butt) then
		offs = 0
		col = flags|color
	else
		offs = 1
		col = flags|16
		v.drawFill(
			(x), (y+9),
			5, 1, flags|29
		)
	end
	v.drawFill(
		(x), (y)-offs,
		5, 10,	col
	)
	
	local stringx, stringy = 1, 1
	if (strngtype == 'thin') then
		stringx, stringy = 0, 2
	end
	
	v.drawString(
		(x+stringx), (y+stringy)-offs,
		symb, flags, strngtype
	)
end

local function DrawViewCompass(v, player, x, y, flags, color)
-- Where we looking at, boys? Shows a line pointing to angle looking at.
	v.drawFill(
		(x), (y),
		21, 10, flags|20
	) -- Sundial backing.
	
	if (player.realmo)
		local ang = (player.powers[pw_carry] == CR_NIGHTSMODE) and (FixedAngle((player.flyangle-90)<<FRACBITS))
		or (player.cmd.angleturn<<16 - R_PointToAngle(player.realmo.x, player.realmo.y))
		local xcomp = P_ReturnThrustX(nil, ang + ANGLE_90, 8)
		local ycomp = P_ReturnThrustY(nil, ang + ANGLE_90, 8)
		
		for i = 0,6
			v.drawFill(
				(x+10)+(xcomp * i/8), (y+4)-(ycomp/2 * i/8),
				1, 1, flags|16
			) -- Line helper.
		end
		v.drawFill(
			(x+9)+xcomp, (y+3)-(ycomp/2),
			3, 3, flags|color
		) -- Point (front).
	end
end

local function InputViewer(v, player, cam)
-- Draw record attack's input viewer. This should be available outside of that mode, in all honesty.
	if (Inputs.value) then
		if (InputsSelf.value) and (player == consoleplayer)
		or (player ~= consoleplayer)
		then
			local x, y = InputsX.value, InputsY.value
			local flags = V_HUDTRANS|V_PERPLAYER|SNAPTOtable[InputsSNAP.value]
			local color = (player.skincolor and skincolors[player.skincolor].ramp[4] or 0)
			if (player.spectator) then color = (player.skincolor and skincolors[player.skincolor].ramp[8] or 0) end
			
			-- Here are the movement inputs.
			if (InputsJoy.value)
				DrawJoystick(v, player, x, y, flags, color)
			else
				DrawDigitalPad(v, player, x, y, flags, color)
			end
			
			-- Here are the button inputs.
			DrawButton(v, player, x+20, y-2, flags, color, BT_JUMP, 'J', 'left')
			DrawButton(v, player, x+31, y-2, flags, color, BT_SPIN, 'S', 'left')
			
			if (Inputsmore.value) then -- Oh my god, that's a LOT of buttons!
				DrawButton(v, player,  x+4, y-14, flags, color, BT_ATTACK,        'F', 'left')
				DrawButton(v, player, x+15, y-14, flags, color, BT_FIRENORMAL,   'FN', 'thin')
				DrawButton(v, player, x+26, y-14, flags, color, BT_TOSSFLAG,     'TF', 'thin')
				
				DrawMiniButton(v, player, x+42, y+4, flags, color, nil,             'C', 'thin')
				DrawMiniButton(v, player, x+49, y+4, flags, color, BT_CUSTOM1,      '1', 'thin')
				DrawMiniButton(v, player, x+54, y+4, flags, color, BT_CUSTOM2,      '2', 'thin')
				DrawMiniButton(v, player, x+59, y+4, flags, color, BT_CUSTOM3,      '3', 'thin')
			end
			
			-- Here is the angle-looking part. I freaking hate how easy it is for C to break in Lua without proper knowledge.
			DrawViewCompass(v, player, x+20, y+9, flags, color)
		end
	end
end
hud.add(InputViewer, "game")
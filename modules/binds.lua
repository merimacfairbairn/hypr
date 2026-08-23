-- Get window position relative to monitor
local function normalise_current_window_pos()
	local active = hl.get_active_window()
	if active then
		local xpos = active.at.x
		-- If on right monitor
		if xpos > 1920 then
			xpos = xpos - 1920
			return xpos
		-- If on left monitor
		elseif xpos < 1 then
			xpos = xpos + 1920
			return xpos
		else
			return xpos
		end
	end
end

-- Notification helper function
local function notif(text, timeout, icon)
	hl.notification.create({
		text = text or "notification",
		timeout = timeout or 2000,
		icon = icon or "ok",
	})
end

-- function to merge lists
local function merge_into(first, second)
	local combined = {}

	-- Look at me using lua im so good at this
	table.move(first, 1, #first, 1, combined)
	table.move(second, 1, #second, #first + 1, combined)

	return combined
end

local corneKeyboardString = "qwertyuiop"

-- Set modifier keys
local mainMod = "SUPER + "
local subMod = mainMod
local keyboardString = corneKeyboardString
local keybindIndex = 1
local recordingMode = 0

-- Set different modifiers on laptop
if Hostname == "mobile02" or Hostname == "mobile03" then
	mainMod = "ALT + "
	subMod = "SUPER + "
	keyboardString = "1234567890"
	keybindIndex = 2
end

local globalAppBinds = {

	---- Window functions
	{ key = { "BACKSPACE" }, dispatch = hl.dsp.window.close() },
	{ key = { "b", "f" }, dispatch = hl.dsp.window.fullscreen({ action = "toggle" }) },
	{ mod = subMod, key = { "space" }, dispatch = hl.dsp.window.float() },

	---- Apps
	-- Launcher
	{
		key = { "d" },
		dispatch = function()
			if hl.get_windows({ class = "otter" })[1] ~= nil then
				hl.dispatch(hl.dsp.focus({ window = "class:otter" }))
			else
				hl.exec_cmd("kitty --class otter --title otter-launcher -e sh -c 'sleep 0.05 && otter-launcher'")
			end
		end,
	},

	-- Terminal
	{
		key = { "RETURN" },
		dispatch = function()
			if recordingMode == 1 then
				hl.exec_cmd("kitty -o font_size=24 -o window_margin_width=20")
			else
				hl.exec_cmd("kitty")
			end
		end,
	},

	-- Firefox and file browser
	{ key = { "f", "o" }, dispatch = "firefox" },
	{ key = { "s" }, dispatch = "nemo" },

	---- Move windows
	{ key = { "k" }, dispatch = hl.dsp.focus({ direction = "up" }) },
	{ key = { "j" }, dispatch = hl.dsp.focus({ direction = "down" }) },
	{ key = { "SHIFT + h" }, dispatch = hl.dsp.layout("swapcol l") },
	{ key = { "SHIFT + l" }, dispatch = hl.dsp.layout("swapcol r") },
	{
		key = { "l" },
		dispatch = function()
			-- Move before so you can detect if it is the last window
			hl.dispatch(hl.dsp.layout("move +col"))
			if not normalise_current_window_pos() then
				-- Go back a window
				hl.dispatch(hl.dsp.layout("move -col"))
				-- Move to monitor to the right
				hl.dispatch(hl.dsp.focus({ monitor = "right" }))
			end
		end,
	},
	{
		key = { "h" },
		dispatch = function()
			local pos = normalise_current_window_pos()
			-- 9 derived from 5 gap plus 3 border (8), so first pixel of window is 9
			if pos and pos == 9 then
				-- If first window, then move to monitor to the left
				hl.dispatch(hl.dsp.focus({ monitor = "left" }))
			else
				-- If not the first window then go to the column to the left
				hl.dispatch(hl.dsp.layout("move -col"))
			end
		end,
	},

	---- Special Workspaces
	{ key = { "m" }, dispatch = hl.dsp.workspace.toggle_special("music") },
	{ key = { "minus" }, dispatch = hl.dsp.workspace.toggle_special("scratch") },
	{ key = { "SHIFT + minus" }, dispatch = hl.dsp.window.move({ workspace = "special:scratch", follow = false }) },

	-- Youtuber mode lol
	{
		key = { "z" },
		dispatch = function()
			if recordingMode == 0 then
				recordingMode = 1
				hl.exec_cmd(
					"wshowkeys -a right -F 'FiraMono Nerd Font 35' -s '#cba6f7ff' -f  '#cdd6f4ff' -b '#45475a99' -m 70 -l 60 -t 1000 -a top"
				)
				notif("Recording Mode Enabled")
			else
				recordingMode = 0
				hl.exec_cmd("pkill wshowkeys")
				notif("Recording Mode Disabled")
			end
		end,
	},

	{
		key = { "x" },
		dispatch = function()
			if recordingMode == 1 then
				hl.exec_cmd("woomer --output DP-1 --radius 2 --monitor DP-1 -S")
			end
		end,
	},

	-- Logout menu
	{ key = { "a", "e" }, dispatch = "quickshell ipc call root openLogoutMenu" },

	-- Screenshot
	{ mod = subMod, key = { "SHIFT + s" }, dispatch = "grimblast copy area" },

	-- Mouse for moving windows
	{ mod = subMod, key = { "mouse:272" }, dispatch = hl.dsp.window.drag(), opts = { mouse = true } },
	{ mod = subMod, key = { "mouse:272" }, dispatch = hl.dsp.window.float(), opts = { mouse = true, click = true } },
	{
		mod = subMod,
		key = { "mouse:272" },
		dispatch = hl.dsp.layout("promote"),
		opts = { mouse = true, release = true },
	},
	{ mod = subMod, key = { "SHIFT + mouse:272" }, dispatch = hl.dsp.window.resize(), opts = { mouse = true } },
}

-- Workspace switch keys
for _, bind in ipairs(globalAppBinds) do
	-- Mod specified or default modifier
	local modBind = bind.mod or mainMod
	local command

	-- If the dispatcher isnt a string evaluate
	-- it as a command
	if type(bind.dispatch) ~= "string" then
		command = bind.dispatch
	else
		-- If it is a string then wrap it in exec_cmd
		command = hl.dsp.exec_cmd(bind.dispatch)
	end

	-- If there are options then apply them
	local opts = {}
	if bind.opts then
		opts = bind.opts
	end

	-- If there is a specific key for that keybindIndex then
	-- bind it, else bind the default key
	if bind.key[keybindIndex] then
		hl.bind(modBind .. bind.key[keybindIndex], command, opts)
	else
		hl.bind(modBind .. bind.key[1], command)
	end
	-- If corne keys not being bound by default, then bind them just in case
	if keybindIndex ~= 1 then
		local deviceSpecifier = { device = { inclusive = true, list = { "zmk-project-corne-keyboard" } } }
		-- Apply options so that dragging windows and stuff works
		local corneOptions = merge_into(opts, deviceSpecifier)
		hl.bind("SUPER + " .. bind.key[1], command, corneOptions)
	end
end

-- Workspace functions
local keyboardSplit = {}

for char in keyboardString:gmatch(".") do
	table.insert(keyboardSplit, char)
end

for index, bind in ipairs(keyboardSplit) do
	-- Focus workspace index
	hl.bind(mainMod .. bind, hl.dsp.focus({ workspace = index }))

	-- Move to workspace no follow
	hl.bind(mainMod .. "SHIFT + " .. bind, hl.dsp.window.move({ workspace = index, follow = false }))
end

-- If corne keys not being bound
if keybindIndex ~= 1 then
	local corneKeyboardSplit = {}

	for char in corneKeyboardString:gmatch(".") do
		table.insert(corneKeyboardSplit, char)
	end

	for index, bind in ipairs(corneKeyboardSplit) do
		hl.bind(
			"SUPER +" .. bind,
			hl.dsp.focus({ workspace = index }),
			{ inclusive = true, list = { "zmk-project-corne-keyboard" } }
		)
		hl.bind(
			"SUPER +" .. "SHIFT + " .. bind,
			hl.dsp.window.move({ workspace = index, follow = false }),
			{ inclusive = true, list = { "zmk-project-corne-keyboard" } }
		)
	end
end

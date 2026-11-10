-- Host detection (Hostname is assumed to be a global provided elsewhere in your config)
local isMobile = Hostname:match("^mobile") ~= nil

-- Index into each bind's key table: key = { station, mobile }
-- A missing entry falls back to key[1], so { "l" } applies everywhere.
local keyIndex = isMobile and 2 or 1

local mainMod = "SUPER + "
local subMod = mainMod

-- Workspace keys: 1-0 on station, q-p on mobile
local workspaceKeys = isMobile and "qwertyuiop" or "1234567890"

local globalAppBinds = {
	---- Window functions
	{ key = { "BACKSPACE" }, dispatch = hl.dsp.window.close() },
	{ key = { "f", "b" }, dispatch = hl.dsp.window.fullscreen({ action = "toggle" }) },
	{ mod = subMod, key = { "space" }, dispatch = hl.dsp.window.float() },

	---- Apps
	{
		key = { "d" },
		dispatch = function()
			if hl.get_windows({ class = "otter" })[1] ~= nil then
				hl.dispatch(hl.dsp.focus({ window = "class:otter" }))
			else
				hl.exec_cmd(
					"kitty --class otter --title otter-launcher -o remember_window_size=no -e sh -c 'sleep 0.05 && otter-launcher'"
				)
			end
		end,
	},
	{
		key = { "RETURN" },
		dispatch = function()
			hl.exec_cmd("kitty")
		end,
	},
	{ key = { "b", "f" }, dispatch = "firefox" },
	{ key = { "s" }, dispatch = "nemo" },

	---- Move windows
	{ key = { "k" }, dispatch = hl.dsp.focus({ direction = "up" }) },
	{ key = { "j" }, dispatch = hl.dsp.focus({ direction = "down" }) },
	{ key = { "SHIFT + h" }, dispatch = hl.dsp.layout("swapcol l") },
	{ key = { "SHIFT + l" }, dispatch = hl.dsp.layout("swapcol r") },
	{ key = { "l" }, dispatch = hl.dsp.layout("move +col") },
	{ key = { "h" }, dispatch = hl.dsp.layout("move -col") },

	---- Special workspaces
	{ key = { "m" }, dispatch = hl.dsp.workspace.toggle_special("music") },
	{ key = { "minus" }, dispatch = hl.dsp.workspace.toggle_special("scratch") },
	{ key = { "SHIFT + minus" }, dispatch = hl.dsp.window.move({ workspace = "special:scratch", follow = false }) },

	-- Logout menu
	{ key = { "a" }, dispatch = "quickshell ipc call root openLogoutMenu" },

	-- Screenshot
	{ mod = subMod, key = { "SHIFT + s" }, dispatch = "grimblast copy area" },

	-- Mouse for moving windows
	{ mod = subMod, key = { "mouse:272" }, dispatch = hl.dsp.window.drag(), opts = { mouse = true } },
	{
		mod = subMod,
		key = { "mouse:272" },
		dispatch = hl.dsp.window.float(),
		opts = { transparent = true, click = true },
	},
	{
		mod = subMod,
		key = { "mouse:272" },
		dispatch = hl.dsp.layout("promote"),
		opts = { transparent = true, release = true },
	},
	{ mod = subMod, key = { "SHIFT + mouse:272" }, dispatch = hl.dsp.window.resize(), opts = { mouse = true } },
}

for _, bind in ipairs(globalAppBinds) do
	local command = type(bind.dispatch) == "string" and hl.dsp.exec_cmd(bind.dispatch) or bind.dispatch
	local key = bind.key[keyIndex] or bind.key[1]
	hl.bind((bind.mod or mainMod) .. key, command, bind.opts or {})
end

-- Workspace binds
local index = 0
for key in workspaceKeys:gmatch(".") do
	index = index + 1
	hl.bind(mainMod .. key, hl.dsp.focus({ workspace = index }))
	hl.bind(mainMod .. "SHIFT + " .. key, hl.dsp.window.move({ workspace = index, follow = false }))
end

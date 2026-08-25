-- ~/.config/hypr/autoload.lua

-- Path to search
local hyprRoot
local modules

if os.getenv("HYPRLAND_ROOT") then
	hyprRoot = os.getenv("HYPRLAND_ROOT")
else
	hyprRoot = os.getenv("HOME") .. "/.config/hypr"
end

if os.getenv("MODULES_ROOT") then
	modules = os.getenv("MODULES_ROOT")
else
	modules = os.getenv("HOME") .. "/.config/hypr/modules"
end

local pluginsOk, pluginsErr = pcall(dofile, hyprRoot .. "plugins.lua")
if not pluginsOk then
	hl.notification.create({
		text = "autoload: " .. hyprRoot .. "plugins.lua" .. "\n" .. tostring(pluginsErr),
		timeout = 8000,
		icon = "warning",
	})
end

-- Get all files in modules dir
local p = io.popen('find -L "' .. modules .. '" -name "*.lua" -type f | sort')
if not p then
	return
end

-- Recursively search and return modules
for path in p:lines() do
	local ok, err = pcall(dofile, path)
	-- If you fucked up the syntax like an idiot
	if not ok then
		hl.notification.create({
			text = "autoload: " .. path .. "\n" .. tostring(err),
			timeout = 8000,
			icon = "warning",
		})
	end
end

p:close()

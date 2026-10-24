-- Get hostname from envvars or something
local f = io.open("/proc/sys/kernel/hostname")
Hostname = f and f:read("*l") or "unknown"
if f then
	f:close()
end

-- Import everything else
local root = os.getenv("HYPRLAND_ROOT") or (os.getenv("HOME") .. "/.config/hypr")
local ok, err = pcall(dofile, root .. "/autoload.lua")
if not ok then
	hl.notification.create({ text = "autoload: " .. tostring(err), timeout = 8000, icon = "warning" })
end

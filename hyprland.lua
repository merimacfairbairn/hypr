hl.env("PATH", "/run/hypr-runtime-env/bin:" .. os.getenv("PATH"))
-- Get hostname from envvars or something
local handle = io.popen("hostname")
Hostname = "unknown" -- Default fallback

-- If there is a hostname at all
if handle then
	local result = handle:read("*l") -- Read the first line
	handle:close()
	if result then
		Hostname = result:gsub("%s+", "") -- Remove whitespace/newlines
	end
end

-- Check if the plugin module is present
-- If it is, require it
local ok, err = pcall(dofile, "plugins")
if not ok then
	hl.exec_cmd("notify-send 'Lua error' '" .. tostring(err) .. "'")
end

-- Import everything else
require("autoload")

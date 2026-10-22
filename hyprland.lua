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

-- Import everything else
local root = os.getenv("HYPRLAND_ROOT") or (os.getenv("HOME") .. "/.config/hypr")
local ok, err = pcall(dofile, root .. "/autoload.lua")
if not ok then
  hl.notification.create({ text = "autoload: " .. tostring(err), timeout = 8000, icon = "warning" })
end

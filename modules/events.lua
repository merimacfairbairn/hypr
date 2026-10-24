local appList = {
	"wpaperd -d",
	"quickshell",
	"syncthing -home=/home/aboba/.config/syncthing -no-browser",
}

local localAppList
local desktopAppList = {
	"wayvnc 0.0.0.0 --output=DP-1",
}
local laptopApplist = {
	"way-edges",
}

if Hostname == "HACKSTATION" then
	-- If on desktop do desktop things
	localAppList = desktopAppList
elseif Hostname == "mobile02" then
	-- If on laptop, do laptop things
	localAppList = laptopApplist
elseif Hostname == "mobile03" then
	-- If on other laptop, do other laptop things
	localAppList = laptopApplist
else
	-- Prevents null errors
	localAppList = { "echo placeholder" }
end

for _, command in ipairs(localAppList) do
	table.insert(appList, command)
end

-- For everything in the applist run it on startup
hl.on("hyprland.start", function()
	for _, command in ipairs(appList) do
		hl.exec_cmd(command)
	end
end)

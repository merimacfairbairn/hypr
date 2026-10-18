local appList = {
	-- "wpaperd -d",
	-- "syncthing -home=/home/user01/.config/syncthing -no-browser",
	-- 'sleep 5 && curl -X POST -H "Content-Type: application/json" -d "{\\"ref\\":\\"$(git -C ~/.dotfiles rev-parse HEAD)\\", \\"status\\":\\"$(git -C ~/.dotfiles diff --quiet && echo "clean" || echo "dirty")\\"}" http://192.168.1.180:5678/webhook/config-checker',
	-- "quickshell",
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

-- If hyprgrass is present
if hl.plugin.hyprgrass ~= nil then
	hl.config({
		plugin = {
			hyprgrass = {
				sensitivity = 4.0,
				long_press_delay = 400,
				resize_on_border_long_press = true,
				edge_margin = 20,
			},
		},
		gestures = {
			-- Disable buggy hyprland gestures
			workspace_swipe_touch = false,
			workspace_swipe_cancel_ratio = 0.15,
		},
	})

	-- Float and drag windows using 3 fingers
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "tap", fingers = 3 },
		action = hl.dsp.window.float(),
	})
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "longpress", fingers = 2 },
		action = hl.dsp.window.drag(),
		mouse = true,
	})

	-- Swipe top edge to change workspace
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "edge", origin = "t", direction = "l" },
		action = hl.dsp.focus({ workspace = "+1" }),
	})
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "edge", origin = "t", direction = "r" },
		action = hl.dsp.focus({ workspace = "-1" }),
	})
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "edge", origin = "b", direction = "u" },
		action = hl.dsp.exec_cmd("wvkbd-mobintl"),
	})

	-- Tablet mode toggle
	hl.bind("switch:on:Intel HID switches", function()
		hl.exec_cmd("pkill way-edges")
		hl.exec_cmd("quickshell ipc call root enableTabletMode")
	end, { locked = true })
	hl.bind("switch:off:Intel HID switches", function()
		hl.exec_cmd("way-edges")
		hl.exec_cmd("quickshell ipc call root disableTabletMode")
	end, { locked = true })
end

-- Config for hyprgrass
if hl.plugin.hyprgrass ~= nil then
	hl.config({
		plugin = {
			hyprgrass = {
				-- The default sensitivity is probably too low on tablet screens,
				-- I recommend turning it up to 4.0
				sensitivity = 4.0,

				-- in milliseconds
				long_press_delay = 400,

				-- resize windows by long-pressing on window borders and gaps.
				-- If general:resize_on_border is enabled, general:extend_border_grab_area is
				-- used for floating windows
				resize_on_border_long_press = true,

				-- in pixels, the distance from the edge that is considered an edge
				edge_margin = 10,
			},
		},
		gestures = {
			workspace_swipe_touch = true,
			workspace_swipe_cancel_ratio = 0.15,
		},
	})
	hl.gesture({
		fingers = 3,
		direction = "horizontal",
		action = "workspace",
	})

	hl.notification.create({
		text = "not using main config",
		timeout = 8000,
		icon = "warning",
	})
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "tap", fingers = 3 },
		action = hl.dsp.window.float(),
	})
	hl.plugin.hyprgrass.bind({
		pattern = { kind = "longpress", fingers = 3 },
		action = hl.dsp.window.drag(),
		mouse = true,
	})
	hl.plugin.hyprgrass.gesture({
		pattern = { kind = "swipe", fingers = 2, direction = "vertical" },
		action = "emulate_touchpad",
		emulate_fingers = 2,
	})
	hl.bind("switch:on:Intel HID switches", function()
		hl.notification.create({
			text = "tablet mode on",
			timeout = 8000,
			icon = "ok",
		})
	end, { locked = true })
	hl.bind("switch:off:Intel HID switches", function()
		hl.notification.create({
			text = "tablet mode off",
			timeout = 8000,
			icon = "ok",
		})
	end, { locked = true })
end

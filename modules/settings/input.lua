hl.config({
	input = {
		kb_layout = "gb", -- Goddamn kier starmer
		follow_mouse = 1, -- Moving to a window will focus it

		touchpad = {
			natural_scroll = true, -- Better scrolling
			disable_while_typing = true, -- Sanity
		},

		sensitivity = -0.3, -- DPI is too high ffs
		force_no_accel = false, -- I love mouse acceleration
		tablet = {
			left_handed = true, -- Top 10 disabilities
			output = "current", -- Make the tablet usable
		},
	},
	cursor = {
		inactive_timeout = 2, -- Hide white thing on the screen
		hide_on_key_press = true, -- Hide white thing when typing
		warp_on_change_workspace = 1, -- Make it go to workspaces
		warp_on_toggle_special = 1, -- Go to special workspaces too
		persistent_warps = true, -- Go back to where it was when I warp
	},
})

-- Config for hyprgrass
hl.config({
	plugin = {
		hyprgrass = {
			-- The default sensitivity is probably too low on tablet screens,
			-- I recommend turning it up to 4.0
			sensitivity = 2.0,

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

if Hostname == "mobile02" or Hostname == "mobile03" then
	hl.config({
		input = { -- If on laptop make caps the escape key but make it be capslock when shift caps is pressed
			kb_options = "caps:escape_shifted_capslock",
		},
	})
elseif Hostname == "HACKSTATION" then
	hl.device({
		name = "weylus-stylus",
		left_handed = false,
		output = "DP-1",
	})
	hl.device({
		name = "weylus-touch",
		output = "DP-1",
	})
end

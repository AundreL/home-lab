local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("UbuntuMono Nerd Font Mono")

config.font_size = 13
config.initial_cols = 240
config.initial_rows = 80
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.color_scheme = "nord"

config.wsl_domains = {
	{
		name = "WSL:NixOS",
		distribution = "NixOS",
		username = "aundre",
		default_cwd = "~",
	},
}

config.default_domain = "WSL:NixOS"

config.window_close_confirmation = "NeverPrompt"
-- example code for using wezterm as a multiplexer
-- config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
--
-- config.keys = {
-- 	{
-- 		key = "%",
-- 		mods = "LEADER|SHIFT",
-- 		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
-- 	},
-- }

return config

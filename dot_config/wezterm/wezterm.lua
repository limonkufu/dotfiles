-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

local mux = wezterm.mux
local act = wezterm.action

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
-- config.window_decorations = "RESIZE"

-- config.default_prog = { 'zellij', '-l', 'welcome' }
config.term = 'wezterm'

config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors = {
  visual_bell = '#202020',
}

config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 3, right = 3,
  top = 3, bottom = 3,
}

wezterm.on('gui-startup', function()
 local tab, pane, window = mux.spawn_window({})
end)

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.6,
}

config.font_size = 16
config.font = wezterm.font "CaskaydiaCove Nerd Font"
config.adjust_window_size_when_changing_font_size = false

config.wsl_domains = {
  {
    -- The name of this specific domain.  Must be unique amonst all types
    -- of domain in the configuration file.
    name = 'WSL:Ubuntu',

    -- The name of the distribution.  This identifies the WSL distribution.
    -- It must match a valid distribution from your `wsl -l -v` output in
    -- order for the domain to be useful.
    distribution = 'Ubuntu',

    -- The username to use when spawning commands in the distribution.
    -- If omitted, the default user for that distribution will be used.

    -- username = "hunter",

    -- The current working directory to use when spawning commands, if
    -- the SpawnCommand doesn't otherwise specify the directory.

    default_cwd = "/home/limonkufu/dev"

    -- The default command to run, if the SpawnCommand doesn't otherwise
    -- override it.  Note that you may prefer to use `chsh` to set the
    -- default shell for your user inside WSL to avoid needing to
    -- specify it here

    -- default_prog = {"fish"}
  },
}

config.keys = {
  {
    key = 'P',
    mods = 'SUPER',
    action = act.ActivateCommandPalette,
  },
  { key = 'T', mods = 'SUPER', action = act.SpawnCommandInNewTab 
    {
           cwd = wezterm.home_dir .. '/dev',

    },
  },
  {
    key = 'y',
    mods = 'CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'top' },
    },
  },
  {
    key = 'K',
    mods = 'SUPER',
    action = wezterm.action.SplitPane {
      direction = 'Right',
      command = { args = { '/opt/homebrew/bin/k9s' } },
      size = { Percent = 50 },
    },
  },
  {
    key = 'W',
    mods = 'SUPER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

config.skip_close_confirmation_for_processes_named = {
  'bash',
  'sh',
  'zsh',
  'fish',
  'tmux',
  'nu',
  'cmd.exe',
  'pwsh.exe',
  'powershell.exe',
}

config.use_dead_keys = false
config.scrollback_lines = 5000

config.default_cwd = wezterm.home_dir .. '/dev'
-- config.default_domain = 'WSL:Ubuntu'

-- and finally, return the configuration to wezterm
return config

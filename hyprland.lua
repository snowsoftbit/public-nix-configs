
-- Important:
-- Lua Hyprland config for NixOS + Noctalia Shell
-- Target: Hyprland 0.55+

------------------------------------------------------------
-- Programs / variables
------------------------------------------------------------

local terminal = "kitty"
local fileManager = "nautilus"
local mainMod = "SUPER"
local ipc = "noctalia msg "


------------------------------------------------------------
-- Monitors
------------------------------------------------------------

-- DP-2 portrait 3840x2160@160 scale 1.5 rotated 90 at 0x0
hl.monitor({
    output = "DP-2",
    mode = "3840x2160@160",
    position = "0x0",
    scale = 1.5,
    transform = 1,
})

-- DP-1 landscape 3840x2160@160 scale 1.5 at 1440x750
hl.monitor({
    output = "DP-1",
    mode = "3840x2160@160",
    position = "1440x750",
    scale = 1.5,
})

------------------------------------------------------------
-- Environment variables
------------------------------------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Session identity for portals, launchers, Qt/Quickshell, and desktop integration.
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("DESKTOP_SESSION", "Hyprland")

-- Make sure Quickshell/Noctalia sees the normal user environment.
hl.env("HOME", "/home/orbit")
hl.env("USER", "orbit")
hl.env("LOGNAME", "orbit")

-- NixOS desktop/app discovery paths.
hl.env("XDG_DATA_DIRS", "/run/current-system/sw/share:/etc/profiles/per-user/orbit/share:/usr/local/share:/usr/share")
hl.env("PATH", "/run/wrappers/bin:/run/current-system/sw/bin:/etc/profiles/per-user/orbit/bin:/home/orbit/.nix-profile/bin:/usr/local/bin:/usr/bin:/bin")
------------------------------------------------------------
-- Permissions
------------------------------------------------------------

-- Disabled for now on NixOS.
-- Do not enable Hyprland plugin permissions until plugins are actually configured.
-- NixOS does not usually use /usr/bin or /usr/local/bin for package paths.
--
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

------------------------------------------------------------
-- Main Hyprland config
------------------------------------------------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,

        col = {
            active_border = {
                colors = { "rgba(5f5f5fff)", "rgba(484848dd)" },
                angle = 45,
            },
            inactive_border = "rgba(48484888)",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity = 1.0,
        inactive_opacity = 0.98,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(00000088)",
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = false,
    },

    input = {
        kb_layout = "de",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules = "",

        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    cursor = {
        no_hardware_cursors = 0,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

------------------------------------------------------------
-- Animation curves
------------------------------------------------------------

hl.curve("easeOutQuint", {
    type = "bezier",
    points = { { 0.23, 1 }, { 0.32, 1 } },
})

hl.curve("easeInOutCubic", {
    type = "bezier",
    points = { { 0.65, 0.05 }, { 0.36, 1 } },
})

hl.curve("linear", {
    type = "bezier",
    points = { { 0, 0 }, { 1, 1 } },
})

hl.curve("almostLinear", {
    type = "bezier",
    points = { { 0.5, 0.5 }, { 0.75, 1 } },
})

hl.curve("quick", {
    type = "bezier",
    points = { { 0.15, 0 }, { 0.1, 1 } },
})

------------------------------------------------------------
-- Animations
------------------------------------------------------------

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

------------------------------------------------------------
-- Gestures
------------------------------------------------------------

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

------------------------------------------------------------
-- Per-device input config
------------------------------------------------------------

hl.device({
    name = "epic-mouse-v1",
    sensitivity = 0.4,
})

------------------------------------------------------------
-- Keybindings: core apps / system
------------------------------------------------------------

hl.bind(mainMod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T",      hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Uses hyprshutdown if available.
-- If hyprshutdown is not installed yet, this binding will do nothing.
hl.bind( mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))

hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

------------------------------------------------------------
-- Keybindings: Noctalia v5
------------------------------------------------------------

-- Application launcher
hl.bind(
    mainMod .. " + SPACE",
    hl.dsp.exec_cmd(ipc .. "panel-toggle launcher")
)

-- Session menu
hl.bind(
    mainMod .. " + X",
    hl.dsp.exec_cmd(ipc .. "panel-toggle session")
)

hl.bind(
    mainMod .. " + SHIFT + ESCAPE",
    hl.dsp.exec_cmd(ipc .. "panel-toggle session")
)

-- Notification history
hl.bind(
    mainMod .. " + TAB",
    hl.dsp.exec_cmd(ipc .. "panel-toggle control-center notifications")
)

-- Full Control Center
hl.bind(
    mainMod .. " + SHIFT + TAB",
    hl.dsp.exec_cmd(ipc .. "panel-toggle control-center")
)

-- Do Not Disturb
hl.bind(
    mainMod .. " + D",
    hl.dsp.exec_cmd(ipc .. "notification-dnd-toggle")
)

-- Lock screen
hl.bind(
    mainMod .. " + L",
    hl.dsp.exec_cmd(ipc .. "session lock")
)

-- Clipboard history
hl.bind(
    mainMod .. " + SHIFT + V",
    hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard")
)

-- Calculator is integrated into the v5 launcher.
-- Type an expression containing a number after opening it.
hl.bind(
    mainMod .. " + SHIFT + C",
    hl.dsp.exec_cmd(ipc .. "panel-toggle launcher")
)

-- Play/pause
hl.bind(
    mainMod .. " + SHIFT + P",
    hl.dsp.exec_cmd(ipc .. "media toggle")
)

-- Noctalia settings
hl.bind(
    mainMod .. " + SHIFT + O",
    hl.dsp.exec_cmd(ipc .. "settings-toggle")
)

-- Wallpaper picker
hl.bind(
    mainMod .. " + W",
    hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper")
)

-- Noctalia window switcher
hl.bind(
    "ALT + TAB",
    hl.dsp.exec_cmd(ipc .. "window-switcher")
)

------------------------------------------------------------
-- Keybindings: focus movement
------------------------------------------------------------

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

------------------------------------------------------------
-- Keybindings: workspaces
------------------------------------------------------------

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

------------------------------------------------------------
-- Keybindings: scratchpad / special workspace
------------------------------------------------------------

hl.bind(mainMod .. " + ALT + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

------------------------------------------------------------
-- Keybindings: scroll through existing workspaces
------------------------------------------------------------

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

------------------------------------------------------------
-- Keybindings: mouse window movement / resizing
------------------------------------------------------------

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

------------------------------------------------------------
-- Keybindings: multimedia / brightness
------------------------------------------------------------

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)

hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    { locked = true, repeating = true }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    { locked = true, repeating = true }
)

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

------------------------------------------------------------
-- Keybindings: audio control
------------------------------------------------------------

hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("pavucontrol"))

------------------------------------------------------------
-- Keybindings: move window within layout
------------------------------------------------------------

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))

------------------------------------------------------------
-- Keybindings: move window between monitors
------------------------------------------------------------

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ monitor = "+1" }))

------------------------------------------------------------
-- Keybindings: screenshots
------------------------------------------------------------

-- Area screenshot -> save to file
hl.bind(
    mainMod .. " + S",
    hl.dsp.exec_cmd([[grim -g "$(slurp)" /home/orbit/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png]])
)

-- Area screenshot -> copy to clipboard
hl.bind(
    mainMod .. " + SHIFT + S",
    hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]])
)

-- Area screenshot -> edit in swappy
hl.bind(
    mainMod .. " + CTRL + S",
    hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]])
)

------------------------------------------------------------
-- Window rules: general
------------------------------------------------------------

-- Ignore maximize requests from apps
hl.window_rule({
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland empty class/title popup windows
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

------------------------------------------------------------
-- Window rules: app-specific transparency / rounding
------------------------------------------------------------

hl.window_rule({
    name = "opacity-nautilus",
    match = {
        class = "org.gnome.Nautilus",
    },
    opacity = "0.92 override 0.86 override 1.0 override",
    rounding = 14,
})

------------------------------------------------------------
-- Noctalia Blur rules: This Enable blur for Noctalia’s 
-- bar, panels, dock, and notifications.
------------------------------------------------------------

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

------------------------------------------------------------
-- Workspace overview
------------------------------------------------------------

-- Noctalia Shell provides the shell-side overview/launcher experience.

hl.on("hyprland.start", function()
    -- Export the Hyprland/Wayland environment to the systemd user manager.
    hl.exec_cmd("dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE DESKTOP_SESSION HYPRLAND_INSTANCE_SIGNATURE HOME USER LOGNAME PATH XDG_DATA_DIRS")

    -- Polkit authentication agent.
    -- Start it after WAYLAND_DISPLAY has been exported.
    --hl.exec_cmd("systemctl --user start hyprpolkitagent.service")

    -- Noctalia shell
    hl.exec_cmd("noctalia")

    -- Waybar fallback disabled while Noctalia is active
    -- hl.exec_cmd("waybar")
end)

-- For Noctalia Color templates
require("noctalia").apply_theme()
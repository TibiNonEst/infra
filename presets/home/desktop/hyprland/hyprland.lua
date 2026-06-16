hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

local mod          = "SUPER"
local terminal     = "ghostty"
local browser      = "firefox"
local menu         = "fuzzel"
local file_manager = "thunar"
local editor       = "zeditor"

hl.on("hyprland.start", function()
    hl.exec_cmd("avizo service")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wayland-pipewire-idle-inhibit")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
end)

hl.config({
    general = {
        gaps_in     = 8,
        gaps_out    = 8,
        border_size = 0,
    },

    decoration = {
        rounding     = 8,
        dim_inactive = true,

        blur         = {
            enabled = false,
        },

        shadow       = {
            enabled = false,
        }
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_model = "pc104",
        natural_scroll = true,

        touchpad = {
            disable_while_typing = false,
            natural_scroll       = true,
            clickfinger_behavior = true,
        }
    }
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("mullvad-exclude " .. terminal))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + SHIFT + D", hl.dsp.exec_cmd("mullvad-exclude " .. menu))
hl.bind(mod .. " + T", hl.dsp.exec_cmd(file_manager))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(editor))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --private-window"))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind(mod .. " + PRINT", hl.dsp.exec_cmd(
    "hyprshot -m region --freeze -r -- | satty --filename - --fullscreen --output-filename \"~/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png\""))

hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volumectl -u up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volumectl -u down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volumectl toggle-mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("lightctl up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("lightctl down"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.window_rule({
    name = "fullscreen-inhibit-idle",
    match = { fullscreen = true },
    idle_inhibit = "focus",
})

hl.window_rule({
    name = "float-firefox-extensions",
    match = { class = "firefox", title = "(Extension:.*)" },
    float = true,
})

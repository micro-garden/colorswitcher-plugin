VERSION = "0.0.0"

math.randomseed(os.time())

local config = import("micro/config")
local micro = import("micro")

local colors = {
	"atom-dark",
	"bubblegum",
	"cmc-16",
	"cmc-tc",
	"darcula",
	"default",
	"dracula-tc",
	"dukedark-tc",
	"dukelight-tc",
	"dukeubuntu-tc",
	"geany",
	"gotham",
	"gruvbox",
	"gruvbox-tc",
	"material-tc",
	"monokai",
	"monokai-dark",
	"one-dark",
	"railscast",
	"simple",
	"solarized",
	"solarized-tc",
	"sunny-day",
	"twilight",
	"zenburn",
}

function indexOf(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return 0
end

local current = indexOf(colors, config.GetGlobalOption("colorscheme"))

function applyColorScheme()
	config.SetGlobalOption("colorscheme", colors[current])
	micro.InfoBar():Message("Color scheme set to: " .. colors[current])
end

function nextColorScheme(bp)
	current = current + 1
	if current > #colors then
		current = 1
	end
	applyColorScheme()
end

function prevColorScheme(bp)
	current = current - 1
	if current < 1 then
		current = #colors
	end
	applyColorScheme()
end

function randomColorScheme(bp)
	local old = current
	repeat
		current = math.random(1, #colors)
	until current ~= old
	applyColorScheme()
end

function init()
	config.MakeCommand("nextcolorscheme", nextColorScheme, config.NoComplete)
	config.MakeCommand("prevcolorscheme", prevColorScheme, config.NoComplete)
	config.MakeCommand("randcolorscheme", randomColorScheme, config.NoComplete)
	config.TryBindKey("Ctrl-Alt-j", "lua:colorswitcher.nextColorScheme", false)
	config.TryBindKey("Ctrl-Alt-k", "lua:colorswitcher.prevColorScheme", false)
	config.TryBindKey("Ctrl-Alt-r", "lua:colorswitcher.randomColorScheme", false)
	config.AddRuntimeFile("colorswitcher", config.RTHelp, "help/colorswitcher.md")
end

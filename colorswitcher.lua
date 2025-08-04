VERSION = "0.0.2"

math.randomseed(os.time())

local micro = import("micro")
local config = import("micro/config")

local function convert_userdata_array_to_table(ud)
	local result = {}
	for i = 1, #ud do
		result[i] = ud[i]
	end
	return result
end

local function get_colorschemes()
	local raw = config.ListRuntimeFiles(config.RTColorscheme)
	return convert_userdata_array_to_table(raw)
end

local colors = {}

local function index_of(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return 0
end

local current = "default"

local function apply_color_scheme()
	config.SetGlobalOption("colorscheme", colors[current])
	micro.InfoBar():Message("Color scheme set to: " .. colors[current])
end

function nextColorScheme(bp)
	current = current + 1
	if current > #colors then
		current = 1
	end
	apply_color_scheme()
end

function prevColorScheme(bp)
	current = current - 1
	if current < 1 then
		current = #colors
	end
	apply_color_scheme()
end

function randomColorScheme(bp)
	local old = current
	repeat
		current = math.random(1, #colors)
	until current ~= old
	apply_color_scheme()
end

function init()
	colors = get_colorschemes()
	current = index_of(colors, config.GetGlobalOption("colorscheme"))

	config.MakeCommand("nextcolorscheme", nextColorScheme, config.NoComplete)
	config.MakeCommand("prevcolorscheme", prevColorScheme, config.NoComplete)
	config.MakeCommand("randcolorscheme", randomColorScheme, config.NoComplete)
	config.TryBindKey("Ctrl-Alt-j", "lua:colorswitcher.nextColorScheme", false)
	config.TryBindKey("Ctrl-Alt-k", "lua:colorswitcher.prevColorScheme", false)
	config.TryBindKey("Ctrl-Alt-r", "lua:colorswitcher.randomColorScheme", false)
	config.AddRuntimeFile("colorswitcher", config.RTHelp, "help/colorswitcher.md")
end

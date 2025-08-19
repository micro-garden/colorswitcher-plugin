VERSION = "0.0.4"

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

local function apply_colorscheme()
	config.SetGlobalOption("colorscheme", colors[current])
	micro.InfoBar():Message("Colorscheme set to: " .. colors[current])
end

function NextColorscheme(bp)
	current = current + 1
	if current > #colors then
		current = 1
	end
	apply_colorscheme()
end

function PrevColorscheme(bp)
	current = current - 1
	if current < 1 then
		current = #colors
	end
	apply_colorscheme()
end

function RandColorscheme(bp)
	local old = current
	repeat
		current = math.random(1, #colors)
	until current ~= old
	apply_colorscheme()
end

function init()
	colors = get_colorschemes()
	current = index_of(colors, config.GetGlobalOption("colorscheme"))

	config.MakeCommand("nextcolorscheme", NextColorscheme, config.NoComplete)
	config.MakeCommand("prevcolorscheme", PrevColorscheme, config.NoComplete)
	config.MakeCommand("randcolorscheme", RandColorscheme, config.NoComplete)
	config.TryBindKey("Ctrl-Alt-j", "lua:colorswitcher.NextColorscheme", false)
	config.TryBindKey("Ctrl-Alt-k", "lua:colorswitcher.PrevColorscheme", false)
	config.TryBindKey("Ctrl-Alt-r", "lua:colorswitcher.RandColorscheme", false)
	config.AddRuntimeFile("colorswitcher", config.RTHelp, "help/colorswitcher.md")
end

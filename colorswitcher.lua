VERSION = "0.0.3"

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

function NextColorschemeCmd(bp)
	current = current + 1
	if current > #colors then
		current = 1
	end
	apply_colorscheme()
end

function PrevColorschemeCmd(bp)
	current = current - 1
	if current < 1 then
		current = #colors
	end
	apply_colorscheme()
end

function RandColorschemeCmd(bp)
	local old = current
	repeat
		current = math.random(1, #colors)
	until current ~= old
	apply_colorscheme()
end

function init()
	colors = get_colorschemes()
	current = index_of(colors, config.GetGlobalOption("colorscheme"))

	config.MakeCommand("nextcolorscheme", NextColorschemeCmd, config.NoComplete)
	config.MakeCommand("prevcolorscheme", PrevColorschemeCmd, config.NoComplete)
	config.MakeCommand("randcolorscheme", RandColorschemeCmd, config.NoComplete)
	config.TryBindKey("Ctrl-Alt-j", "lua:colorswitcher.NextColorschemeCmd", false)
	config.TryBindKey("Ctrl-Alt-k", "lua:colorswitcher.PrevColorschemeCmd", false)
	config.TryBindKey("Ctrl-Alt-r", "lua:colorswitcher.RandColorschemeCmd", false)
	config.AddRuntimeFile("colorswitcher", config.RTHelp, "help/colorswitcher.md")
end

VERSION = "0.0.0"

math.randomseed(os.time())

local config = import("micro/config")
local shell = import("micro/shell")
local micro = import("micro")

local builtin = {
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

function extractNames(lines)
	local list = {}
	for line in lines:gmatch("[^\r\n]+") do
		local name = line:match("([^/\\]+)%.micro$")
		if name then
			table.insert(list, name)
		end
	end
	return list
end

function getAvailableColorSchemes()
	local dir = config.ConfigDir .. "/colorschemes"

	-- Try Unix-style ls
	local out, err = shell.ExecCommand("ls", "-1", dir)
	if out and out ~= "" then
		return extractNames(out)
	end

	-- Try Windows-style dir via cmd
	out, err = shell.ExecCommand("cmd", "/C", "dir", "/b", dir .. "\\*.micro")
	if out and out ~= "" then
		return extractNames(out)
	end

	-- If both methods fail
	micro.InfoBar():Error("Unable to list color schemes.")
	return {}
end

function mergeColorSchemes()
	local merged = getAvailableColorSchemes()

	for _, b in ipairs(builtin) do
		table.insert(merged, b)
	end

	local seen = {}
	local unique = {}
	for _, name in ipairs(merged) do
		if not seen[name] then
			seen[name] = true
			table.insert(unique, name)
		end
	end

	table.sort(unique)
	return unique
end

local colors = mergeColorSchemes()

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

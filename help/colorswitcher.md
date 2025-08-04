# Color Switcher Plugin

**Color Switcher** is a plugin that allows you to easily switch between color
schemes using keyboard shortcuts or commands.

## Features

- Cycle through installed color schemes with:
  - `Ctrl-Alt-j` → Next color scheme
  - `Ctrl-Alt-k` → Previous color scheme
  - `Ctrl-Alt-r` → Random color scheme
- See the name of the current scheme in the status bar
- Includes three commands: `nextcolorscheme`, `prevcolorscheme`,
  `randcolorscheme`

## Usage

### Keybindings

- `Ctrl-Alt-j` : Switch to the next color scheme in the list
- `Ctrl-Alt-k` : Switch to the previous color scheme
- `Ctrl-Alt-r` : Switch to a random color scheme

These keybindings are defined using `TryBindKey`, so you can override them in
your own bindings if desired.

### Commands

You can also use commands directly:

- `>nextcolorscheme`
- `>prevcolorscheme`
- `>randcolorscheme`

These can be useful in case your keyboard layout makes certain keybindings
difficult to type.

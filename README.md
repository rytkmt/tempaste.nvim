# tempaste.nvim

A Neovim plugin to apply template files to the current buffer.

## Requirements

- Neovim >= 0.10
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (optional, for picker UI)

## Installation

### lazy.nvim

```lua
{
  "rytkmt/tempaste.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- optional
  },
  opts = {
    templates_dir = "~/.config/nvim/templates/common",
    filetype_templates_dir = "~/.config/nvim/templates/ft",
  },
}
```

### packer.nvim

```lua
use({
  "rytkmt/tempaste.nvim",
  requires = {
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    require("tempaste").setup({
      templates_dir = "~/.config/nvim/templates/common",
      filetype_templates_dir = "~/.config/nvim/templates/ft",
    })
  end,
})
```

## Configuration

```lua
require("tempaste").setup({
  -- Directory for templates available to all filetypes
  templates_dir = "~/.config/nvim/templates/common",

  -- Parent directory containing filetype-specific subdirectories
  filetype_templates_dir = "~/.config/nvim/templates/ft",
})
```

### Template directory structure

```
templates/
├── common/              -- Available to all filetypes
│   └── mit_license.txt
└── ft/                  -- Filetype-specific (subdirectory = filetype name)
    ├── ruby/
    │   └── model.rb
    ├── typescript/
    │   └── component.tsx
    └── python/
        └── script.py
```

When editing a Ruby file, the available templates are:
- All files in `common/`
- All files in `ft/ruby/`

## Usage

### Command

```vim
:Tempaste {template_name}
```

Tab completion is supported and shows templates matching the current filetype.

### Telescope

```vim
:Telescope tempaste
```

Load the extension in your telescope config:

```lua
require("telescope").load_extension("tempaste")
```

## License

MIT

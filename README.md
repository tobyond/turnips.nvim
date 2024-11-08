# turnips.nvim

A Neovim plugin for quick navigation between alternate files (implementation and test files, components and templates, etc.).

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "tobyond/turnips.nvim",
  config = function()
    require("turnips").setup({
      test = {
        patterns = {
          {'app/**/*.rb', 'spec/**/*_spec.rb'},
        },
        overrides = {
          {'app/controllers/**/*_controller.rb', 'spec/requests/**/*_spec.rb'},
          {'app/controllers/**/*_controller.rb', 'spec/requests/**/*_request_spec.rb'},
        }
      },
      related = {
        patterns = {
          {'app/components/**/*.rb', 'app/components/**/*.html.erb'}
        },
        overrides = {}
      }
    })
  end,
}
```

## Usage

The plugin provides several commands:
- `:ATV` - Open test file in vertical split
- `:ATS` - Open test file in horizontal split
- `:ARV` - Open related file in vertical split
- `:ARS` - Open related file in horizontal split
- `:ACV` - Open custom file in vertical split
- `:ACS` - Open custom file in horizontal split

## Configuration

You can configure patterns for different types of files:

```lua
require("turnips").setup({
  -- Configuration here
})
```

## Running Tests

```bash
nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/ {minimal_count=1}"
```

## License

MIT

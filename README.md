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


## FAQ

**Q: What is this again?**
A: It allows you to define the location of an "alternate" file. eg, working in your model, ATV will source your spec, if you set it up like above.

**Q: What about a.vim, vim-rails, and all the others that do this?**
A: They're probably more useful, I was just not getting what I wanted from them so I rolled my own.

**Q: Do I need Rails?**
A: Probably not, I just use it, so it's configured for it by default. If you try a different framework and find issues, create an issue, we can take a look.

**Q: It's lua, is it "BLAZINGLY FAST"?**
A: Meh, maybe, dunno.

**Q: I want to open files in the current buffer?**
A: That's not a question, but yeah, it might get added if you ask nicely enough. Create an issue. 

**Q: Hehe, ATV stands for all terrain vehicle?**
A: Once again, not a question, but [A] alternate [T] test [V] vsplit. You can work the rest out from there.

## Configuration

You can configure patterns for different types of files:

```lua
require("turnips").setup({
  -- test is triggered by the AT prefixes
  test = {
    -- add default pattern here
    patterns = {
      -- {'app/**/*.rb', 'spec/**/*_spec.rb'},
    },
    -- add overrides here, note there a multiple here, it will look for them all
    overrides = {
      -- {'app/controllers/**/*_controller.rb', 'spec/requests/**/*_spec.rb'},
      -- {'app/controllers/**/*_controller.rb', 'spec/requests/**/*_request_spec.rb'},
    }
  },
  -- related is triggered by the AR prefixes
  related = {
    patterns = {
      -- add default pattern here
      -- {'app/components/**/*.rb', 'app/components/**/*.html.erb'}
    },
    overrides = {}
  },
  -- related is triggered by the AC prefixes
  custom = {
    patterns = {},
    overrides = {}
  }
})
```

## Running Tests

```bash
nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/ {minimal_count=1}"
```

## License

MIT

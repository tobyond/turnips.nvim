# turnips.nvim

A Neovim plugin for quick navigation between alternate files (implementation and test files, components and templates, etc.)

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
- `:ATV` or `:TFV` - Open test file in vertical split
- `:ATS` or `:TFS` - Open test file in horizontal split
- `:ATE` or `:TFE` - Open test file in current buffer
- `:ARV` or `:RFV` - Open related file in vertical split
- `:ARS` or `:RFS` - Open related file in horizontal split
- `:ARE` or `:RFE` - Open related file in current buffer
- `:ACV` or `:CFV` - Open custom file in vertical split
- `:ACS` or `:CFS` - Open custom file in horizontal split
- `:ACE` or `:CFE` - Open custom file in current buffer


## FAQ

**Q: What is this again?**
A: It allows you to define the location of an "alternate" file. eg, working in your model, ATV will source your spec, if you set it up like above.

**Q: What about a.vim, vim-rails, and all the others that do this?**
A: They're probably more useful, I was just not getting what I wanted from them so I rolled my own.

**Q: Do I need Rails?**
A: Nope, I'm just working on a Rails project at the moment. If you try a different framework and find issues, create an issue, we can take a look.

**Q: It's lua, is it "BLAZINGLY FAST"?**
A: Meh, maybe, dunno. I'm using it, and it's not slowing me down.

**Q: I want to open files in the current buffer?**
A: That's not a question, but yeah, it might get added if you ask nicely enough. Create an issue. 

**Q: Hehe, ATV stands for all terrain vehicle?**
A: Once again, not a question, but [A]lternate [T]est [V]split. You can work the rest out from there.

**Q: Why the mulitple prefixes?**
A: I'm still ironing out the details, and haven't decided whether the [A]lternate [T]est [V]split or [T]est [F]ile [V]split is more vim-like

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

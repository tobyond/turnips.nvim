local mock_fs = {
  -- Existing files
  ["app/models/user.rb"] = true,
  ["spec/models/user_spec.rb"] = true,
}

local created_dirs = {}
local last_command = nil
local current_file = ""

-- Mock vim namespace
_G.vim = _G.vim or {}
_G.vim.fn = _G.vim.fn or {}
_G.vim.log = _G.vim.log or { levels = { WARN = 1 } }

-- Mock vim.cmd
_G.vim.cmd = function(cmd)
  last_command = cmd
  -- No need to track directory creation for command execution
  -- since we're handling that through vim.fn.mkdir
end

_G.vim.fn.expand = function(expr)
  return current_file
end

_G.vim.fn.filereadable = function(path)
  return mock_fs[path] and 1 or 0
end

_G.vim.fn.fnamemodify = function(path, modifier)
  if modifier == ':h' then
    return path:match("(.*)/[^/]*$") or path
  end
  return path
end

_G.vim.fn.isdirectory = function(path)
  -- Check if directory exists in mock_fs
  local dir_exists = mock_fs[path .. '/'] and true or false
  -- Return 1 if directory was created or exists in mock_fs
  return (created_dirs[path] or dir_exists) and 1 or 0
end

_G.vim.fn.mkdir = function(path, mode)
  created_dirs[path] = true
  return 1
end

_G.vim.fn.fnameescape = function(path)
  return path
end

describe("turnips.nvim file creation", function()
  local turnips

  before_each(function()
    package.loaded['turnips'] = nil
    package.loaded['turnips.init'] = nil
    package.loaded['turnips.utils'] = nil
    
    -- Reset tracking variables
    created_dirs = {}
    last_command = nil
    
    turnips = require("turnips")
    
    turnips.setup({
      test = {
        patterns = {
          {'app/**/*.rb', 'spec/**/*_spec.rb'},
        }
      },
      related = {
        patterns = {
          {'app/components/**/*.rb', 'app/components/**/*.html.erb'}
        }
      }
    })
  end)

  describe("file creation", function()
    it("should create directory and open new test file", function()
      current_file = "app/models/new_feature.rb"
      
      turnips.open_test('vsplit')
      
      assert.equals(true, created_dirs["spec/models"] ~= nil)
      assert.equals('vsplit spec/models/new_feature_spec.rb', last_command)
    end)

    it("should create nested directories for deep paths", function()
      current_file = "app/models/admin/reports/monthly.rb"
      
      turnips.open_test('split')
      
      assert.equals(true, created_dirs["spec/models/admin/reports"] ~= nil)
      assert.equals('split spec/models/admin/reports/monthly_spec.rb', last_command)
    end)

    it("should open existing file without creating directory", function()
      current_file = "app/models/user.rb"
      -- Add the spec directory to mock_fs to simulate it already existing
      mock_fs["spec/models/"] = true
      
      turnips.open_test('e')
      
      assert.equals('e spec/models/user_spec.rb', last_command)
      -- Check that no new directories were created
      assert.equals(nil, next(created_dirs))
    end)

    it("should handle creation of related files", function()
      current_file = "app/components/new/widget_component.rb"
      
      turnips.open_related('vsplit')
      
      assert.equals(true, created_dirs["app/components/new"] ~= nil)
      assert.equals('vsplit app/components/new/widget_component.html.erb', last_command)
    end)
  end)
end)

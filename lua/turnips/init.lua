local utils = require('turnips.utils')
local M = {}

M.config = {
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
  },
  custom = {}
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

function M.find_alternate_file(current_file, config)
  -- Try overrides first
  if config.overrides and #config.overrides > 0 then
    local match = utils.try_patterns(current_file, config.overrides)
    if match then
      return match
    end
  end
  
  -- Fall back to standard patterns
  if config.patterns and #config.patterns > 0 then
    return utils.try_patterns(current_file, config.patterns)
  end
  
  return nil
end

-- Open file with specified command
local function open_file(file, cmd)
  if file then
    vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(file))
  else
    vim.notify('No alternate file found', vim.log.levels.WARN)
  end
end

-- Command handlers
function M.open_test(split_cmd)
  local current_file = vim.fn.expand('%')
  local alternate = M.find_alternate_file(current_file, M.config.test)
  open_file(alternate, split_cmd)
end

function M.open_custom(split_cmd)
  local current_file = vim.fn.expand('%')
  local alternate = M.find_alternate_file(current_file, M.config.custom)
  open_file(alternate, split_cmd)
end

function M.open_related(split_cmd)
  local current_file = vim.fn.expand('%')
  local alternate = M.find_alternate_file(current_file, M.config.related)
  open_file(alternate, split_cmd)
end

-- Set up commands
function M.setup_commands()
  vim.api.nvim_create_user_command('ATV', function() M.open_test('vsplit') end, {})
  vim.api.nvim_create_user_command('ATS', function() M.open_test('split') end, {})
  vim.api.nvim_create_user_command('ARV', function() M.open_related('vsplit') end, {})
  vim.api.nvim_create_user_command('ARS', function() M.open_related('split') end, {})
  vim.api.nvim_create_user_command('ACV', function() M.open_custom('vsplit') end, {})
  vim.api.nvim_create_user_command('ACS', function() M.open_custom('split') end, {})
end

M.setup_commands()

return M

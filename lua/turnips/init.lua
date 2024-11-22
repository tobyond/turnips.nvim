local utils = require('turnips.utils')
local M = {}
M.config = {}

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

-- Open file with specified command, creating it if it doesn't exist
local function open_file(file, cmd)
  if file then
    -- Check if the file exists
    local exists = vim.fn.filereadable(file) == 1
    
    if not exists then
      -- Create the directory structure if it doesn't exist
      local dir = vim.fn.fnamemodify(file, ':h')
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end
    end
    
    -- Open the file regardless of whether it exists
    vim.cmd(cmd .. ' ' .. vim.fn.fnameescape(file))
  else
    vim.notify('Could not determine alternate file path', vim.log.levels.WARN)
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
  ----------------
  -- test files --
  ----------------
  -- vertical split
  vim.api.nvim_create_user_command('ATV', function() M.open_test('vsplit') end, {})
  vim.api.nvim_create_user_command('TFV', function() M.open_test('vsplit') end, {})
  -- horizontal split
  vim.api.nvim_create_user_command('ATS', function() M.open_test('split') end, {})
  vim.api.nvim_create_user_command('TFS', function() M.open_test('split') end, {})
  -- in current buffer
  vim.api.nvim_create_user_command('ATE', function() M.open_test('e') end, {})
  vim.api.nvim_create_user_command('TFE', function() M.open_test('e') end, {})
  
  ---------------------
  -- alternate files --
  ---------------------
  -- vertical split
  vim.api.nvim_create_user_command('ARV', function() M.open_related('vsplit') end, {})
  vim.api.nvim_create_user_command('RFV', function() M.open_related('vsplit') end, {})
  -- horizontal split
  vim.api.nvim_create_user_command('ARS', function() M.open_related('split') end, {})
  vim.api.nvim_create_user_command('RFS', function() M.open_related('split') end, {})
  -- in current buffer
  vim.api.nvim_create_user_command('ARE', function() M.open_related('e') end, {})
  vim.api.nvim_create_user_command('RFE', function() M.open_related('e') end, {})
  
  ------------------
  -- custom files --
  ------------------
  -- vertical split
  vim.api.nvim_create_user_command('ACV', function() M.open_custom('vsplit') end, {})
  vim.api.nvim_create_user_command('CFV', function() M.open_custom('vsplit') end, {})
  -- horizontal split
  vim.api.nvim_create_user_command('ACS', function() M.open_custom('split') end, {})
  vim.api.nvim_create_user_command('CFS', function() M.open_custom('split') end, {})
  -- in current buffer
  vim.api.nvim_create_user_command('ACE', function() M.open_custom('e') end, {})
  vim.api.nvim_create_user_command('CFE', function() M.open_custom('e') end, {})
end

M.setup_commands()
return M

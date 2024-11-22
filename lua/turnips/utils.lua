local M = {}

-- Split a pattern into base directory and name pattern
local function split_pattern(pattern)
  -- Find the last separator before any glob pattern
  local base_path = pattern:match("^([^*]+)/")
  local name_pattern = pattern:sub(#base_path + 1)
  return base_path, name_pattern
end

-- Convert glob pattern to regular expression pattern
local function glob_to_pattern(pattern)
  -- First escape special characters
  local p = pattern:gsub('([%-%.%+%[%]%(%)%$%^%%%?])', '%%%1')
  
  -- Now substitute glob patterns
  p = p:gsub('%*%*/%*', '(.+)')  -- **/* -> capture the whole path
  p = p:gsub('%*%*', '(.+)')     -- ** -> capture anything
  p = p:gsub('%*', '([^/]+)')    -- * -> capture non-slash chars
  
  return '^' .. p .. '$'
end

-- Helper function to find matching file using patterns
function M.try_patterns(current_file, patterns)
  for _, pattern_pair in ipairs(patterns) do
    local source, alternate = pattern_pair[1], pattern_pair[2]
    
    -- Try source -> alternate
    local matches = {current_file:match(glob_to_pattern(source))}
    if #matches > 0 then
      local result = alternate
      -- Replace captured parts
      for i, match in ipairs(matches) do
        if alternate:match('/%*%*/%*') then
          result = result:gsub('/%*%*/%*', '/' .. match, 1)
        elseif alternate:match('%*%*') then
          result = result:gsub('%*%*', match, 1)
        else
          result = result:gsub('%*', match, 1)
        end
      end
      return result  -- Return regardless of file existence
    end
    
    -- Try alternate -> source
    matches = {current_file:match(glob_to_pattern(alternate))}
    if #matches > 0 then
      local result = source
      -- Replace captured parts
      for i, match in ipairs(matches) do
        if source:match('/%*%*/%*') then
          result = result:gsub('/%*%*/%*', '/' .. match, 1)
        elseif source:match('%*%*') then
          result = result:gsub('%*%*', match, 1)
        else
          result = result:gsub('%*', match, 1)
        end
      end
      return result  -- Return regardless of file existence
    end
  end
  
  return nil
end

return M

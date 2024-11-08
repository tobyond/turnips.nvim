local mock_fs = {
  -- Models and their specs
  ["app/models/user.rb"] = true,
  ["spec/models/user_spec.rb"] = true,
  ["app/models/account/profile.rb"] = true,
  ["spec/models/account/profile_spec.rb"] = true,
  ["app/models/deep/nested/item.rb"] = true,
  ["spec/models/deep/nested/item_spec.rb"] = true,

  -- Controllers and their specs
  ["app/controllers/users_controller.rb"] = true,
  ["spec/requests/users_spec.rb"] = true,
  ["spec/requests/users_request_spec.rb"] = true,
  ["app/controllers/api/v1/posts_controller.rb"] = true,
  ["spec/requests/api/v1/posts_spec.rb"] = true,
  ["app/controllers/admin/settings_controller.rb"] = true,
  ["spec/requests/admin/settings_request_spec.rb"] = true,

  -- Components and their templates
  ["app/components/header_component.rb"] = true,
  ["app/components/header_component.html.erb"] = true,
  ["app/components/forms/input_component.rb"] = true,
  ["app/components/forms/input_component.html.erb"] = true,
  ["app/components/layout/navigation/menu_component.rb"] = true,
  ["app/components/layout/navigation/menu_component.html.erb"] = true,

  -- Services and their specs
  ["app/services/payment_processor.rb"] = true,
  ["spec/services/payment_processor_spec.rb"] = true
}

-- Mock vim.fn.filereadable
_G.vim = _G.vim or {}
_G.vim.fn = _G.vim.fn or {}
_G.vim.fn.filereadable = function(path)
  return mock_fs[path] and 1 or 0
end

-- Mock vim.fn.fnamemodify to return the path as-is
_G.vim.fn.fnamemodify = function(path, modifier)
  return path
end

describe("turnips.nvim", function()
  local turnips

  before_each(function()
    package.loaded['turnips'] = nil
    package.loaded['turnips.init'] = nil
    package.loaded['turnips.utils'] = nil
    
    turnips = require("turnips")
    
    turnips.setup({
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
  end)

  describe("model patterns", function()
    it("should find model spec", function()
      local result = turnips.find_alternate_file("app/models/user.rb", turnips.config.test)
      assert.equals("spec/models/user_spec.rb", result)
    end)

    it("should find model from spec", function()
      local result = turnips.find_alternate_file("spec/models/user_spec.rb", turnips.config.test)
      assert.equals("app/models/user.rb", result)
    end)

    it("should find nested model spec", function()
      local result = turnips.find_alternate_file("app/models/account/profile.rb", turnips.config.test)
      assert.equals("spec/models/account/profile_spec.rb", result)
    end)

    it("should find nested model from spec", function()
      local result = turnips.find_alternate_file("spec/models/account/profile_spec.rb", turnips.config.test)
      assert.equals("app/models/account/profile.rb", result)
    end)

    it("should find deeply nested model spec", function()
      local result = turnips.find_alternate_file("app/models/deep/nested/item.rb", turnips.config.test)
      assert.equals("spec/models/deep/nested/item_spec.rb", result)
    end)
  end)

  describe("controller patterns", function()
    it("should find controller spec", function()
      local result = turnips.find_alternate_file("app/controllers/users_controller.rb", turnips.config.test)
      assert.equals("spec/requests/users_spec.rb", result)
    end)

    it("should find controller from spec", function()
      local result = turnips.find_alternate_file("spec/requests/users_spec.rb", turnips.config.test)
      assert.equals("app/controllers/users_controller.rb", result)
    end)

    it("should find nested controller spec", function()
      local result = turnips.find_alternate_file("app/controllers/api/v1/posts_controller.rb", turnips.config.test)
      assert.equals("spec/requests/api/v1/posts_spec.rb", result)
    end)

    it("should find nested controller from spec", function()
      local result = turnips.find_alternate_file("spec/requests/api/v1/posts_spec.rb", turnips.config.test)
      assert.equals("app/controllers/api/v1/posts_controller.rb", result)
    end)

    it("should find controller with request spec suffix", function()
      local result = turnips.find_alternate_file("app/controllers/admin/settings_controller.rb", turnips.config.test)
      assert.equals("spec/requests/admin/settings_request_spec.rb", result)
    end)

    it("should find controller from request spec suffix", function()
      local result = turnips.find_alternate_file("spec/requests/admin/settings_request_spec.rb", turnips.config.test)
      assert.equals("app/controllers/admin/settings_controller.rb", result)
    end)
  end)

  describe("component patterns", function()
    it("should find component template", function()
      local result = turnips.find_alternate_file("app/components/header_component.rb", turnips.config.related)
      assert.equals("app/components/header_component.html.erb", result)
    end)

    it("should find component from template", function()
      local result = turnips.find_alternate_file("app/components/header_component.html.erb", turnips.config.related)
      assert.equals("app/components/header_component.rb", result)
    end)

    it("should find nested component template", function()
      local result = turnips.find_alternate_file("app/components/forms/input_component.rb", turnips.config.related)
      assert.equals("app/components/forms/input_component.html.erb", result)
    end)

    it("should find nested component from template", function()
      local result = turnips.find_alternate_file("app/components/forms/input_component.html.erb", turnips.config.related)
      assert.equals("app/components/forms/input_component.rb", result)
    end)

    it("should find deeply nested component template", function()
      local result = turnips.find_alternate_file(
        "app/components/layout/navigation/menu_component.rb",
        turnips.config.related
      )
      assert.equals("app/components/layout/navigation/menu_component.html.erb", result)
    end)

    it("should find deeply nested component from template", function()
      local result = turnips.find_alternate_file(
        "app/components/layout/navigation/menu_component.html.erb",
        turnips.config.related
      )
      assert.equals("app/components/layout/navigation/menu_component.rb", result)
    end)
  end)

  describe("edge cases", function()
    it("should handle non-existent files", function()
      local result = turnips.find_alternate_file("app/models/nonexistent.rb", turnips.config.test)
      assert.is_nil(result)
    end)

    it("should handle files without matches", function()
      local result = turnips.find_alternate_file("app/something/else.rb", turnips.config.test)
      assert.is_nil(result)
    end)

    it("should handle empty string input", function()
      local result = turnips.find_alternate_file("", turnips.config.test)
      assert.is_nil(result)
    end)
  end)
end)

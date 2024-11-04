local compat = {}

local function setup_impersonate()
  if package.loaded.lazy then
    local LazyConfig = require('lazy.core.config')

    LazyConfig.plugins['nvim-cmp'] = LazyConfig.plugins['blink.compat']

    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('blink-compat', { clear = true }),
      pattern = 'LazyDone',
      once = true,
      callback = function()
        package.loaded['nvim-cmp'] = package.loaded['blink.compat']
        vim.schedule(
          function() vim.api.nvim_exec_autocmds('User', { pattern = 'LazyLoad', modeline = false, data = 'nvim-cmp' }) end
        )
      end,
    })
  end
end

local function setup_events()
  -- TODO: implement complete_done, menu_open, menu_closed

  local original_accept = require('blink.cmp.accept')
  local function new_accept(item)
    original_accept(item)
    if item._source then
      require('blink.compat.event'):emit('confirm_done', { entry = { completion_item = item, source = item._source } })
    end
  end
  package.loaded['blink.cmp.accept'] = new_accept
end

--- @param opts blink.compat.Config
function compat.setup(opts)
  local config = require('blink.compat.config')
  config.merge_with(opts)

  if config.impersonate_nvim_cmp then setup_impersonate() end

  if config.enable_events then setup_events() end
end

return compat

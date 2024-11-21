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
  local event = require('blink.compat.event')

  local function make_entry(item)
    -- NOTE: only events emmited by blink.compat sources will have a `source`
    return {
      entry = {
        completion_item = item,
        source = item._source or {},
        get_commit_characters = function() return {} end,
        get_completion_item = function() return item end,
      },
    }
  end

  local original_accept = require('blink.cmp.accept')
  local function new_accept(ctx, item)
    original_accept(ctx, item)
    event:emit('confirm_done', make_entry(item))
  end
  package.loaded['blink.cmp.accept'] = new_accept

  -- this has to run after blink.cmp setup, because windows is set then
  -- local autocomplete = require('blink.cmp').windows.autocomplete
  --
  -- autocomplete.listen_on_open(function() event:emit('menu_opened', { window = {} }) end)
  -- autocomplete.listen_on_close(function()
  --   local item = autocomplete:get_selected_item()
  --   if item then event:emit('complete_done', make_entry(item)) end
  --   event:emit('menu_closed', { window = {} })
  -- end)
end

--- @param opts blink.compat.Config
function compat.setup(opts)
  local config = require('blink.compat.config')
  config.merge_with(opts)

  if config.impersonate_nvim_cmp then setup_impersonate() end

  if config.enable_events then setup_events() end
end

return compat

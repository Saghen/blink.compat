local compat = {}

local function setup_events()
  local compat_event = require('blink.compat.event')
  local registry = require('blink.compat.registry')

  local function make_entry(item)
    -- NOTE: only events emmited by blink.compat sources will have a `source`

    return {
      entry = {
        completion_item = item,
        source = item and item.source_name and registry.get_source(item.source_name) or {},
        get_commit_characters = function() return {} end,
        get_completion_item = function() return item end,
      },
    }
  end

  vim.api.nvim_create_autocmd('User', {
    group = compat.augroup,
    pattern = 'BlinkCmpAccept',
    callback = function(ev) compat_event:emit('confirm_done', make_entry(ev.data.item)) end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = compat.augroup,
    pattern = 'BlinkCmpShow',
    callback = function() compat_event:emit('menu_opened', { window = {} }) end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = compat.augroup,
    pattern = 'BlinkCmpHide',
    callback = function()
      local list = require('blink.cmp.completion.list')
      local selected_item = list.selected_item_idx and list.get_selected_item()
      compat_event:emit('complete_done', make_entry(selected_item))
      compat_event:emit('menu_closed', { window = {} })
    end,
  })
end

--- @param opts blink.compat.Config
function compat.setup(opts)
  local config = require('blink.compat.config')
  config.merge_with(opts)

  compat.augroup = vim.api.nvim_create_augroup('blink.compat', { clear = true })

  setup_events()
end

return compat

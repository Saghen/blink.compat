local core = {}

core.view = {}
function core.view.visible() return require('blink.cmp.completion.windows.menu').win:is_open() end

core.event = require('blink.compat.event')

core.filter = core.filter or {
  sync = function(_, timeout_)
    vim.wait(timeout_ or 1000, function() end, 10)
  end,
}

return core

local core = {}

core.view = {}
function core.view.visible() return require('blink.cmp.completion.windows.menu').win:is_open() end

core.event = require('blink.compat.event')

return core

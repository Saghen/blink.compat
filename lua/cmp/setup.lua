local setup = {}

local function dprint(f)
  if require('blink.compat.config').debug then
    vim.notify_once(
      'blink.compat functinon `cmp.setup.' .. f .. '` has been called but is not implemented',
      vim.log.levels.WARN
    )
  end
end

function setup.global() dprint('global') end
function setup.filetype() dprint('filetype') end
function setup.buffer() dprint('buffer') end
function setup.cmdline() dprint('cmdline') end

return setup

local cmp = {
  core = require('cmp.core'),
  types = require('cmp.types'),
  lsp = require('cmp.types.lsp'),
}

function cmp.register_source(name, s)
  require('blink.compat.registry').register_source(name, s)
  -- use name as id
  return name
end

function cmp.unregister_source(id) require('blink.compat.registry').unregister_source(id) end

return cmp

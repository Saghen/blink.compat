local cmp = {}

cmp.core = require('cmp.core')

---Expose types
for k, v in pairs(require('cmp.types.cmp')) do
  cmp[k] = v
end
cmp.lsp = require('cmp.types.lsp')

---Expose Event
cmp.event = cmp.core.event

---Expose setup
cmp.setup = require('cmp.setup')

function cmp.register_source(name, s)
  require('blink.compat.registry').register_source(name, s)
  -- use name as id
  return name
end

function cmp.unregister_source(id) require('blink.compat.registry').unregister_source(id) end

return cmp

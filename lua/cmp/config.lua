local config = {}

function config.enabled()
  local c = require('blink.cmp.config')
  return c.enabled()
end

function config.get_source_config(name)
  local c = require('blink.cmp.config')
  for _, s in pairs(c.sources.providers) do
    if s.name == name then
      s = vim.deepcopy(s)
      ---@diagnostic disable-next-line: inject-field
      s.option = s.opts
      return s
    end
  end
  return nil
end

return config

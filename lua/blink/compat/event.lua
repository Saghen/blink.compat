local event = {}

function event:on(name, callback)
  if not self.events[name] then self.events[name] = {} end
  table.insert(self.events[name], callback)
  return function() self:off(name, callback) end
end

function event:off(name, callback)
  for i, callback_ in ipairs(self.events[name] or {}) do
    if callback_ == callback then
      table.remove(self.events[name], i)
      break
    end
  end
end

function event:clear() self.events = {} end

function event:emit(name, ...)
  for _, callback in ipairs(self.events[name] or {}) do
    callback(...)
  end
end

return setmetatable({ events = {} }, { __index = event })

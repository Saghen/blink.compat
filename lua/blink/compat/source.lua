local registry = require('blink.compat.registry')
local context = require('blink.compat.lib.context')

--- @module 'blink.cmp'

--- @param config blink.cmp.SourceProviderConfig
--- @param ctx blink.cmp.Context
--- @param keyword_pattern? string
local function make_params(config, ctx, keyword_pattern)
  local cmp_ctx = context.new(ctx)

  local params = {
    offset = keyword_pattern and cmp_ctx:get_offset(keyword_pattern) or cmp_ctx.cursor.col,
    context = cmp_ctx,
    completion_context = {
      triggerCharacter = ctx.trigger.character,
      triggerKind = ctx.trigger.kind,
    },
    name = config.name,
    option = config.opts or {},
    priority = 0,
    trigger_characters = {},
    keyword_pattern = nil,
    -- we don't have enabled_sources or items, so we can't call these if they're functions - just use nil instead
    keyword_length = type(config.min_keyword_length) == 'number' and config.min_keyword_length or nil,
    max_item_count = type(config.max_items) == 'number' and config.max_items or nil,
    group_index = nil,
    entry_filter = nil,
  }

  return params
end

local source = {}

function source.new(_, config)
  local self = setmetatable({}, { __index = source })
  self.config = config

  return self
end

function source:enabled()
  local s = registry.get_source(self.config.name)
  if s == nil then
    return false
  elseif s.is_available == nil then
    return true
  end
  return s:is_available()
end

function source:get_completions(ctx, callback)
  local s = registry.get_source(self.config.name)
  if s == nil or s.complete == nil then return callback() end

  local function transformed_callback(candidates)
    if candidates == nil then
      callback()
      return
    end

    callback({
      context = ctx,
      is_incomplete_forward = candidates.isIncomplete or false,
      is_incomplete_backward = true,
      items = candidates.items or candidates,
    })
  end

  local params = make_params(self.config, ctx, self:get_keyword_pattern())
  local ok, _ = pcall(function() s:complete(params, transformed_callback) end)
  if not ok then
    vim.notify(
      'blink.compat completion source "' .. self.config.name .. '" failed to provide completions',
      vim.log.levels.WARN
    )
    callback()
  end
end

function source:resolve(item, callback)
  local s = registry.get_source(self.config.name)
  if s == nil or s.resolve == nil then return callback(item) end

  local ok, _ = pcall(function() s:resolve(item, callback) end)
  if not ok then
    vim.notify('blink.compat completion source "' .. self.config.name .. '" failed to resolve', vim.log.levels.WARN)
    callback(item)
  end
end

function source:get_trigger_characters()
  local s = registry.get_source(self.config.name)
  if s == nil or s.get_trigger_characters == nil then return {} end
  return s:get_trigger_characters()
end

function source:get_keyword_pattern()
  local s = registry.get_source(self.config.name)
  if s == nil or s.get_keyword_pattern == nil then return nil end
  return s:get_keyword_pattern()
end

return source

local registry = require('blink.compat.registry')
local context = require('blink.compat.context')

--- @module 'blink.cmp'

--- @param config blink.cmp.SourceProviderConfig
--- @param ctx blink.cmp.Context
local function make_params(config, ctx)
  local params = {
    -- NOTE: `offset` does not consider keyword pattern as in `nvim-cmp` (because there is none)
    offset = ctx.cursor[2] + 1,
    context = context.new(ctx),
    completion_context = {
      triggerCharacter = ctx.trigger.character,
      triggerKind = ctx.trigger.kind,
    },
    name = config.name,
    option = config.opts,
    priority = 0,
    trigger_characters = {},
    keyword_pattern = nil,
    keyword_length = nil,
    max_item_count = config.max_items,
    group_index = nil,
    entry_filter = nil,
  }

  return params
end

local nvim_cmp = {}

function nvim_cmp:enabled()
  local source = registry.get_source(self.config.name)
  if source == nil or source.is_available == nil then return true end
  return source:is_available()
end

function nvim_cmp.new(_, config)
  local self = setmetatable({}, { __index = nvim_cmp })
  self.config = config

  return self
end

function nvim_cmp:get_completions(ctx, callback)
  local source = registry.get_source(self.config.name)
  if source == nil or source.complete == nil then return callback() end

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

  local params = make_params(self.config, ctx)
  source:complete(params, transformed_callback)

  return function() end
end

function nvim_cmp:get_trigger_characters()
  local source = registry.get_source(self.config.name)
  if source == nil or source.get_trigger_characters == nil then return {} end
  return source:get_trigger_characters()
end

function nvim_cmp:should_show_completions()
  local source = registry.get_source(self.config.name)
  if source == nil or source.is_available == nil then return true end
  return source:is_available()
end

return nvim_cmp

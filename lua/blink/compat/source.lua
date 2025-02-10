local registry = require('blink.compat.registry')
local context = require('blink.compat.lib.context')
local pattern = require('blink.compat.lib.pattern')
local utils = require('blink.compat.lib.utils')

local CompletionTriggerKind = vim.lsp.protocol.CompletionTriggerKind

local source = {}

function source.new(_, config)
  local self = setmetatable({}, { __index = source })
  self.config = config
  self.cmp_name = (self.config.opts and self.config.opts.cmp_name) or self.config.name

  return self
end

function source:_get_source()
  self._source = registry.get_source(self.cmp_name)
  if self._source == nil and require('blink.compat.config').debug then
    vim.notify_once(
      'blink.compat completion source "'
        .. self.cmp_name
        .. '" has not registered itself.\n Please try enabling `impersonate_nvim_cmp` in blink.compat `opts`',
      vim.log.levels.WARN
    )
  end
  return self._source
end

function source:enabled()
  local s = self:_get_source()
  if s == nil then
    return false
  elseif s.is_available == nil then
    return true
  end
  return s:is_available()
end

function source:get_completions(ctx, callback)
  local s = self:_get_source()
  if s == nil or s.complete == nil then return callback() end

  local keyword_pattern
  if s.get_keyword_pattern then keyword_pattern = s:get_keyword_pattern() end

  local cmp_ctx = context.new(ctx)

  local keyword_start, keyword_end
  if keyword_pattern then
    keyword_start, keyword_end = pattern.offset([[\%(]] .. keyword_pattern .. [[\)\m$]], cmp_ctx.cursor_before_line)
  end

  local params = {
    offset = keyword_start or cmp_ctx.cursor.col,
    context = cmp_ctx,
    completion_context = {
      triggerCharacter = ctx.trigger.character,
      triggerKind = ctx.trigger.kind == 'trigger_character' and CompletionTriggerKind.TriggerCharacter
        or CompletionTriggerKind.Invoked,
    },
    name = self.source_name,
    option = self.config.opts or {},
    priority = 0,
    trigger_characters = {},
    keyword_pattern = nil,
    -- we don't have enabled_sources or items, so we can't call these if they're functions - just use nil instead
    keyword_length = type(self.config.min_keyword_length) == 'number' and self.config.min_keyword_length or nil,
    max_item_count = type(self.config.max_items) == 'number' and self.config.max_items or nil,
    group_index = nil,
    entry_filter = nil,
  }

  local function transformed_callback(candidates)
    if candidates == nil then
      callback()
      return
    end

    local items = candidates.items or candidates

    items = vim.tbl_map(function(item)
      -- some sources reuse items, so copy to avoid mutating them
      item = utils.shallow_copy(item)

      -- HACK: some sources return invalud documentation, with only one of kind or value set
      -- remove documentation in those cases
      if item.documentation and type(item.documentation) ~= 'string' then
        if item.documentation.kind == nil or item.documentation.value == nil then item.documentation = nil end
      end

      return item
    end, items)

    if keyword_start then
      local range = {
        start = { line = cmp_ctx.cursor.line, character = keyword_start - 1 },
        ['end'] = { line = cmp_ctx.cursor.line, character = keyword_end - 1 },
      }

      items = vim.tbl_map(function(item)
        if type(item) ~= 'table' or item.textEdit or item.textEditText then return item end

        local word = item.insertText or item.label

        item.insertText = nil
        item.textEdit = {
          range = range,
          newText = word,
        }

        return item
      end, items)
    end

    callback({
      context = ctx,
      is_incomplete_forward = candidates.isIncomplete or false,
      is_incomplete_backward = true,
      items = items,
    })
  end

  s:complete(params, transformed_callback)
end

function source:resolve(item, callback)
  local s = self:_get_source()
  if s == nil or s.resolve == nil then return callback(item) end

  s:resolve(item, callback)
end

function source:execute(_, item, callback)
  local s = self:_get_source()
  if s == nil or s.execute == nil then return callback() end

  s:execute(item, callback)
end

function source:get_trigger_characters()
  local s = self:_get_source()
  if s == nil or s.get_trigger_characters == nil then return {} end
  return s:get_trigger_characters()
end

return source

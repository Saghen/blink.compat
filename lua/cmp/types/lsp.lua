-- taken from nvim-cmp at
-- https://github.com/hrsh7th/nvim-cmp/blob/ca4d3330d386e76967e53b85953c170658255ecb/lua/cmp/types/lsp.lua

local utils = require('blink.compat.lib.utils')

local lsp = {}

lsp.PositionEncodingKind = {
  UTF8 = 'utf-8',
  UTF16 = 'utf-16',
  UTF32 = 'utf-32',
}

lsp.Position = {
  to_vim = function(buf, position)
    if not vim.api.nvim_buf_is_loaded(buf) then vim.fn.bufload(buf) end
    local lines = vim.api.nvim_buf_get_lines(buf, position.line, position.line + 1, false)
    if #lines > 0 then
      return {
        row = position.line + 1,
        col = utils.to_vimindex(lines[1], position.character),
      }
    end
    return {
      row = position.line + 1,
      col = position.character + 1,
    }
  end,
  to_lsp = function(buf, position)
    if not vim.api.nvim_buf_is_loaded(buf) then vim.fn.bufload(buf) end
    local lines = vim.api.nvim_buf_get_lines(buf, position.row - 1, position.row, false)
    if #lines > 0 then
      return {
        line = position.row - 1,
        character = utils.to_utfindex(lines[1], position.col),
      }
    end
    return {
      line = position.row - 1,
      character = position.col - 1,
    }
  end,
  to_utf8 = function(text, position, from_encoding)
    from_encoding = from_encoding or lsp.PositionEncodingKind.UTF16
    if from_encoding == lsp.PositionEncodingKind.UTF8 then return position end

    local ok, byteindex =
      pcall(vim.str_byteindex, text, position.character, from_encoding == lsp.PositionEncodingKind.UTF16)
    if not ok then return position end
    return { line = position.line, character = byteindex }
  end,
  to_utf16 = function(text, position, from_encoding)
    from_encoding = from_encoding or lsp.PositionEncodingKind.UTF16
    if from_encoding == lsp.PositionEncodingKind.UTF16 then return position end

    local utf8 = lsp.Position.to_utf8(text, position, from_encoding)
    for index = utf8.character, 0, -1 do
      local ok, utf16index = pcall(function() return select(2, vim.str_utfindex(text, index)) end)
      if ok then return { line = utf8.line, character = utf16index } end
    end
    return position
  end,

  to_utf32 = function(text, position, from_encoding)
    from_encoding = from_encoding or lsp.PositionEncodingKind.UTF16
    if from_encoding == lsp.PositionEncodingKind.UTF32 then return position end

    local utf8 = lsp.Position.to_utf8(text, position, from_encoding)
    for index = utf8.character, 0, -1 do
      local ok, utf32index = pcall(function() return select(1, vim.str_utfindex(text, index)) end)
      if ok then return { line = utf8.line, character = utf32index } end
    end
    return position
  end,
}

lsp.Range = {
  to_vim = function(buf, range)
    return {
      start = lsp.Position.to_vim(buf, range.start),
      ['end'] = lsp.Position.to_vim(buf, range['end']),
    }
  end,
  to_lsp = function(buf, range)
    return {
      start = lsp.Position.to_lsp(buf, range.start),
      ['end'] = lsp.Position.to_lsp(buf, range['end']),
    }
  end,
}

lsp.CompletionTriggerKind = {
  Invoked = 1,
  TriggerCharacter = 2,
  TriggerForIncompleteCompletions = 3,
}

lsp.InsertTextFormat = {}
lsp.InsertTextFormat.PlainText = 1
lsp.InsertTextFormat.Snippet = 2

lsp.InsertTextMode = {
  AsIs = 1,
  AdjustIndentation = 2,
}

lsp.MarkupKind = {
  PlainText = 'plaintext',
  Markdown = 'markdown',
}

lsp.CompletionItemTag = {
  Deprecated = 1,
}

lsp.CompletionItemKind = {
  Text = 1,
  Method = 2,
  Function = 3,
  Constructor = 4,
  Field = 5,
  Variable = 6,
  Class = 7,
  Interface = 8,
  Module = 9,
  Property = 10,
  Unit = 11,
  Value = 12,
  Enum = 13,
  Keyword = 14,
  Snippet = 15,
  Color = 16,
  File = 17,
  Reference = 18,
  Folder = 19,
  EnumMember = 20,
  Constant = 21,
  Struct = 22,
  Event = 23,
  Operator = 24,
  TypeParameter = 25,
}

for k, v in pairs(lsp.CompletionItemKind) do
  lsp.CompletionItemKind[v] = k
end

return lsp

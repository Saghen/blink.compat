local utils = require('blink.compat.lib.utils')

local lsp = {}

lsp.PositionEncodingKind = {
  UTF8 = 'utf-8',
  UTF16 = 'utf-16',
  UTF32 = 'utf-32',
}

lsp.CompletionTriggerKind = utils.shallow_copy(vim.lsp.protocol.CompletionTriggerKind)
lsp.InsertTextFormat = utils.shallow_copy(vim.lsp.protocol.InsertTextFormat)

lsp.InsertTextMode = {
  AsIs = 1,
  AdjustIndentation = 2,
}

lsp.MarkupKind = utils.shallow_copy(vim.lsp.protocol.MarkupKind)
lsp.CompletionItemTag = utils.shallow_copy(vim.lsp.protocol.CompletionTag)
lsp.CompletionItemKind = utils.shallow_copy(vim.lsp.protocol.CompletionItemKind)
for k, v in pairs(lsp.CompletionItemKind) do
  lsp.CompletionItemKind[v] = k
end

return lsp

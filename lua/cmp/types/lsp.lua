local lsp = {}

lsp.PositionEncodingKind = {
  UTF8 = 'utf-8',
  UTF16 = 'utf-16',
  UTF32 = 'utf-32',
}

lsp.CompletionTriggerKind = vim.lsp.protocol.CompletionTriggerKind
lsp.InsertTextFormat = vim.lsp.protocol.InsertTextFormat

lsp.InsertTextMode = {
  AsIs = 1,
  AdjustIndentation = 2,
}

lsp.MarkupKind = vim.lsp.protocol.MarkupKind
lsp.CompletionItemTag = vim.lsp.protocol.CompletionTag
lsp.CompletionItemKind = require('blink.cmp.types').CompletionItemKind

return lsp

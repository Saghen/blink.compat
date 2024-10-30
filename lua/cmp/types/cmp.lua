local cmp = {}

cmp.ContextReason = {
  Auto = 'auto',
  Manual = 'manual',
  TriggerOnly = 'triggerOnly',
  None = 'none',
}

cmp.TriggerEvent = {
  InsertEnter = 'InsertEnter',
  TextChanged = 'TextChanged',
}

cmp.ItemField = {
  Abbr = 'abbr',
  Kind = 'kind',
  Menu = 'menu',
}

return cmp

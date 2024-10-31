--- @class blink.compat.Config
--- @field impersonate_nvim_cmp? boolean

--- @type blink.compat.Config
local config = {
  -- when true, will pretend to be nvim-cmp
  -- this is required when the completion provider registers the completion source only when nvim-cmp is loaded
  -- only has effect when loaded using lazy.nvim
  impersonate_nvim_cmp = false,
}

local M = {}

--- @param opts blink.compat.Config
function M.merge_with(opts) config = vim.tbl_deep_extend('force', config, opts or {}) end

return setmetatable(M, { __index = function(_, k) return config[k] end })

--- @class blink.compat.Config
--- @field impersonate_nvim_cmp? boolean

--- @type blink.compat.Config
local config = {
  -- some plugins lazily register their completion source when nvim-cmp is
  -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
  -- most plugins don't do this, so this option should rarely be needed
  -- NOTE: only has effect when using lazy.nvim plugin manager
  impersonate_nvim_cmp = false,
}

local M = {}

--- @param opts blink.compat.Config
function M.merge_with(opts) config = vim.tbl_deep_extend('force', config, opts or {}) end

return setmetatable(M, { __index = function(_, k) return config[k] end })

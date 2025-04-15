--- @class blink.compat.Config
--- @field impersonate_nvim_cmp? boolean
--- @field debug? boolean

--- @type blink.compat.Config
local config = {
  -- print some debug information. Might be useful for troubleshooting
  debug = false,
}

local M = {}

--- @param opts blink.compat.Config
function M.merge_with(opts) config = vim.tbl_deep_extend('force', config, opts or {}) end

return setmetatable(M, { __index = function(_, k) return config[k] end })

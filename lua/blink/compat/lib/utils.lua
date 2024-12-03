local utils = {}

--- Shallow copy table
--- @generic T
--- @param t T
--- @return T
function utils.shallow_copy(t)
  local t2 = {}
  for k, v in pairs(t) do
    t2[k] = v
  end
  return t2
end

---Safe version of vim.str_byteindex
---taken from nvim-cmp
---@param text string
---@param utfindex integer
---@return integer
function utils.to_vimindex(text, utfindex)
  utfindex = utfindex or #text
  for i = utfindex, 1, -1 do
    local s, v = pcall(function() return vim.str_byteindex(text, i) + 1 end)
    if s then return v end
  end
  return utfindex + 1
end

---Safe version of vim.str_utfindex
---taken from nvim-cmp
---@param text string
---@param vimindex integer|nil
---@return integer
function utils.to_utfindex(text, vimindex)
  vimindex = vimindex or #text + 1
  return vim.str_utfindex(text, math.max(0, math.min(vimindex - 1, #text)))
end

return utils

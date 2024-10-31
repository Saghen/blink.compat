local compat = {}

--- @param opts blink.compat.Config
function compat.setup(opts)
  local config = require('blink.compat.config')
  config.merge_with(opts)

  if config.impersonate_nvim_cmp and package.loaded.lazy then
    local LazyConfig = require('lazy.core.config')

    LazyConfig.plugins['nvim-cmp'] = LazyConfig.plugins['blink.compat']

    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('blink-compat', { clear = true }),
      pattern = 'LazyDone',
      once = true,
      callback = function()
        package.loaded['nvim-cmp'] = package.loaded['blink.compat']
        vim.schedule(
          function() vim.api.nvim_exec_autocmds('User', { pattern = 'LazyLoad', modeline = false, data = 'nvim-cmp' }) end
        )
      end,
    })
  end
end

return compat

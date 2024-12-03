# Blink Compat (blink.compat)

**blink.compat** is a source provider for [blink.cmp](https://github.com/Saghen/blink.cmp)
that allow you to use [nvim-cmp](https://github.com/hrsh7th/nvim-cmp.git)
completion sources.

`blink.compat` will work for most `nvim-cmp` completion sources, but note that
there might be differences between using the source on `nvim-cmp` and on
`blink.cmp` through `blink.compat`, especially with regards to triggering
(due to `blink.cmp`'s lack of keyword patterns).

Developed by [@stefanboca](https://github.com/stefanboca)

## Note

Don't use `nvim-cmp` buffer, snippets, path, or lsp completion sources with
this `blink.compat`! While they might work, `blink.cmp` has native equivalents. Use
those instead!

## Usage

For each `nvim-cmp` source you want to use, add a provider with
`module = 'blink.compat.source'` and the same `name` that `nvim-cmp` uses.

Here's a minimal example adding the
[cmp-digraphs](https://github.com/dmitmel/cmp-digraphs) source provider in `lazy.nvim`

```lua
return {
  -- add blink.compat
  {
    'saghen/blink.compat',
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = '*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },

  {
    'saghen/blink.cmp',
    version = '0.*',
    dependencies = {
      -- add source
      { 'dmitmel/cmp-digraphs' },
    },
    sources = {
      completion = {
        -- remember to enable your providers here
        enabled_providers = { 'lsp', 'path', 'snippets', 'buffer', 'digraphs' },
      },

      providers = {
        -- create provider
        digraphs = {
          name = 'digraphs', -- IMPORTANT: use the same name as you would for nvim-cmp
          module = 'blink.compat.source',

          -- all blink.cmp source config options work as normal:
          score_offset = -3,

          -- this table is passed directly to the proxied completion source
          -- as the `option` field in nvim-cmp's source config
          --
          -- this is NOT the same as the opts in a plugin's lazy.nvim spec
          opts = {
            -- this is an option from cmp-digraphs
            cache_digraphs_on_start = true,
          },
        },
      },
    },
  },
}
```

## Options

A complete list of all configuration options and their defaults

```lua
opts = {
  -- some plugins lazily register their completion source when nvim-cmp is
  -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
  -- most plugins don't do this, so this option should rarely be needed
  -- NOTE: only has effect when using lazy.nvim plugin manager
  impersonate_nvim_cmp = false,

  -- print some debug information. Might be useful for troubleshooting
  debug = false,
}
```

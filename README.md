# Blink Compat (blink.compat)

**blink.compat** is a source provider for [blink.cmp](https://github.com/Saghen/blink.cmp)
that allow you to use [nvim-cmp](https://github.com/hrsh7th/nvim-cmp.git)
completion sources.

`blink.compat` will work for most `nvim-cmp` completion sources, but note that
there might be differences between using the source on `nvim-cmp` and on
`blink.cmp` through `blink.compat`, especially with regards to triggering
(due to `blink.cmp`'s lack of keyword patterns).

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
{
  'saghen/blink.cmp',
  dependencies = {
    -- add blink.compat to dependencies
    { 'saghen/blink.compat' },
    -- add source to dependencies
    { "dmitmel/cmp-digraphs", lazy = true },
  },
  sources = {
    completion = {
      -- remember to enable your providers here
      enabled_providers = {'lsp', 'path', 'snippets', 'buffer', 'digraphs'}
    },

    providers = {
      digraphs = {
        name = 'digraphs', -- IMPORTANT: use the same name as you would for nvim-cmp
        module = 'blink.compat.source',

        -- all blink.cmp source config options work as normal:
        score_offset = -3,

        opts = {
          -- options passed to the completion source
          -- equivalent to `option` field of nvim-cmp source config

          cache_digraphs_on_start = true,
        }
      }
    }
  }
},
```

## Options

A complete list of all configuration options and their defaults

```lua
opts = {
  -- some plugins might only register their completion source when nvim-cmp is
  -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
  -- only has effect when using lazy.nvim
  -- this should rarely be needed
  impersonate_nvim_cmp = false,
}
```

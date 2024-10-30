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
[lazydev.nvim](https://github.com/folke/lazydev.nvim) source provider in `lazy.nvim`

```lua
{
  'saghen/blink.cmp',
  dependencies = {
    -- add blink.compat to dependencies
    'saghen/blink.compat',
  },
  sources = {
    completion = {
      -- remember to enable your providers here
      enabled_providers = {'lsp', 'path', 'snippets', 'buffer', 'lazydev'}
    },

    providers = {
      lazydev = {
        name = 'lazydev', -- IMPORTANT: use the same name as you would for nvim-cmp
        module = 'blink.compat.source',

        -- all blink.cmp source config options work as normal:
        score_offset = 3,

        opts = {
          -- options for the completion source
          -- equivalent to `option` field of nvim-cmp source config
        }
      }
    }
  }
},
```

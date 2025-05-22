local ft = "lua"

---
--- === LSP ===
---

CFG.lsp.ft:add(ft)

local lsp = "lua_ls"

CFG.lsp.servers[lsp] = {
    settings = {
        Lua = {},
    },
}

---
--- === CMP ===
---

local url = "folke/lazydev.nvim"
local lazydev = CFG.spec:add(url)
lazydev.ft = { ft }
lazydev.opts.integrations = {
    lspconfig = true,
}
CFG.cmp:ft(ft)
CFG.cmp.sources[ft] = {
    inherit_defaults = true,
    "lazydev",
}
CFG.cmp.providers["lazydev"] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
    enabled = true,
    async = true,
    should_show_items = true,
    fallbacks = {
        "lsp",
    },
}

---
--- === Format ===
---
local formatter = "lua-format"
CFG.format:add(
    ft, formatter, {
        mason = "luaformatter",
    }
)

---
--- === Lint ===
---
local linter = "selene"
CFG.lint:add(ft, linter)

---
--- === Integrations ===
---
CFG.rainbow_delimiter.query["lua"] = "rainbow-blocks"
CFG.rainbow_delimiter.priority["lua"] = 210
CFG.commentstring.lua = {
    __default = "--- %s",
    __multiline = "---[[ %s ]]",
}

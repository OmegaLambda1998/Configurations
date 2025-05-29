local ft = "lua"

---
--- === LSP ===
---

CFG.lsp:ft(ft)

local lsp = "lua_ls"
table.insert(CFG.mason.ensure_installed.lsp, lsp)

CFG.lsp.servers[lsp] = {}

---
--- === CMP ===
---

local url = "folke/lazydev.nvim"
local lazydev = CFG.spec:add(url)
---@module "lazydev"

lazydev.ft = { ft }
CFG.cmp:ft(ft)
CFG.cmp.sources[ft] = {
    inherit_defaults = true,
    "lazydev",
}
CFG.cmp.providers["lazydev"] = {
    name = "LazyDev",
    module = "lazydev.integrations.blink",
    enabled = true,
    score_offset = 100,
    fallbacks = {
        "lsp",
    },
}

---
--- === Format ===
---
local fmt = "lua-format"
table.insert(CFG.mason.ensure_installed.mason, "luaformatter")

CFG.fmt:ft(ft)
CFG.fmt.providers[fmt] = {}
CFG.fmt.source[ft] = {
    fmt,
}

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

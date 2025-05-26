---
--- === CMP ===
---
--- Latex Symbols
table.insert(CFG.cmp.dependencies --[[@as table]] , "kdheepak/cmp-latex-symbols")
table.insert(CFG.cmp.default, "latex_symbols")

---@type blink.cmp.SourceProviderConfigPartial
CFG.cmp.providers.latex_symbols = {
    enabled = true,
    name = "latex_symbols",
    module = "blink.compat.source",
    should_show_items = function(ctx, _items)
        return vim.bo[ctx.bufnr].filetype ~= "tex"
    end,
}

---
--- === LSP ===
---
local server = "ltex_plus"
table.insert(CFG.mason.ensure_installed.lsp, server)
---@type vim.lsp.Config
CFG.lsp.servers[server] = {
    settings = {
        ltex = {
            language = "en-AU",
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "en-AU",
            },
            completionEnabled = true,
            checkFrequency = "save",
        },
    },
}

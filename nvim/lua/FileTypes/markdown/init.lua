local ft = "md"
local filetypes = {
    "markdown",
    "markdown_inline",
}

vim.list_extend(CFG.treesitter.ensure_installed, filetypes)

---
--- === CMP ===
---

local render = CFG.spec:add("MeanderingProgrammer/render-markdown.nvim")
render.ft = filetypes

render.opts.completions = {
    win_options = {
        conceallevel = {
            default = 0,
            rendered = 3,
        },
    },
    blink = {
        enabled = true,
    },
}

---
--- === LSP ===
---
CFG.lsp:ft(ft)

--- Marksman ---
CFG.lsp.servers.marksman = {
    enabled = true,
}

---
--- === Format ===
---

local fmt = "markdownlint-cli2"
table.insert(CFG.mason.ensure_installed.mason, fmt)

CFG.fmt:ft(ft)
CFG.fmt.providers[fmt] = {}
for _, ftype in ipairs(filetypes) do
    CFG.fmt.source[ftype] = {
        fmt,
    }
end

---
--- === Lint ===
---
CFG.lint:add(filetypes[1], "markdownlint-cli2", {})

---@class OLTreeSitter
CFG.treesitter = {
    ensure_installed = {
        "regex",
    },
}

local path = CFG.paths:join(
    {
        "Plugins",
        "treesitter",
    }
)

local treesitter = CFG.spec:add("nvim-treesitter/nvim-treesitter")
---@module "nvim-treesitter"

treesitter.branch = "main"

treesitter.dependencies = {}

treesitter.build = ":TSUpdate"

treesitter.event = {
    "VeryLazy",
    "BufReadPost",
    "BufNewFile",
    "BufWritePre",
}

treesitter.cmd = {
    "TSUpdate",
    "TSInstall",
}

function treesitter.init(plugin)
    require("lazy.core.loader").add_to_rtp(plugin)
end

---
--- Opts ---
---

---@type TSConfig
local opts = {
    install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
    ensure_installed = CFG.treesitter.ensure_installed,
    --- Highlight
    highlight = {
        enable = true,
    },
    --- Indent
    indent = {
        enable = true,
    },
    --- Folding
    fold = {
        enable = true,
    },
}
treesitter.opts = opts

--- Highlight ---
treesitter.post:insert(
    function()
        if opts.highlight.enable then
            local parser, _ = vim.treesitter.get_parser(
                0, nil, {
                    error = false,
                }
            )
            if parser then
                vim.treesitter.start(0)
            end
        end
    end
)

--- Indentation ---
treesitter.post:insert(
    function()
        if opts.indent.enable then
            CFG.set:bo(
                "indentexpr", "v:lua.require'nvim-treesitter'.indentexpr()"
            )
        end
    end
)

--- Folding ---
treesitter.post:insert(
    function()
        if opts.fold.enable then
            CFG.set:wo("foldmethod", "expr")
            CFG.set:wo("foldexpr", "v:lua.vim.treesitter.foldexpr()")
        end
        CFG.set:wo("foldlevel", 99)
        CFG.key:map(
            {
                "<CR>",
                "za",
                mode = {
                    "n",
                },
            }
        )
    end
)

--- Ensure Installed ---
treesitter.post:insert(
    function()
        require("nvim-treesitter").install(opts.ensure_installed)
    end
)

--- Auto Install ---
treesitter.post:insert(
    function()
        local nvim_treesitter = require("nvim-treesitter")
        CFG.aucmd:on(
            "FileType", function()
                local ft = vim.bo.filetype
                nvim_treesitter.install(ft)
            end
        )
    end
)

--- Plugins ---
local plugins = {
    "rainbow_delimiters",
    "context",
    "commentstring",
    "treewalker",
}
for _, file in ipairs(plugins) do
    local plugin = require(
        path:join(
            { file }
        ).mod
    )
    if plugin.setup then
        treesitter = plugin.setup(treesitter)
    end
end

CFG.colourscheme:set("treesitter")

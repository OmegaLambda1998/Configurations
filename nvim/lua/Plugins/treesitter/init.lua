---@class OLTreeSitter
CFG.treesitter = {
    ensure_installed = {},
}

local path = CFG.paths:join(
    {
        "Plugins",
        "treesitter",
    }
)

local treesitter = CFG.spec:add("nvim-treesitter/nvim-treesitter")

treesitter.main = "nvim-treesitter.configs"

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
    require("nvim-treesitter.query_predicates")
end

---
--- Opts ---
---

---@type TSConfig
local opts = {
    ensure_installed = CFG.treesitter.ensure_installed,
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    modules = {},

    --- Modules ---
    --- Highlight
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_lang, buf)
            local max_filesize = CFG.spec:get("snacks").opts.bigfile.size
            local ok, stats = pcall(
                vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf)
            )
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        custom_captures = {},
    },
    --- Incremental Selection
    incremental_selection = {
        enable = false,
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

--- Folding ---
treesitter.post:insert(
    function()
        if opts.fold.enable then
            CFG.set:wo("foldmethod", "expr")
            CFG.set:wo("foldexpr", "nvim_treesitter#foldexpr()")
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

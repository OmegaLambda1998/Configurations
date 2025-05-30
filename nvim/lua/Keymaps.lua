--- Yank to and Paste from system clipboard
CFG.key:map(
    {
        mode = {
            "n",
            "v",
        },
        noremap = true,
        silent = true,
        {
            "Y",
            "\"+y",
            desc = "Yank to system clipboard",
        },
        {
            "P",
            "\"+p",
            desc = "Paste from system clipboard",
        },
    }
)

--- Better up / down
CFG.key:map(
    {
        mode = {
            "n",
            "x",
        },
        expr = true,
        silent = true,
        {
            "j",
            function()
                return vim.v.count == 0 and "gj" or "j"
            end,
            desc = "Down",
        },
        {
            "k",
            function()
                return vim.v.count == 0 and "gk" or "k"
            end,
            desc = "Up",
        },
    }
)

--- Move between splits
CFG.key:map(
    {
        mode = { "n" },
        remap = true,
        {
            "<A-h>",
            "<C-w>h",
            desc = "Left Split",
        },
        {
            "<A-j>",
            "<C-w>j",
            desc = "Lower Split",
        },
        {
            "<A-k>",
            "<C-w>k",
            desc = "Upper Split",
        },
        {
            "<A-l>",
            "<C-w>l",
            desc = "Right Split",
        },
    }
)

--- Create splits
CFG.key:map(
    {
        {
            "<leader>-",
            "<C-w>s",
            desc = "Split Window Below",
            remap = true,
        },
        {
            "<leader>|",
            "<C-w>v",
            desc = "Split Window Right",
            remap = true,
        },
    }
)

--- Clear search
CFG.key:map(
    {
        "<esc>",
        function()
            vim.cmd("noh")
            vim.cmd("diffupdate")
            vim.cmd("normal!<C-L><CR>")
            require("snacks").notifier.hide()
        end,
        mode = { "n" },
        desc = "Escape, Clear, Diff Update, Redraw",
    }
)
CFG.key:map(
    {
        "<esc>",
        function()
            vim.cmd("noh")
            return "<esc>"
        end,
        mode = {
            "i",
            "s",
        },
        expr = true,
        desc = "Escape, Clear",
    }
)

--- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
--- n always goes forward and N always backwards
CFG.key:map(
    {
        {
            "n",
            "'Nn'[v:searchforward].'zv'",
            mode = {
                "n",
            },
            expr = true,
            desc = "Next",
        },
        {
            "n",
            "'Nn'[v:searchforward]",
            mode = {
                "x",
                "o",
            },
            expr = true,
            desc = "Next",
        },
        {
            "N",
            "'nN'[v:searchforward].'zv'",
            mode = {
                "n",
            },
            expr = true,
            desc = "Next",
        },
        {
            "N",
            "'nN'[v:searchforward]",
            mode = {
                "x",
                "o",
            },
            expr = true,
            desc = "Next",
        },
    }
)

--- Add undo break-points
CFG.key:map(
    {
        ",",
        ",<c-g>u",
        mode = { "i" },
    }
)
CFG.key:map(
    {
        ".",
        ".<c-g>u",
        mode = { "i" },
    }
)
CFG.key:map(
    {
        ";",
        ";<c-g>u",
        mode = { "i" },
    }
)

--- Better Indenting
CFG.key:map(
    {
        "<",
        "<gv",
        mode = { "v" },
    }
)
CFG.key:map(
    {
        ">",
        ">gv",
        mode = { "v" },
    }
)

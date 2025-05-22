local dynomark = CFG.spec:add("k-lar/dynomark.nvim")

local filetypes = {
    "markdown",
    "markdown_inline",
}
dynomark.ft = filetypes
dynomark.opts = {
    auto_download = true,
    results_view_location = "float",
    float_horizontal_offset = 0.0,
    float_vertical_offset = 0.0,
}

CFG.key:map(
    {
        "<leader>km",
        desc = "Dynomark",
        group = "Dynomark",
        {
            "<leader>kmm",
            "<Plug>(DynomarkRun)",
            desc = "Run",
        },
        {
            "<leader>kmt",
            "<Plug>(DynomarkToggle)",
            desc = "Toggle",
        },
    }
)

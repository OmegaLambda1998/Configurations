local M = {}
local hover = CFG.spec:add("lewis6991/hover.nvim")
---@module "hover"

hover.event = {
    "LspAttach",
}

---@type Hover.UserConfig
hover.opts = {
    providers = {
        "diagnostic",
        "lsp",
    },
    init = function()
        for _, provider in ipairs(hover.opts.providers) do
            require("hover.providers." .. provider)
        end
    end,
    mouse_providers = {},
    preview_opts = {
        border = "single",
    },
    preview_window = false,
    title = true,
}

hover.post:insert(
    function()
        local h = require("hover")
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<S-k>")
        end
        CFG.lsp.diagnostic.opts.jump.on_jump = function()
            h.hover({})
        end
        CFG.key:map(
            {
                "<C-k>",
                function()
                    local hover_win = vim.b.hover_preview
                    if hover_win and vim.api.nvim_win_is_valid(hover_win) then
                        vim.api.nvim_set_current_win(hover_win)
                    end
                end,
                desc = "Enter Hover",
            }
        )
    end
)

return M

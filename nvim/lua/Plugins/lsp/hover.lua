local M = {}
local hover = CFG.spec:add("lewis6991/hover.nvim")
---@module "hover"

hover.event = {
    "LspAttach",
}

---Replace ```text with ```{ft} in LSP hover responses
---@param content string[]
---@return string[]
local function modify_markdown(content)
    local ft = vim.bo.filetype
    ---@type string[]
    local modified = {}
    for _, line in ipairs(content) do
        modified[#modified + 1] = line:gsub("```text", "```" .. ft)
    end
    return modified
end

---@type Hover.UserConfig
hover.opts = {
    providers = {
        "diagnostic",
        "lsp",
    },
    init = function()
        local providers = require("hover.providers").providers
        for _, provider in ipairs(hover.opts.providers) do
            require("hover.providers." .. provider)
        end

        local lsp_orig = vim.deepcopy(providers[#providers])
        local lsp = providers[#providers]

        lsp.execute = function(opts, done)
            local function _done(result)
                if result and result.lines then
                    result.lines = modify_markdown(result.lines)
                end
                return done(result)
            end
            return lsp_orig.execute(opts, _done)
        end
        lsp.execute_a = require("hover.async").wrap(lsp.execute, 2)

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

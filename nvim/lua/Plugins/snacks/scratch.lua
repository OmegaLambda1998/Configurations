local M = {}
---@module "snacks"

---@type snacks.scratch.Config
local opts = {
    enabled = true,
    name = "Scratch",
    ft = function()
        return "markdown"
    end,
    icon = nil,
    root = (vim.fn.environ().AREAS or vim.fn.stdpath("data")) ..
        "/Notes/Scratch",
    autowrite = true,
    filekey = {
        cwd = true,
        branch = true,
        count = true,
        name = true,
    },
    win = {
        style = "scratch",
        relative = "editor",
    },
    win_by_ft = {},
}

---Setup snacks scroll
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.scratch = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    {
                        "<leader>s",
                        group = "Scratch",
                        desc = "Scratch",
                        mode = {
                            "n",
                        },
                    },
                    {
                        "<leader>ss",
                        function()
                            Snacks.scratch()
                        end,
                        desc = "Toggle Scratch",
                        mode = {
                            "n",
                        },
                    },
                    {
                        "<leader>sp",
                        function()
                            Snacks.scratch.select()
                        end,
                        desc = "Scratch",
                        mode = {
                            "n",
                        },
                    },
                }
            )
        end
    )
    return snacks
end

return M

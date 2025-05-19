local M = {}
---@module "snacks"

---@type snacks.terminal.Config
local opts = {
    enabled = true,
}

---Setup snacks terminal
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.terminal = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>tt",
                    function()
                        Snacks.terminal()
                    end,
                    desc = "Toggle Terminal",
                    mode = {
                        "n",
                        "t",
                    },
                }
            )
        end
    )
    return snacks
end

return M

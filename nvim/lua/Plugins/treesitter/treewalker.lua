local M = {}
---@module "treewalker"
---@alias TreewalkerConfig Opts

local url = "aaronik/treewalker.nvim"
local treewalker = CFG.spec:add(url)

---@type TreewalkerConfig
treewalker.opts = {
    enable = true,
    highlight = true,
    highlight_duration = 250,
    highlight_group = "CursorLine",
    jumplist = true,
}

treewalker.post:insert(
    function()
        CFG.key:map(
            {
                mode = {
                    "n",
                    "v",
                },
                {
                    "<up>",
                    "<cmd>Treewalker Up<cr>",
                    desc = "TS Up",
                },

                {
                    "<down>",
                    "<cmd>Treewalker Down<cr>",
                    desc = "TS Down",
                },

                {
                    "<left>",
                    "<cmd>Treewalker Left<cr>",
                    desc = "TS Left",
                },
                {
                    "<right>",
                    "<cmd>Treewalker Right<cr>",
                    desc = "TS Right",
                },
            }
        )
    end
)

---@param treesitter Specification
---@return Specification
function M.setup(treesitter)
    table.insert(
        treesitter.dependencies --[[@as table]] , {
            url,
        }
    )
    return treesitter
end

return M

local M = {}
---@module "treesitter-context"

local url = "nvim-treesitter/nvim-treesitter-context"
local context = CFG.spec:add(url)
context.main = "treesitter-context"

---@type TSContext.UserConfig
context.opts = {
    enable = true,
}

CFG.colourscheme:set("treesitter_context")

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

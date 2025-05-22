local M = {}
---@module "treesitter-context"

local url = "nvim-treesitter/nvim-treesitter-context"
local context = CFG.spec:add(url)
context.main = "treesitter-context"

---@type TSContext.Config
context.opts = {
    enable = true,
    multiwindow = false,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = "outer",
    mode = "cursor",
    separator = nil,
    zindex = 20,
    on_attach = nil,
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

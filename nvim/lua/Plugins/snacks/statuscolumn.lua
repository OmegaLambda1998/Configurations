local M = {}
---@module "snacks"

---@type snacks.statuscolumn.Config
local opts = {
    enabled = true,
    left = { "sign" },
    right = { "fold" },
    folds = {
        open = true,
    },
    refresh = 50,
    git = {
        -- patterns to match Git signs
        patterns = {
            "GitSign",
            "MiniDiffSign",
        },
    },
}

---Setup snacks statuscolumn
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.statuscolumn = opts
    return snacks
end

return M

local M = {}
---@module "ts_context_commentstring"

local url = "JoosepAlviste/nvim-ts-context-commentstring"
local commentstring = CFG.spec:add(url)

commentstring.main = "ts_context_commentstring"

---@class OLCommentString
CFG.commentstring = {}

---@type ts_context_commentstring.Config
commentstring.opts = {
    enable = true,
    enable_autocmd = false,
    languages = CFG.commentstring,
    not_nested_languages = {},
}

commentstring.post:insert(
    function()
        local get_option = vim.filetype.get_option
        vim.filetype.get_option = function(filetype, option)
            return option == "commentstring" and
                       require("ts_context_commentstring.internal").calculate_commentstring() or
                       get_option(filetype, option)
        end
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

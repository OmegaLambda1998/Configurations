local M = {}
---@module "snacks"

local priority = 200
local hl = {
    "SnacksIndent1",
    "SnacksIndent2",
    "SnacksIndent3",
    "SnacksIndent4",
    "SnacksIndent5",
    "SnacksIndent6",
    "SnacksIndent7",
    "SnacksIndent8",
}
local only_current = true

---@type snacks.indent.Config
local opts = {
    enabled = true,

    indent = {
        enabled = true,
        priority = priority,
        hl = hl,
        only_scope = false,
        only_current = only_current,
        char = ".",
    },

    animate = {
        enabled = true,
        duration = {
            step = 10,
            total = 300,
        },
    },

    scope = {
        enabled = true,
        priority = priority,
        underline = true,
        only_current = only_current,
        hl = hl,
        char = ".",
    },

    chunk = {
        enabled = true,
        priority = priority,
        underline = true,
        only_current = only_current,
        hl = hl,
        char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
        },
    },
    filter = function(buf)
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~=
                   false and vim.bo[buf].buftype == ""
    end,
    debug = CFG.verbose,
}

---Setup snacks indent
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.indent = opts
    return snacks
end

return M

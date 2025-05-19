local M = {}
---@module "snacks"

---@type snacks.scope.Config
local opts = {
    enabled = true,
    min_size = 2,
    max_size = nil,
    cursor = true,
    edge = true,
    siblings = false,
    filter = function(buf)
        return
            vim.bo[buf].buftype == "" and vim.b[buf].snacks_scope ~= false and
                vim.g.snacks_scope ~= false
    end,
    debounce = 30,
    treesitter = {
        enabled = true,
        injections = true,
        blocks = {
            enabled = false,
            "function_declaration",
            "function_definition",
            "method_declaration",
            "method_definition",
            "class_declaration",
            "class_definition",
            "do_statement",
            "while_statement",
            "repeat_statement",
            "if_statement",
            "for_statement",
        },
        field_blocks = {
            "local_declaration",
        },
    },
    keys = {
        textobject = {
            ii = {
                min_size = 2,
                edge = false,
                cursor = false,
                treesitter = {
                    blocks = {
                        enabled = false,
                    },
                },
                desc = "inner scope",
            },
            ai = {
                cursor = false,
                min_size = 2,
                treesitter = {
                    blocks = {
                        enabled = false,
                    },
                },
                desc = "full scope",
            },
        },
        jump = {
            ["[i"] = {
                min_size = 1,
                bottom = false,
                cursor = false,
                edge = true,
                treesitter = {
                    blocks = {
                        enabled = false,
                    },
                },
                desc = "jump to top edge of scope",
            },
            ["]i"] = {
                min_size = 1,
                bottom = true,
                cursor = false,
                edge = true,
                treesitter = {
                    blocks = {
                        enabled = false,
                    },
                },
                desc = "jump to bottom edge of scope",
            },
        },
    },
}

---Setup snacks scope
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.scope = opts
    return snacks
end

return M

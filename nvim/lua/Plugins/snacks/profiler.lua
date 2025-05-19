local M = {}
---@module "snacks"

---@type snacks.profiler.Config
local opts = {
    enabled = true,
    debug = CFG.verbose,
    autocmds = true,
    runtime = vim.env.VIMRUNTIME,
    thresholds = {
        time = {
            2,
            10,
        },
        pct = {
            10,
            20,
        },
        count = {
            10,
            100,
        },
    },
    on_stop = {
        highlights = true,
        pick = true,
    },
    highlights = {
        min_time = 0,
        max_shade = 20,
        badges = {
            "time",
            "pct",
            "count",
            "trace",
        },
        align = 80,
    },
    pick = {
        picker = "snacks",
        badges = {
            "time",
            "count",
            "name",
        },
        preview = {
            badges = {
                "time",
                "pct",
                "count",
            },
            align = "right",
        },
    },
    startup = {
        event = "VimEnter",
        after = true,
        pattern = nil,
        pick = true,
    },
    presets = {
        startup = {
            min_time = 1,
            sort = false,
        },
        on_stop = {},
        filter_by_plugin = function()
            return {
                filter = {
                    def_plugin = vim.fn.input("Filter by plugin: "),
                },
            }
        end,
    },
    globals = {},
    filter_mod = {
        default = true,
        ["^vim%."] = false,
        ["mason-core.functional"] = false,
        ["mason-core.functional.data"] = false,
        ["mason-core.optional"] = false,
        ["which-key.state"] = false,
    },
    filter_fn = {
        default = true,
        ["^.*%._[^%.]*$"] = false,
        ["trouble.filter.is"] = false,
        ["trouble.item.__index"] = false,
        ["which-key.node.__index"] = false,
        ["smear_cursor.draw.wo"] = false,
        ["^ibl%.utils%."] = false,
    },
    icons = {
        time = " ",
        pct = " ",
        count = " ",
        require = "󰋺 ",
        modname = "󰆼 ",
        plugin = " ",
        autocmd = "⚡",
        file = " ",
        fn = "󰊕 ",
        status = "󰈸 ",
    },
}

---Setup snacks profiler
---@param snacks Specification
---@return Specification
function M.setup(snacks)
    snacks.opts.profiler = opts
    snacks.post:insert(
        function()
            local Snacks = require("snacks")
            CFG.key:map(
                {
                    "<leader>P",
                    mode = {
                        "n",
                    },
                    desc = "Profile",
                    group = "Profile",
                    {
                        "<leader>Pp",
                        function()
                            Snacks.profiler.toggle()
                        end,
                        desc = "Toggle Profiler",
                    },
                    {
                        "<leader>Ph",
                        function()
                            Snacks.profiler.highlight()
                        end,
                        desc = "Toggle Highlights",
                    },
                    {
                        "<leader>Po",
                        function()
                            Snacks.profiler.scratch()
                        end,
                        desc = "Scratch",
                    },
                }
            )
        end
    )
    return snacks
end

return M

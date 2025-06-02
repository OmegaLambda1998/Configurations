local heirline = CFG.spec:add("rebelot/heirline.nvim")
---@module "heirline"

heirline.event = {
    "VeryLazy",
}
heirline.dependencies = {
    "Zeioth/heirline-components.nvim",
}

---@alias HeirlineConfig {statusline?: StatusLine, winbar?: StatusLine, tabline?: StatusLine, statuscolumn?: StatusLine, opts?: table}

heirline.pre:insert(
    ---@param opts HeirlineConfig
    ---@return HeirlineConfig
    function(opts)
        local lib = require("heirline-components.all")
        lib.init.subscribe_to_events()
        require("heirline").load_colors(lib.hl.get_colors())

        local lsp = lib.component.lsp(
            {
                lsp_client_names = {
                    integrations = {
                        conform = false,
                        ["nvim-lint"] = false,
                    },
                },
            }
        )

        local get_provider = function(override)
            return function(o)
                local str = override(o)
                for _, client in pairs(
                    vim.lsp.get_clients(
                        {
                            bufnr = 0,
                        }
                    )
                ) do
                    local name = client.name
                    str = string.gsub(str, " " .. name .. " ", "")
                    str = string.gsub(str, " " .. name .. ",", "")
                    str = string.gsub(str, " " .. name .. "$", "")
                end
                return str
            end
        end

        local fmt = lib.component.lsp(
            {
                lsp_progress = false,
                lsp_client_names = {
                    str = "FMT",
                    integrations = {
                        conform = true,
                        ["nvim-lint"] = false,
                    },
                },
            }
        )
        fmt[2][2][1].provider = get_provider(fmt[2][2][1].provider)

        local lint = lib.component.lsp(
            {
                lsp_progress = false,
                lsp_client_names = {
                    str = "LINT",
                    integrations = {
                        conform = false,
                        ["nvim-lint"] = true,
                    },
                },
            }
        )
        lint[2][2][1].provider = get_provider(lint[2][2][1].provider)

        opts.statusline = {
            lib.component.mode(),
            lib.component.virtual_env(),
            lib.component.file_info(
                {
                    filetype = false,
                    filename = {},
                    file_modified = {},
                }
            ),

            lib.component.fill(),
            lib.component.cmd_info(),
            lib.component.fill(),

            lsp,
            fmt,
            lint,
            lib.component.treesitter(),
            lib.component.nav(),
        }

        return opts
    end
)

heirline.post:insert(
    function()
        --- Initial Settings
        vim.opt.cmdheight = 0
        vim.opt.laststatus = 3
    end
)

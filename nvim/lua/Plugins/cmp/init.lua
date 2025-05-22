local blink = CFG.spec:add("saghen/blink.cmp")
---@module "blink.cmp"

local path = CFG.paths:join(
    {
        "Plugins",
        "cmp",
    }
)

---@class OLCMP
CFG.cmp = {
    dependencies = {
        {
            "xzbdmw/colorful-menu.nvim",
        },
        {
            "Saghen/blink.compat",
        },
        {
            "rafamadriz/friendly-snippets",
        },
    },
    sources = {},
    providers = {},
    event = {
        "CmdlineEnter",
        "InsertEnter",
    },
}

function CFG.cmp:ft(ft)
    table.insert(self.event, "InsertEnter *." .. ft)
end

blink.build = "cargo clean && cargo build --release"
blink.event = CFG.cmp.event
blink.dependencies = CFG.cmp.dependencies

---@type blink.cmp.Config
blink.opts = {
    appearance = {
        nerd_font_variant = "mono",
    },
    cmdline = {
        completion = {
            ghost_text = {
                enabled = false,
            },
            list = {
                selection = {
                    auto_insert = true,
                    preselect = false,
                },
            },
            menu = {
                auto_show = true,
            },
        },
        enabled = true,
        keymap = {
            preset = "cmdline",
        },
    },
    completion = {
        accept = {
            dot_repeat = false,
            resolve_timeout_ms = 1000,
            auto_brackets = {
                enabled = false,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
            treesitter_highlighting = true,
        },
        ghost_text = {
            enabled = false,
        },
        keyword = {
            range = "prefix",
        },
        list = {
            selection = {
                auto_insert = true,
                preselect = false,
            },
        },
        menu = {
            auto_show = true,
            draw = {
                align_to = "label",
                columns = {
                    {
                        "kind_icon",
                    },
                    {
                        "provider",
                    },
                    {
                        "label",
                        gap = 1,
                    },
                    {
                        "lsp",
                    },
                },
                components = {
                    label = {
                        text = function(ctx)
                            return
                                require("colorful-menu").blink_components_text(
                                    ctx
                                )
                        end,
                        highlight = function(ctx)
                            local hl =
                                require("colorful-menu").blink_components_highlight(
                                    ctx
                                )
                            return hl
                        end,
                    },
                    provider = {
                        text = function(ctx)
                            return "[" .. ctx.item.source_name:sub(1, 3) .. "]"
                        end,
                        highlight = function(ctx)
                            return ctx.kind_hl or ("BlinkCmpKind" .. ctx.kind)
                        end,
                    },
                    lsp = {
                        text = function(ctx)
                            local client =
                                vim.lsp.get_client_by_id(
                                    ctx.item.client_id --[[@as integer]]
                                )
                            if not (client and not client:is_stopped()) then
                                return
                            end
                            local source = client.name
                            if #source > 9 then
                                source =
                                    source:sub(1, 3) .. "..." ..
                                        source:sub(#source - 3, #source)
                            end
                            return "<" .. source .. ">"
                        end,
                        highlight = "BlinkCmpLabelDetail",
                    },
                },
            },
        },
    },
    fuzzy = {
        implementation = "prefer_rust",
        sorts = {
            "exact",
            "score",
            "sort_text",
        },
        prebuilt_binaries = {
            download = false,
        },
    },
    keymap = {
        preset = "none",

        ["<Tab>"] = {
            "select_next",
            "fallback",
        },
        ["<S-Tab>"] = {
            "select_prev",
            "fallback",
        },

        ["<CR>"] = {
            "accept",
            "fallback",
        },

        ["<C-K>"] = {
            "show",
            "show_documentation",
            "hide_documentation",
            "fallback",
        },
        ["<C-Up>"] = {
            "scroll_documentation_up",
            "fallback",
        },
        ["<C-Down>"] = {
            "scroll_documentation_down",
            "fallback",
        },
    },
    signature = {
        enabled = true,
        trigger = {
            enabled = true,
            show_on_insert = true,
        },
    },
    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
        min_keyword_length = 0,
        transform_items = function(_, items)
            return items
        end,
        providers = CFG.cmp.providers,
        per_filetype = CFG.cmp.sources,
    },
    term = {},
}

---@type blink.cmp.SourceProviderConfigPartial
blink.opts.sources.providers.path = {
    opts = {
        show_hidden_files_by_default = true,
        ignore_root_slash = true,
    },
}

---@type blink.cmp.SourceProviderConfigPartial
blink.opts.sources.providers.snippets = {
    opts = {
        search_paths = {
            path:join(
                {
                    "snippets",
                }
            ).path,
        },
    },
}

--- Latex Symbols
table.insert(blink.dependencies --[[@as table]] , "kdheepak/cmp-latex-symbols")
table.insert(blink.opts.sources.default, "latex_symbols")

---@type blink.cmp.SourceProviderConfigPartial
blink.opts.sources.providers.latex_symbols = {
    enabled = true,
    name = "latex_symbols",
    module = "blink.compat.source",
}

--- Integrations ---
CFG.colourscheme:set("blink_cmp")

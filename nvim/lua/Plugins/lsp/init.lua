local lsp = CFG.spec:add("neovim/nvim-lspconfig")
local mason = CFG.spec:add("mason-org/mason-lspconfig.nvim")
---@module "lspconfig"
---@module "mason-lspconfig"

lsp.setup = false
local path = CFG.paths:join(
    {
        "Plugins",
        "lsp",
    }
)

---@type MasonLspconfigSettings
mason.opts = {
    automatic_enable = false,
    ensure_installed = CFG.mason.ensure_installed.lsp,
}

---@class OLLSP
CFG.lsp = {
    event = {},
    diagnostic = {
        enabled = true,
        ---@type vim.diagnostic.Opts
        opts = {
            severity_sort = true,
            update_in_insert = true,
            float = {
                border = "single",
                scope = "line",
                source = "if_many",
            },
            jump = {
                wrap = true,
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
            underline = {
                severity = {
                    min = vim.diagnostic.severity.HINT,
                },
            },
            virtual_lines = false,
            virtual_text = false,
        },
    },
    inlay_hint = {
        enabled = true,
    },
    semantic_tokens = {
        enabled = true,
    },
    document_colour = {
        enabled = true,
        ---@type vim.lsp.document_color.enable.Opts
        opts = {
            style = "background",
        },
    },
    ---@type lsp.ClientCapabilities
    capabilities = {},
    ---@type table<string, string | vim.lsp.Config>
    servers = {
        ["*"] = {},
    },
}

CFG.key:map(
    {
        "<S-k>",
        function()
            CFG.lsp.diagnostic.opts.jump.on_jump()
        end,
        desc = "Hover",
    }
)

function CFG.lsp:ft(ft)
    if ft ~= "*" then
        table.insert(self.event, "BufReadPost *." .. ft)
    else
        table.insert(self.event, "BufReadPost *")
    end
end

lsp.event = CFG.lsp.event

--- === Appearance ===
CFG.colourscheme:set("semantic_tokens")
CFG.colourscheme.integrations.native_lsp = {
    enabled = true,
    inlay_hints = {
        background = true,
    },
    underlines = {
        errors = {
            "underdouble",
        },
        warnings = {
            "undercurl",
        },
        information = {
            "underdashed",
        },
        hints = {
            "underdotted",
        },
        ok = {
            "italic",
        },
    },
    virtual_text = {
        errors = {
            "bold",
        },
        warnings = {
            "italic",
        },
        information = {
            "italic",
        },
        hints = {
            "italic",
        },
        ok = {
            "italic",
        },
    },
}

--- === Setup ===
--- Logging ---
lsp.post:insert(
    function()
        vim.lsp.set_log_level(CFG.verbose and "debug" or "warn")
        require("vim.lsp.log").set_format_func(CFG.log.inspect)
    end
)

--- Diagnostics ---
lsp.post:insert(
    function()
        vim.diagnostic.config(CFG.lsp.diagnostic.opts)
    end
)

--- Inlay Hints ---
lsp.post:insert(
    function()
        if CFG.lsp.inlay_hint.enable then
            CFG.aucmd:on(
                "LspAttach", function(ctx)
                    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
                    if client and
                        client:supports_method("textDocument/inlayHint") then
                        local buf = ctx.buf
                        if vim.api.nvim_buf_is_valid(buf) and
                            vim.bo[buf].buftype == "" then
                            vim.lsp.inlay_hint.enable(CFG.lsp.inlay_hint.enable)
                        end
                    end
                end, {
                    group = "LspAttach",
                }
            )
        end
    end
)

--- Semantic Tokens ---
lsp.post:insert(
    function()
        if CFG.lsp.semantic_tokens.enable then
        end
    end
)

--- Document Colour ---
lsp.post:insert(
    function()
        if CFG.lsp.document_colour.enable then
            CFG.aucmd:on(
                "LspAttach", function(ctx)
                    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
                    if client and
                        client:supports_method("textDocument/documentColor") then
                        local buf = ctx.buf
                        if vim.api.nvim_buf_is_valid(buf) and
                            vim.bo[buf].buftype == "" then
                            vim.lsp.document_color.enable(
                                CFG.lsp.document_colour.enable, buf,
                                    CFG.lsp.document_colour.opts
                            )
                        end
                    end
                end, {
                    group = "LspAttach",
                }
            )
        end
    end
)

--- Capabilities ---
lsp.post:insert(
    function()
        CFG.lsp.servers["*"].capabilities = vim.tbl_deep_extend(
            "force", vim.lsp.protocol.make_client_capabilities(),
                CFG.lsp.capabilities
        )
    end
)

--- Install Servers ---
lsp.post:insert(
    function()
        if #CFG.mason.ensure_installed.lsp > 0 then
            local mappings = require("mason-lspconfig.mappings").get_mason_map()
            for _, server in ipairs(CFG.mason.ensure_installed.lsp) do
                local tool = mappings.lspconfig_to_package[server]
                if not vim.tbl_contains(vim.tbl_keys(CFG.lsp.servers), server) then
                    CFG.lsp.servers[server] = CFG.lsp.servers[tool] or {}
                end
            end
        end
    end
)

--- Configure Servers ---
lsp.post:insert(
    function()
        for server, server_opts in pairs(CFG.lsp.servers) do
            if server ~= "*" then
                if type(server_opts) == "string" then
                    server_opts = CFG.lsp.servers[server_opts] or {}
                end
                local opts = vim.tbl_deep_extend(
                    "force", vim.deepcopy(
                        CFG.lsp.servers["*"] --[[@as vim.lsp.ClientConfig]]
                    ), server_opts
                )
                vim.lsp.config(server, opts)
            end
        end
    end
)

--- Enable Servers ---
lsp.post:insert(
    function()
        for server, _ in pairs(CFG.lsp.servers) do
            if server ~= "*" then
                vim.lsp.enable(server)
            end
        end
    end
)

--- Clear LSP Log ---
lsp.post:insert(
    function()
        local log = vim.fs.joinpath(vim.fn.stdpath("state"), "lsp.log")
        if vim.uv.fs_stat(log) then
            vim.fs.rm(log)
        end
    end
)

--- === Plugins ===

local plugins = {
    "inlay_hint",
    "hover",
}

for _, file in ipairs(plugins) do
    local plugin = require(
        path:join(
            { file }
        ).mod
    )
    if plugin.setup then
        lsp = plugin.setup(lsp)
    end
end

--- === Keymaps ===
local diagnostic_goto = function(next, severity)
    return function()
        vim.diagnostic.jump(
            {
                count = next and 1 or -1,
                severity = severity and {
                    min = vim.diagnostic.severity[severity],
                } or nil,
                on_jump = function(diagnostic, bufnr)
                    vim.defer_fn(
                        function()
                            CFG.lsp.diagnostic.opts.jump
                                .on_jump(diagnostic, bufnr)
                        end, 500
                    )
                end,
            }
        )
    end
end

local diagnostics = {
    e = "ERROR",
    w = "WARN",
    d = "HINT",
}

for key, severity in pairs(diagnostics) do
    CFG.key:map(
        {
            {
                "]" .. key,
                diagnostic_goto(true, severity),
                mode = {
                    "n",
                },
                desc = "Next " .. (severity or "Diagnostic"),
            },
            {
                "[" .. key,
                diagnostic_goto(false, severity),
                mode = {
                    "n",
                },
                desc = "Prev " .. (severity or "Diagnostic"),
            },
        }
    )
end

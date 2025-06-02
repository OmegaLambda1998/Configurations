local conform = CFG.spec:add("stevearc/conform.nvim")
---@module "conform"

CFG.disable.format = false

---@class OLFMT
CFG.fmt = {
    ---@type string | LazyPluginSpec | (string | LazyPluginSpec)[]
    dependencies = {},
    ---@type string[]
    event = {},
    ---@type table<string, conform.FormatterConfigOverride>
    providers = {},
    ---@type table<string, conform.FiletypeFormatterInternal>
    source = {},
}

function CFG.fmt:ft(ft)
    if ft ~= "*" then
        table.insert(self.event, "BufWritePre *." .. ft)
    else
        table.insert(self.event, "BufWritePre *")
    end
end

function CFG.fmt.format_fn(ctx)
    CFG.disable.format = true
    vim.cmd(":w")
    CFG.disable.format = false
end

function CFG.fmt.format(ctx)
    ctx = ctx or {}
    if not CFG.disable.format then
        CFG.fmt.format_fn(ctx)
    end
end

--- Format on save
CFG.aucmd:on(
    "BufWritePost", CFG.fmt.format, {
        pattern = "*",
    }
)

--- Save without format
CFG.key:map(
    {
        "<leader>w",
        function()
            CFG.disable.format = true
            vim.cmd(":w")
            CFG.disable.format = false
        end,
        desc = "Save w/o format",
    }
)

conform.cmd = {
    "ConformInfo",
}
conform.event = CFG.fmt.event
conform.dependencies = CFG.fmt.dependencies

---@type conform.setupOpts
conform.opts = {
    default_format_opts = {
        lsp_format = "fallback",
    },
    formatters = CFG.fmt.providers,
    formatters_by_ft = CFG.fmt.source,
    notify_no_formatters = false,
    notify_on_error = true,
}

conform.post:insert(
    function()
        local c = require("conform")

        ---@param err string
        ---@param did_edit boolean
        local function format_cb(err, did_edit)
            if err then
                CFG.log:notify(
                    err, {
                        level = vim.log.levels.WARN,
                    }
                )
            elseif did_edit then
                CFG.log:notify(
                    "Formatted " .. vim.fn.expand("%:t"), {
                        level = vim.log.levels.INFO,
                    }
                )
            else
                CFG.log:notify(
                    "No Changes", {
                        level = vim.log.levels.DEBUG,
                    }
                )
            end
            --- Save without formatting
            CFG.disable.format = true
            vim.cmd(":w")
            CFG.disable.format = false
        end

        CFG.fmt.format_fn = function(ctx)
            if #c.list_formatters(ctx.bufnr or 0) > 0 then
                CFG.log:notify(
                    "Formatting " .. vim.fn.expand("%:t"), {
                        level = vim.log.levels.DEBUG,
                    }
                )
                --- Format
                c.format(
                    {
                        bufnr = ctx.bufnr or 0,
                        async = true,
                    }, format_cb
                )
            end
        end
    end
)

--- Formatexpr
conform.post:insert(
    function()
        CFG.set:opt("formatexpr", "v:lua.require'conform'.formatexpr()")
    end
)


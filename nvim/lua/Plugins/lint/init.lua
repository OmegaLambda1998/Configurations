local lint = CFG.spec:add("mfussenegger/nvim-lint")
---@module "lint"

CFG.disable.lint = false

---@class OLLint
CFG.lint = {
    ---@type string | LazyPluginSpec | (string | LazyPluginSpec)[]
    dependencies = {},
    ---@type string[]
    event = {},
    ---@type table<string, lint.Linter>
    providers = {},
    ---@type table<string, string[]>
    source = {},
}

local events = {
    "BufWritePost",
    "BufReadPost",
    "InsertLeave",
}

function CFG.lint:ft(ft)
    for _, event in ipairs(events) do
        if ft ~= "*" then
            table.insert(self.event, event .. " *." .. ft)
        else
            table.insert(self.event, event .. " *")
        end
    end
end

function CFG.lint.lint_fn(ctx)
    -- Do nothing
end

function CFG.lint.lint(ctx)
    ctx = ctx or {}
    if not CFG.disable.lint then
        CFG.lint.lint_fn(ctx)
    end
end

--- Auto lint
CFG.aucmd:on(
    events, CFG.lint.lint, {
        pattern = "*",
    }
)

lint.main = "lint"
lint.setup = false
lint.event = CFG.lint.event
lint.dependencies = CFG.lint.dependencies

lint.opts = {
    ---@type table<string, lint.Linter>
    linters = CFG.lint.providers,
    ---@type table<string, string[]>
    linters_by_ft = CFG.lint.source,
}

lint.post:insert(
    function()
        local l = require("lint")

        l.linters_by_ft = CFG.lint.source

        for name, opts in pairs(CFG.lint.providers) do
            local linter_opts = l.linters[opts.as or name] or {}
            if type(linter_opts) == "function" then
                linter_opts = linter_opts()
            end
            linter_opts = vim.tbl_deep_extend("force", linter_opts, opts)
            l.linters[name] = linter_opts
        end

        CFG.lint.lint_fn = function(_ctx)
            if #l._resolve_linter_by_ft(vim.bo.filetype) > 0 then
                CFG.log:notify(
                    "Linting " .. vim.fn.expand("%:t"), {
                        level = vim.log.levels.DEBUG,
                    }
                )
                l.try_lint()
                CFG.log:notify(
                    "Linted " .. vim.fn.expand("%:t"), {
                        level = vim.log.levels.DEBUG,
                    }
                )
            end
        end
    end
)

CFG.usrcmd:fn(
    "LintInfo", function()
        local l = require("lint")
        local linters = l._resolve_linter_by_ft(vim.bo.filetype)
        if #linters > 0 then
            local msg = "Linters for " .. vim.fn.expand("%:t")
            for _, linter in ipairs(linters) do
                msg = msg .. "\n" .. linter
            end
            CFG.log:notify(msg)
        else
            CFG.log:notify("No linters configured for " .. vim.fn.expand("%:t"))
        end
    end, {}
)

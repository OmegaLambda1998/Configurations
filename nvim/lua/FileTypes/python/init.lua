local ft = "py"
local filetype = "python"

CFG.cmp:ft(ft)

---
--- === LSP ===
---
CFG.lsp:ft(ft)

--- Ruff ---
local servers = {}
servers.ruff = {
    enabled = true,
    init_options = {
        settings = {
            logLevel = CFG.verbose and "trace" or "info",
            showSyntaxErrors = true,
            codeAction = {
                disableRuleComment = {
                    enable = true,
                },
                fixViolation = {
                    enable = true,
                },
            },
            lint = {
                enable = false, --- Using nvim-lint for this
            },
        },
    },
}

--- servers.ty = {
---     init_options = {
---         settings = {
---             experimental = {
---                 logLevel = CFG.verbose and "trace" or "info",
---                 completions = {
---                     enable = true,
---                 },
---             },
---         },
---     },
--- }

for server, opts in pairs(servers) do
    table.insert(CFG.mason.ensure_installed.mason, server)
    CFG.lsp.servers[server] = opts
end

---
--- === Format ===
---

local formatters = {
    ruff_fix = {
        command = vim.fs.joinpath(CFG.mason.bin, "ruff"),
        args = {
            "check",
            "--fix",
            "--exit-zero",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
    ruff_format = {
        mason = false, --- Installed by LSP
        command = vim.fs.joinpath(CFG.mason.bin, "ruff"),
        args = {
            "format",
            "--force-exclude",
            "--stdin-filename",
            "$FILENAME",
            "-",
        },
        stdin = true,
    },
}

CFG.fmt:ft(ft)
CFG.fmt.source[filetype] = {}
for formatter, opts in pairs(formatters) do
    CFG.fmt.providers[formatter] = opts
    table.insert(CFG.fmt.source[filetype], formatter)
end

---
--- === Lint ===
---
local severities = {}
local linters = {
    ruff = {
        parser = function(output)
            local diagnostics = {}
            local ok, results = pcall(vim.json.decode, output)
            if not ok then
                return diagnostics
            end
            for _, result in ipairs(results or {}) do
                local diagnostic = {
                    message = result.message,
                    col = result.location.column - 1,
                    end_col = result.end_location.column - 1,
                    lnum = result.location.row - 1,
                    end_lnum = result.end_location.row - 1,
                    code = result.code,
                    severity = severities[result.code] or
                        vim.diagnostic.severity.INFO,
                    source = "ruff",
                }
                table.insert(diagnostics, diagnostic)
            end
            return diagnostics
        end,
    },
}

for linter, opts in pairs(linters) do
    CFG.lint:add(filetype, linter, opts)
end

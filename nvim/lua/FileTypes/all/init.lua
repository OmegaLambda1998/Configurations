---
--- === CMP ===
---
--- Latex Symbols
table.insert(CFG.cmp.dependencies --[[@as table]] , "kdheepak/cmp-latex-symbols")
table.insert(CFG.cmp.default, "latex_symbols")

---@type blink.cmp.SourceProviderConfigPartial
CFG.cmp.providers.latex_symbols = {
    enabled = true,
    name = "latex_symbols",
    module = "blink.compat.source",
    should_show_items = function(ctx, _items)
        return vim.bo[ctx.bufnr].filetype ~= "tex"
    end,
}

---
--- === LSP ===
---

local server = "ltex_plus"
---@class OLLang
CFG.lang = {
    ---@type table<string, string>
    paths = {
        base = vim.fs.joinpath(vim.fn.stdpath("config"), "lang"),
    },
    ---@type string
    language = "en-AU",
    ---@type string[]
    dictionary = {},
    ---@type string[]
    disabled_rules = {},
    ---@type string[]
    hidden_false_positives = {},
}

---@enum (key) OLLangSetting
local settings = {
    dictionary = "dictionary",
    disabled_rules = "disabledRules",
    hidden_false_positives = "hiddenFalsePositives",
}
CFG.lang.settings = settings

function CFG.lang.init()
    vim.fn.mkdir(CFG.lang.paths.base, "p")

    for setting, _ in pairs(CFG.lang.settings) do
        local filepath = vim.fs.joinpath(
            CFG.lang.paths.base,
                string.format("%s.%s.txt", CFG.lang.language, setting)
        )
        CFG.lang.paths[setting] = filepath
        if not vim.uv.fs_stat(filepath) then
            local file = io.open(filepath, "w")
            if file then
                file:write("")
                file:close()
            end
        end
        for line in io.lines(filepath) do
            if not vim.tbl_contains(CFG.lang[setting], line) then
                table.insert(CFG.lang[setting], line)
            end
        end
        CFG.lsp.servers[server].settings.ltex[CFG.lang.settings[setting]] = {
            [CFG.lang.language] = CFG.lang[setting],
        }
        CFG.lang.update(setting)
    end
end

---@param setting OLLangSetting
---@param client_id? integer
function CFG.lang.update(setting, client_id)
    vim.schedule(
        function()
            local filepath = CFG.lang.paths[setting]
            local file = io.open(filepath, "w")
            if file then
                for _, line in ipairs(CFG.lang[setting]) do
                    file:write(line)
                end
                file:close()
            end
            if client_id ~= nil then
                local client = vim.lsp.get_client_by_id(client_id)
                if client then
                    client.config.settings.ltex[CFG.lang.settings[setting]] = {
                        [CFG.lang.language] = CFG.lang[setting],
                    }
                    client:notify(
                        "workspace/didChangeConfiguration",
                            client.config.settings
                    )
                end
            end
        end
    )
end

---@param command lsp.Command
---@param ctx table
function CFG.lang.add_to_dictionary(command, ctx)
    local args = command.arguments[1].words
    for _, words in pairs(args) do
        for _, word in ipairs(words) do
            table.insert(CFG.lang.dictionary, word)
        end
    end
    CFG.lang.update("dictionary", ctx.client_id)
end

---@param command lsp.Command
---@param ctx table
function CFG.lang.hide_false_positives(command, ctx)
    local args = command.arguments[1].falsePositives
    for _, rules in pairs(args) do
        for _, rule in ipairs(rules) do
            table.insert(CFG.lang.hidden_false_positives, rule)
        end
    end
    CFG.lang.update("hidden_false_positives", ctx.client_id)
end

---@param command lsp.Command
---@param ctx table
function CFG.lang.disable_rules(command, ctx)
    local args = command.arguments[1].ruleIds
    for _, rules in pairs(args) do
        for _, rule in ipairs(rules) do
            table.insert(CFG.lang.disabled_rules, rule)
        end
    end
    CFG.lang.update("disabled_rules", ctx.client_id)
end

table.insert(CFG.mason.ensure_installed.lsp, server)
---@type vim.lsp.Config
CFG.lsp.servers[server] = {
    before_init = function(_params, _config)
        CFG.lang.init()
    end,
    commands = {
        ["_ltex.addToDictionary"] = CFG.lang.add_to_dictionary,
        ["_ltex.hideFalsePositives"] = CFG.lang.hide_false_positives,
        ["_ltex.disableRules"] = CFG.lang.disable_rules,
    },
    settings = {
        ltex = {
            language = CFG.lang.language,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = CFG.lang.language,
            },
            completionEnabled = true,
            checkFrequency = "save",
            diagnosticSeverity = "hint",
        },
    },
}
CFG.lang.init()

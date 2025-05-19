local snacks = CFG.spec:add("folke/snacks.nvim")

snacks.priority = 1000
snacks.cond = true
snacks.lazy = false
local modules = {
    "animate",
    "bigfile",
    "indent",
    "input",
    "notifier",
    "notify",
    "picker",
    "quickfile",
    "rename",
    "scope",
    "scratch",
    "scroll",
    "statuscolumn",
    "terminal",
    "toggle",
    "words",
}

if CFG.profile then
    table.insert(modules, "profiler")
end

for _, module in ipairs(modules) do
    snacks = require("Plugins.snacks." .. module).setup(snacks)
end

CFG.colourscheme:set("snacks")

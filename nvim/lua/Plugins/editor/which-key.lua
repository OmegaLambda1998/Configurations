local wk = CFG.spec:add("folke/which-key.nvim")
---@module "which-key"

wk.event = {
    "VeryLazy",
}

---@type wk.Opts
wk.opts = {
    preset = "helix",
    delay = 0,
    defer = function()
        return false
    end,
    win = {
        title_pos = "right",
    },
}

wk.post:insert(
    function()
        function CFG.key:create(map)
            require("which-key").add(map)
        end
        CFG.key:setup()
    end
)

CFG.colourscheme:set("which_key")

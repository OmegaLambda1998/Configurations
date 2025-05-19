local Config = require("ConfigHelper.config")

---Notification utilities
---@class Logging: Config
---
---@field level integer
---@field inspect fun(obj: ...): msg: table<string>, title: string
---@field notify_fn fun(msg: any, opts: table)
---@field notify fun(self: Logging, msg: any, opts?: table)
local Logging = {}
Logging.interface = {}
Logging.schema = {}
Logging.metatable = {
    __index = Logging.schema,
}

---Notifications Constructor
---@param self Logging
---@param verbose boolean
---@return Logging
function Logging.prototype(self, verbose)
    self.level = (verbose and vim.log.levels.DEBUG) or vim.log.levels.INFO
    self.notify_fn = function(msg, opts)
        vim.notify(msg, opts.level or self.level, opts)
    end
    return self
end

---Create a new Notifications instance
---@param verbose boolean
---@return Logging
function Logging.interface.new(verbose)
    local self = setmetatable(Config.interface.new(), Logging.metatable)
    Logging.prototype(self, verbose)
    return self
end

--- Notifications Class Methods ---

---Better vim.inspect, stolen from snacks.debug
---@param ... any
---@return table<string> msg
---@return string title
function Logging.schema.inspect(...)
    local obj = {
        ...,
    }
    local caller = debug.getinfo(1, "S")
    for level = 2, 100 do
        local info = debug.getinfo(level, "S")
        if info ~= nil then
            if info.what == "Lua" and info.source ~= "lua" and
                not info.source:find("@" .. vim.fn.stdpath("config"), 0, true) then
                caller = info
                break
            end
        else
            break
        end
    end
    local title = vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" ..
                      caller.linedefined
    ---@type table<string>
    local str = {}
    for _, o in ipairs(obj) do
        if type(o) ~= "string" then
            o = vim.inspect(o)
        end
        table.insert(str, o)
    end

    return str, title
end

---Send a notification
---@param self Logging
---@param msg any
---@param opts? table
function Logging.schema.notify(self, msg, opts)
    local notfiy_msg, title = self.inspect(msg)
    local notfiy_opts = vim.tbl_deep_extend(
        "force", opts or {}, {
            title = title,
        }
    )
    self.notify_fn(notfiy_msg, notfiy_opts)
end

return Logging.interface

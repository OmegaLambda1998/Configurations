local Config = require("ConfigHelper.config")

---Notification utilities
---@class Logging: Config
---
---@field level integer
---@field inspect fun(obj: ...): msg: string
---@field notify_fn fun(msg: string, opts: table)
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
---@return string msg
function Logging.schema.inspect(...)
    local obj = {
        ...,
    }
    ---@type table<string>
    local str = {}
    for _, o in ipairs(obj) do
        if type(o) ~= "string" then
            o = vim.inspect(o)
        end
        table.insert(str, o)
    end

    return table.concat(str, "\n")
end

---Send a notification
---@param self Logging
---@param msg any
---@param opts? table
function Logging.schema.notify(self, msg, opts)
    if type(msg) == "table" and #msg == 1 then
        msg = msg[1]
    end
    local notify_msg = self.inspect(msg)
    local notfiy_opts = opts or {}
    if notfiy_opts.level == nil then
        notfiy_opts.level = vim.log.levels.INFO
    end
    self.notify_fn(notify_msg, notfiy_opts)
end

return Logging.interface

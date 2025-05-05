--- Session
--- Allows cross-instance yank
require("session"):setup(
    {
        sync_yanked = true,
    }
)

--- Full Border
--- Add a full border to yazi
require("full-border"):setup(
    {
        type = ui.Border.ROUNDED,
    }
)

--- MTP
--- Allow mounting android phone
require("simple-mtpfs"):setup({})

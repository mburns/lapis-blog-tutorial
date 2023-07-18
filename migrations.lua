--- Migrations
-- @script migrations

local db     = require "lapis.db"
local json = require("cjson")

-- local Users = require("src.models.users")

-- add each incremental migration whose key is the unix timestamp
return {
  -- create initial tables: Users, Subreddits
  [1] = function()
    -- TODO
  end,

  -- classify text : https://github.com/leafo/lapis-bayes
  [1439944992] = require("lapis.bayes.schema").run_migrations,
}

local config = require("lapis.config")

config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1",

  session_name = "lapis-tutorial-blog",
  sqlite = {
    database = "dev.sqlite",
    -- open_flags = ...
  }
})

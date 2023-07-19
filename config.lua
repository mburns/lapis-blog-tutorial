--- Pagesix config
-- @script pagesix.config

local config    = require "lapis.config"

-- Maximum file size
local body_size = "1m"

-- Path to your local project files
local lua_path  = "./src/?.lua;./src/?/init.lua;./libs/?.lua;./libs/?/init.lua"
local lua_cpath = ""

-- TODO shared dev+prod config
-- config({"development", "production"}, {
-- 	port                = 80,
-- body_size           = body_size,
-- lua_path            = lua_path,
-- lua_cpath           = lua_cpath,
-- server              = "nginx",
-- })

config("development", {
	port                = 80,
	body_size           = body_size,
	lua_path            = lua_path,
	lua_cpath           = lua_cpath,
	server              = "nginx",
	code_cache          = "off",
	num_workers         = "1",
	name                = "[DEVEL] Lapis Tutorial Blog",
	session_name        = "lapis_tutorial_blog",
	secret              = "hunter42", -- TODO: manage Secrets
	measure_performance = true,
	sqlite              = {
		database = "/var/data/dev.sqlite"
		-- open_flags = ...
	}
})

config("production", {
	port         = 80,
	body_size    = body_size,
	lua_path     = lua_path,
	lua_cpath    = lua_cpath,
	code_cache   = "on",
	server       = "nginx",
	num_workers  = "3",
	name         = "Lapis Tutorial Blog",
	session_name = "lapis_tutorial_blog",
	secret       = os.getenv("LAPIS_SECRET"),
	logging      = {
		requests = true,
		queries  = false,
		server   = true
	},
	sqlite       = {
		database = "/var/data/production.sqlite"
	}
})

--- Lapis Tutorial Blog
-- @script blog
-- @author Michael Burns
-- @license Apache License v2.0

local lapis          = require "lapis"
local r2             = require("lapis.application").respond_to
local after_dispatch = require("lapis.nginx.context").after_dispatch
local to_json        = require("lapis.util").to_json
local console        = require("lapis.console")

local app            = lapis.Application()


app:before_filter(function(self)
	after_dispatch(function()
		-- https://leafo.net/lapis/reference/configuration.html#performance-measurement
		print(to_json(ngx.ctx.performance))
	end)
end)

function app:default_route()
	ngx.log(ngx.NOTICE, "User hit unknown path " .. self.req.parsed_url.path)

	-- call the original implementaiton to preserve the functionality it provides
	return lapis.Application.default_route(self)
end

function app:handle_404()
	error("Failed to find route: " .. self.req.request_uri)
	return { status = 404, layout = true, "Not Found!" }
end

app:enable("etlua")

app.layout = require "views.layout"

app:get("/", function()
	return "Welcome to Lapis " .. require("lapis.version")
end)

app:match("/console", console.make()) -- only available in Development builds

return app

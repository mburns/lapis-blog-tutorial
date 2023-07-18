package = "blog"
version = "dev-1"

source = {
  url = "git+https://github.com/mburns/lapis-tutorial-blog.git"
}

description = {
  summary = "Reddit clone",
  detailed = [[
  ]],
  homepage = "https://github.com/mburns/lapis-tutorial-blog",
  maintainer = "Michael Burns <michael@mirwin.net>",
  license = "Apache"
}

dependencies = {
  "busted",

  "lua ~> 5.1",
  "moonscript",
  "bcrypt",
  "luabitop",
  "argparse", -- needed for some cmd scripts

  "lapis == 1.14.0",

  "lapis-bayes ~> 1.2",
  "lapis-console ~> 1.2",
  "lapis-redis ~> 1.0",
  "lapis-annotate ~> 2.0",
  "web_sanitize ~> 1.4",
  "tableshape >= 2.6",
  "sitegen ~> 0.2",
  "luajit-geoip ~> 2.1",
  "http ~> 0.4",

  "basexx",
  "cmark",
  "lpeg",
  "lpeg_patterns",
  "lrandom",
  "lsqlite3",
  "markdown",
  "redis-lua",
  "feedparser",
  "lua-silva",
  "luaossl",
  "lua-resty-mail",
  "luasocket",
  "lua-resty-http",
  "lua-cjson",
  "luasec",
  "inspect",
  "luaexpat",
}

build = {
  type = "none",
}

module = @
require "fy"
require("events").EventEmitter.defaultMaxListeners = Infinity
argv = require("minimist")(process.argv.slice(2))
config = Object.assign(require("dotenv-flow").config().parsed || {}, process.env)
for k,v of argv
  config[k.toUpperCase()] = v

bool = (name, default_value = "0", config_name = name.toUpperCase())->
  module[name] = !!+(config[config_name] ? default_value)

int  = (name, default_value = "0", config_name = name.toUpperCase())->
  module[name] = +(config[config_name] ? default_value)

str  = (name, default_value = "", config_name = name.toUpperCase())->
  module[name] = config[config_name] ? default_value

str_list  = (name, default_value = "", config_name = name.toUpperCase())->
  module[name] = (config[config_name] ? default_value).split(",").filter (t)->t != ""

# ###################################################################################################
#    common
# ###################################################################################################
str  "front_title", "hello world webcom"
bool "debug"
bool "watch"

# ###################################################################################################
#    front
# ###################################################################################################
int  "front_http_port", "10000"
int  "front_ws_port",   "20000"
bool "http_query_array_support"

# ###################################################################################################
#    backend
# ###################################################################################################
int "back_http_port", "3100"
int "back_ws_port",   "3101"

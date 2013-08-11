local args 	= ngx.req.get_uri_args()
local event = args["event"]

if event == nil then
	ngx.log(ngx.INFO, "no event passed");
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local redis = require "resty.redis"
local red = redis:new()

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.CRIT, "failed to connect to redis (", err, ")")
	return ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

ok, err = red:rpush("meteorit-queue", event)
if not ok then
    ngx.log(ngx.ERR, "failed to add event to redis (", err, ")")
	return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local ok, err = red:set_keepalive(0, 100)
if not ok then
	ngx.say("failed to set keepalive: ", err)
	return
end

ngx.say("OK")

 local args 	= ngx.req.get_uri_args()
local event = args["event"]
local testKey = "___meteorit-test-key"

if event == nil then
	ngx.log(ngx.ERR, "no event passed to test");
	ngx.exit(ngx.HTTP_BAD_REQUEST)
end 


local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("127.0.0.1", 6379)
if not ok then
    ngx.log(ngx.CRIT, "failed to connect to redis (", err, ")")
	return ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
end

ok, err = red:set(testKey, event)
if not ok then
    ngx.log(ngx.ERR, "failed to set test value to redis (", err, ")")
	return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local res, err = red:get(testKey)
if not res then
    ngx.log(ngx.ERR, "failed to set test value to redis (", err, ")")
	return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end
     
ngx.say(res)

local ok, err = red:del(testKey)
if not ok then
    ngx.log(ngx.ERR, "failed to set test value to redis (", err, ")")
	return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local ok, err = red:close()
if not ok then
    ngx.log(ngx.ERR, "failed to close (", err, ")")
	return
end
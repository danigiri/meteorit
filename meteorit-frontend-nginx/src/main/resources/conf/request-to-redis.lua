local parser = require "redis.parser"
 
local args 	= ngx.req.get_uri_args()
local event = args["event"]

if event == nil then
	ngx.log(ngx.ERR, "no event passed to test");
	ngx.exit(500)
end 
 
local reqs = {
 	{"rpush", "meteorit-queue", event},
}
 
local raw_reqs = {}
for i, req in ipairs(reqs) do
	table.insert(raw_reqs, parser.build_query(req))
end
 
-- res contains .status, .body and .header
local res = ngx.location.capture("/redis2-connect?" .. #reqs,
	{ body = table.concat(raw_reqs, "") })

if res.status ~= 200 or not res.body then
	ngx.log(ngx.ERR, "failed to query redis")
	ngx.exit(500)
end
 
ngx.say("OK")

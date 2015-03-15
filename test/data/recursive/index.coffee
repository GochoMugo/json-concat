lodash = require "lodash"

result = { }

c = require "./c.json"
d = require "./a/d.json"
e = require "./a/b/e.json"


exports = module.exports = lodash.assign(result, c, d, e)

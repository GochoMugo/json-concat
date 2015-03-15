lodash = require "lodash"


a = require "./a.json"
b = {} # b.json has "bad" json


result = { }


exports = module.exports = lodash.assign(result, a, b)

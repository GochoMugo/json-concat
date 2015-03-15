fs = require("fs")
lodash = require("lodash")

result = { }
files = fs.readdirSync(__dirname)


for filename in files
    continue if filename is "index.js"
    lodash.assign(result, require("./" + filename))


exports = module.exports = result

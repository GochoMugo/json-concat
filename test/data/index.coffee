fs = require("fs")
lodash = require("lodash")

result = { }
files = fs.readdirSync(__dirname)


for index in files
    filename = files[index]
    continue if filename is "index.js"
    lodash.assign(result, require("./" + filename))


exports = module.exports = result

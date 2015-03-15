fs = require("fs")
lodash = require("lodash")

result = { }
files = fs.readdirSync(__dirname)


for (index in files)
    filename = files[index]
    if (filename === "index.js") { continue }
    lodash.assign(result, require("./" + filename))


exports = module.exports = result

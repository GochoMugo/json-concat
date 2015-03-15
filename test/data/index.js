var fs = require("fs");
var lodash = require("lodash");

var result = { };

var files = fs.readdirSync(__dirname);
for (var index in files) {
    var filename = files[index];
    if (filename === "index.js") { continue; }
    lodash.assign(result, require("./" + filename);)
}


exports = module.exports = result;

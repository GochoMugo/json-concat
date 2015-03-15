var lodash = require("lodash");

var result = { };

var c = require("./c.json");
var d = require("./a/d.json");
var e = require("./a/b/e.json");


exports = module.exports = lodash.assign(result, c, d, e);

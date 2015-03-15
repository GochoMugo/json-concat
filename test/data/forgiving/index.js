var lodash = require("lodash");


var a = require("./a.json");
var b = {}; // b has "bad" json


var result = { };


exports = module.exports = lodash.assign(result, a, b);

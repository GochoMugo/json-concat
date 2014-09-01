#! /usr/bin/env node

(function() {
  var jsonConcat, options;

  jsonConcat = require("./json-concat");

  if (process.argv.length === 2) {
    process.stdout.write("\nUsage: json-concat file1.json file2.json dir1 dir2 ... output.json\n\n");
  } else if (process.argv.length === 3) {
    process.stdout.write("\nNo need to concatenate\n\n");
  } else {
    options = {};
    options.src = process.argv;
    options.src.shift();
    options.src.shift();
    options.dest = options.src.pop();
    jsonConcat(options, function(json) {
      return process.stdout.write("\nConcatenated to: " + options.dest + "\n\n");
    });
  }

}).call(this);

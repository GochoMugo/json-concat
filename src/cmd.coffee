#! /usr/bin/env node


jsonConcat = require "./json-concat"


if process.argv.length is 2
    # No argument passed
    process.stdout.write "\nUsage: json-concat file1.json file2.json dir1 dir2 ... output.json\n\n"
else if process.argv.length is 3
    # Only one filename passed
    process.stdout.write "\nNo need to concatenate\n\n"
else
    options = {}
    options.src = process.argv
    options.src.shift() # node
    options.src.shift() # file path
    options.dest  = options.src.pop() # destination file
    jsonConcat options, (err, json) ->
        process.stdout.write "\nConcatenated to: #{options.dest}\n\n"

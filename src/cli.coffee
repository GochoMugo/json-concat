"use strict"

jsonConcat = require "./json-concat"

exports = module.exports = () ->

    if process.argv.length is 2
        # No argument passed
        process.stdout.write "\nUsage: json-concat file1.json file2.json dir1 dir2 ... output.json\n\n"
    else if process.argv.length is 3
        # Only one filename passed
        process.stderr.write "\nNo need to concatenate\n\n"
        process.exit(1)
    else
        options = { }
        options.src = process.argv.slice()
        options.src.shift() # node
        options.src.shift() # file path
        options.dest = options.src.pop() # destination file
        jsonConcat options, (err, json) ->
            if err
                process.stderr.write "Error occurred: %s", err
                process.exit 1

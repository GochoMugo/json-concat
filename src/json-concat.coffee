###

Concatenating Json Objects

Author: @mugo_gocho <mugo@forfuture.co.ke>
License: MIT

###

###

Notes:

1. A result object is reused in order to avoid creating many arrays
   then have to join them together. This makes it faster.
###



# Built-in modules
fs = require "fs"
path = require "path"


###
Concatenates content from all JSON files encountered
This is recursive and will go into directories looking for files with
the extension ".json"

@param <filepath> - {String} path to file/directory
@param <resultObject> - {Object} object that will hold the result (see note 1)
@param <callback> - {Function} callback(content, contentArray)
###
readContent = (filepath, resultObject, callback) ->
    filesEncountered = 0
    filesProcessed = 0
    resultObject.contentString ?= ""
    resultObject.contentArray ?= []

    encounteredFile = () -> filesEncountered++
    processedFile = (fileContent="") ->
        resultObject.contentString += fileContent
        resultObject.contentArray.push(fileContent) if fileContent
        filesProcessed++
        callback(resultObject) if filesProcessed is filesEncountered

    read = (filepath) ->
        encounteredFile()
        fs.stat filepath, (err, stats) ->
            # could not get stats, quit on the file and move on
            return processedFile(null) if err
            if stats.isDirectory()
                # directory. read it files. using recursion
                fs.readdir filepath, (err, files) ->
                    # quit on the directory. couldnt get list of files in it
                    return processedFile(null) if err
                    # loop thru each file and process it
                    for file in files
                        read path.join(filepath, file)
                    # we done with this directory so we quit on it
                    processedFile(null)
            else if stats.isFile()
                if path.extname(filepath) is ".json"
                    # file. read it content and concatenate it
                    fs.readFile filepath, { encoding: "utf8" }, (err, content) ->
                        # quit on the file. couldnt read it
                        return processedFile(null) if err
                        processedFile(content)
                else
                    processedFile(null)

    # start the process
    read(filepath)


###
Creates a new JSON object from a string of concatenated stringified
JSON objects.

@param <string> - {String} string of json
@param <callback> - {Function} callback(validString, validObject)
###
concat = (contentString, contentArray, callback) ->
    return callback("{}", {}) if contentString is ""
    # using algorithm 1 (faster, not forgiving)
    string = contentString.replace /^({\s*})*|({\s*})*$/g, ""
    string = string.replace /}\s*({\s*})*\s*{/g, ","
    string = string.replace /}\s*{/g, ","
    try
        callback(string, JSON.parse(string))
    catch err
        # we use algorithm 2 (slower, forgiving)
        result = { }
        for content in contentArray
            try
                tmp = JSON.parse(content)
                for key, value of tmp
                    result[key] = value
            catch err
        callback(JSON.stringify(result), result)


###
exported function
###
exports = module.exports = (userOptions, callback) ->

    # options
    options =
        src: userOptions.src || process.cwd()
        dest: userOptions.dest || "./concat.json"
        middleware: userOptions.middleware || false

    # ensure `null` is respected for options.dest
    if userOptions.dest is null then options.dest = null

    # make options.src an array
    if typeof(options.src) is "string" then options.src = [options.src]

    result = { }
    index = 0
    start = (callback) ->
        next = () ->
            readContent options.src[index], result, () ->
                ++index
                return next() if index < options.src.length
                concat result.contentString, result.contentArray, (string, obj) ->
                    if options.dest
                        fs.writeFile options.dest, string, (err) ->
                            callback(err, obj)
                    else
                        callback(null, obj)
        next()

    # in a connect/express app
    if options.middleware
        return (req, res, next) ->
            start((err, obj) -> next(obj || {}))
    else
        return start(callback)

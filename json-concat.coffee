###

Concatenating Json Objects

Author: @mugo_gocho <mugo@forfuture.co.ke>
License: MIT

###


# Requires
events = require "events"
fs = require "fs"
path = require "path"


# Global Variables
emitter = new events.EventEmitter()
emitter.setMaxListeners 0


# Exports
module.exports = ->
    callback = null

    # Looking for Callback
    index = 0
    while (index < arguments.length)
        if typeof arguments[index] is "function"
            callback = arguments[index]
            break
        index++

    # Once function is completed, execute callback
    target = 0
    done = 0
    collectJson = []
    emitter.on "done", (json) ->
        done++
        if json? then collectJson[collectJson.length] = json
        if done is target
            result = concat collectJson
            if callback? then callback result
            emitter.emit "complete", result
    emitter.on "more", ->
        target++

    if arguments.length is 1 or arguments.length is 2 and callback?
        target = 0

        # default options
        options =
            src: "."
            dest: "./concat.json"
            middleware: false

        # Getting the passed options
        if arguments[0].src? then options.src = arguments[0].src
        if arguments[0].dest? then options.dest = arguments[0].dest
        if arguments[0].middleware? then options.middleware = arguments[0].middleware

        # invokes reading of files and listens for completion
        readAndWrite = ->
            # listen for completion so we could write to file
            emitter.on "complete", (json) ->
                if options.dest? then fs.writeFile options.dest, JSON.stringify json
                emitter.emit "next"

            # if an array, pass thru it. Else just pass it as is
            if typeof options.src is "object"
                for path in options.src
                    jsonFromFile path
            else
                jsonFromFile options.src

        if options.middleware
            # in a connect/express app
            (req, res, next) ->
                emitter.on "next", ->
                    next()
                    emitter.removeAllListeners "next"
                readAndWrite()
        else
            # non-connect/non-express app
            readAndWrite()


# concatenates json objects in an array
concat = (objs) ->
    if objs.length isnt 0
        string = ""
        for obj in objs
            string += JSON.stringify obj
        string = string.replace /^({})*|({})*$/g, ""
        string = string.replace /}({})*{/g, ","
        string = string.replace /}{/g, ","
        result = JSON.parse string
    else
        result = ""


# Reads a file asynchronously and returns a JSON object if any.
# If a folder is encountered, reads the .json files in it
jsonFromFile = (filename) ->
    emitter.emit "more"

    fs.stat filename, (err, stats) ->
        if err
            # could not get stats, quit on the file and move on
            emitter.emit "done", null
        else
            if stats.isDirectory()
                # directory. read it files. using recursion
                fs.readdir filename, (err, files) ->
                    if err
                        # quit on the directory. couldnt get list of files in it
                        emitter.emit "done", null
                    else
                        # loop thru each file and recurse it
                        for file in files
                            if path.extname(file) is ".json"
                                jsonFromFile path.resolve(filename, file)

                        # we done with this folder so we quit on it
                        emitter.emit "done", null

            else if stats.isFile()
                # file. read it content and get json from it
                fs.readFile filename, (err, content) ->
                    if err
                        # quit on the file. couldnt read it
                        emitter.emit "done", null
                    else
                        try
                            # we read the file, lets try parse it
                            json = JSON.parse content
                            emitter.emit "done", json
                        catch e
                            # json could not be parsed
                            emitter.emit "done", null
            else
                # other file types, we dont consider them
                emitter.emit "done", null

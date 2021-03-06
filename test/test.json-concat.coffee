"use strict"


# built-in modules
fs = require "fs"
path = require "path"


# npm-installed modules
lodash = require "lodash"
should = require "should"


# own modules
jsonConcat = require "../lib/json-concat"


describe "jsonConcat", () ->

    it "is a function that can be called immediately", () ->
        should(jsonConcat).be.a.Function

    it "is recursive", (done) ->
        correct_result = require("./data/recursive")
        jsonConcat
            src: path.join(__dirname, "data/recursive"),
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()

    it "is forgiving", (done) ->
        correct_result = require("./data/forgiving")
        jsonConcat
            src: path.join(__dirname, "data/forgiving"),
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()


describe "jsonConcat options", () ->

    it ".src may be a path pointing to a directory", (done) ->
        correct_result = require("./data/dir")
        jsonConcat
            src: path.join(__dirname, "data/dir"),
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()

    it ".src may be a path pointing to a file", (done) ->
        correct_result = require("./data/file.json")
        jsonConcat
            src: path.join(__dirname, "data/file.json"),
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()

    it ".src may be an array of filepaths", (done) ->
        correct_result = require("./data/recursive")
        jsonConcat
            src: [
                path.join(__dirname, "data/recursive/a"),
                path.join(__dirname, "data/recursive/c.json")
            ],
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()

    it ".src may be an array with object(s)", (done) ->
        correct_result = lodash.cloneDeep(require "./data/file.json")
        correct_result["awesome"] = true
        jsonConcat
            src: [
                path.join(__dirname, "data/file.json"),
                awesome: true
            ],
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()

    it.skip ".src defaults to cwd if not defined", (done) ->
        correct_result = require("./data")
        jsonConcat { dest: null }, (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            done()

    it ".dest defines file to write to", (done) ->
        correct_result = require("./data/file.json")
        destpath = path.join __dirname, "dest.json"
        jsonConcat
            src: path.join(__dirname, "data/file.json"),
            dest: destpath
        , (err, json) ->
            should(err).not.be.ok
            should(json).eql(correct_result)
            should(require(destpath)).eql(correct_result)
            done()

    it.skip ".dest must be a string", (done) ->
        nonStrings = [[], [1] , 0, 1, true, false, {},
            { "0": "1"}, () -> { }]
        index = 0
        next = () ->
            if (index is nonStrings.length)
                return done()
            jsonConcat dest: nonStrings[index], (err) ->
                should(err).be.ok
                next()
        next()

    it ".dest may be assigned `null` to have no file written to", (done) ->
        defaultPath = __dirname + "/concat.json"
        if (fs.existsSync(defaultPath))
            fs.unlinkSync(defaultPath)
        jsonConcat
            src: path.join(__dirname, "/data/file.json"),
            dest: null
        , (err, json) ->
            should(err).not.be.ok
            should(fs.existsSync(defaultPath)).eql(false)
            done()

    it ".dest defaults to 'concat.json' if not defined", (done) ->
        defaultPath = path.join process.cwd(), "concat.json"
        if (fs.existsSync(defaultPath))
            fs.unlinkSync(defaultPath)
        correct_result = require("./data/file.json")
        jsonConcat
            src: path.join(__dirname, "data/file.json")
        , (err, json) ->
            should(err).not.be.ok
            should(require(defaultPath)).eql(correct_result)
            done()

    it ".middleware, if true, makes it be usable in Connect/Express", (done) ->
        correct_result = require("./data/file.json")
        destpath = path.join __dirname, "middleware.json"
        middlewareFunc = jsonConcat 
            src: path.join(__dirname, "data/file.json"),
            dest: destpath,
            middleware: true
        req = { }
        res = { }
        next = () ->
            should(require(destpath)).eql(correct_result)
            return done()
        middlewareFunc(req, res, next)


describe "jsonConcat callback", () ->

    it "is passed an error object, if error occurs"

    it "is passed `null` in place of error object if no error occurs"

    it "is passed a JSON object if successful"

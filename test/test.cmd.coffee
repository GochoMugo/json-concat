"use strict"


# built-in modules
fs = require "fs"


# npm-installed modules
shelljs = require "shelljs"
should = require "should"


# module variables
cmd = "node dist/cmd.js "


# wrap qoutes around a path incase it has spaces
wrap = (filepath) ->
    "\"" + filepath + "\""


describe "json-concat command", () ->
    this.timeout 0

    it "ignores if only one arg is passed", (done) ->
        outputFile = process.cwd() + "/_test_ignore.json"
        fs.unlinkSync(outputFile) if fs.existsSync(outputFile)
        ret = shelljs.exec cmd + wrap(outputFile), (code, output) ->
            should(code).eql(0)
            should(fs.existsSync(outputFile)).eql(false)
            should(output).containEql("No need")
            done()

    it "assumes last arg is the output file", (done) ->
        outputFile = process.cwd() + "/_test_finalFile.json"
        fs.unlinkSync(outputFile) if fs.existsSync(outputFile)
        ret = shelljs.exec cmd + 
            wrap(__dirname + "/data/recursive/c.json") + " " +
            wrap(__dirname + "/data/recursive/a") + " " +
            wrap(outputFile), (code, output) ->
                should(code).eql(0)
                data = fs.readFileSync(outputFile, encoding: "utf8")
                should(JSON.parse(data)).eql(require("./data/recursive"))
                done()

    it "shows usage information if no arg is passed", (done) ->
        ret = shelljs.exec cmd, (code, output) ->
            should(code).eql(0)
            should(output).containEql("Usage")
            done()

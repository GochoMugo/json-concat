"use strict"


# built-in modules
fs = require "fs"
path = require "path"


# npm-installed modules
shelljs = require "shelljs"
should = require "should"


# module variables
# this space at the end is important as we will concatenate arguments
cmd = "node bin/json-concat "


# wrap qoutes around a path incase it has spaces
wrap = (filepath) ->
    "\"" + filepath + "\""


describe "json-concat command", () ->
    this.timeout 0

    it "exit with an error if only one arg is passed", (done) ->
        outputFile = path.join process.cwd(), ".test/ignore.json"
        fs.unlinkSync(outputFile) if fs.existsSync(outputFile)
        ret = shelljs.exec cmd + outputFile, (code, output) ->
            should(code).eql(1)
            should(fs.existsSync(outputFile)).eql(false)
            should(output).containEql("No need")
            done()

    it "assumes last arg is the output file", (done) ->
        outputFile = path.join process.cwd(), ".test/final_file.json"
        fs.unlinkSync(outputFile) if fs.existsSync(outputFile)
        ret = shelljs.exec cmd +
            path.join(__dirname, "data/recursive/c.json") + " " +
            path.join(__dirname, "data/recursive/a") + " " +
            outputFile, (code, output) ->
                should(code).eql(0)
                data = fs.readFileSync(outputFile, encoding: "utf8")
                should(JSON.parse(data)).eql(require("./data/recursive"))
                done()

    it "shows usage information if no arg is passed", (done) ->
        ret = shelljs.exec cmd, (code, output) ->
            should(code).eql(0)
            should(output).containEql("Usage")
            done()

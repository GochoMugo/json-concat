"use strict";


// built-in modules
var fs = require("fs");


// npm-installed modules
var should = require("should");


// own modules
var jsonConcat = require("../dist/json-concat");


describe("jsonConcat", function() {

    it("is a function that can be called immediately", function() {
        should(jsonConcat).be.a.Function;
    });

    it("is recursive", function(done) {
        var correct_result = require("./data/recursive");
        jsonConcat({
            src: "data/recursive",
            dest: null
        }, function(err, json) {
            should(err).not.be.ok;
            should(json).eql(correct_result);
            done();
        });
    });

    it("is forgiving", function(done) {
        var correct_result = require("./data/forgiving");
        jsonConcat({
            src: "data/forgiving",
            dest: null
        }, function(err, json) {
            should(err).be.ok;
            should(json).eql(correct_result);
            done();
        });
    });

});


describe("jsonConcat options", function() {

    it(".src may be a path pointing to a directory", function(done) {
        var correct_result = require("./data/dir");
        jsonConcat({
            src: "data/dir",
            dest: null
        }, function(err, json) {
            should(err).not.be.ok;
            should(json).eql(correct_result);
            done();
        });
    });

    it(".src may be a path pointing to a file", function(done) {
        var correct_result = require("./data/file.json");
        jsonConcat({
            src: "data/file.json",
            dest: null
        }, function(err, json) {
            should(err).not.be.ok;
            should(json).eql(correct_result);
            done();
        });
    });

    it(".src may be an array of filepaths", function(done) {
        var correct_result = require("./data/recursive");
        jsonConcat({
            src: ["./data/recursive/a", "./data/recursive/c.json"],
            dest: null
        }, function(err, json) {
            should(err).not.be.ok;
            should(json).eql(correct_result);
            done();
        });
    });

    it(".src defaults to cwd if not defined", function(done) {
        var correct_result = require("./data");
        jsonConcat({ dest: null }, function(err, json) {
            should(err).not.be.ok;
            should(json).eql(correct_result);
            done();
        });
    });

    it(".dest defines file to write to", function(done) {
        var correct_result = require("./data/file.json");
        var destpath = "./_test_dest.json";
        jsonConcat({
            src: "./data/file.json",
            dest: destpath
        }, function(err, json) {
            should(err).not.be.ok;
            should(json).eql(correct_result);
            should(require(destpath)).eql(correct_result);
            done();
        });
    });

    it(".dest must be a string", function(done) {
        var nonStrings = [[], [1] , 0, 1, true, false, {},
            { "0": "1"}, function() { }];
        var index = 0;
        next();

        function next() {
            if (index === nonStrings.length) { return done(); }
            jsonConcat({ dest: nonStrings[index] }, function(err) {
                should(err).be.ok;
                next();
            });
        }
    });

    it(".dest may be assigned `null` to have no file written to", function(done) {
        jsonConcat({
            src: "./data/file.json",
            dest: null
        }, function(err, json) {
            should(err).not.be.ok;
            should(fs.existsSync("./concat.json")).eql(false);
            done();
        });
    });

    it(".dest defaults to 'concat.json' if not defined", function(done) {
        if (fs.existsSync("./concat.json")) {
            fs.unlinkSync("./concat.json");
        }
        var correct_result = require("./data/file.json");
        jsonConcat({ src: "./data/file.json" }, function(err, json) {
            should(err).not.be.ok;
            should(require("./concat.json")).eql(correct_result);
            done();
        });
    });

    it(".middleware, if true, makes it be usable in Connect/Express", function(done) {
        var correct_result = require("./data/file.json");
        var destpath = "_test_middleware.json";
        var middlewareFunc = jsonConcat({
            src:"./data/file.json",
            dest: destpath,
            middleware: true
        });
        var req = { };
        var res = { };
        var next = function() {
            should(require(destpath)).eql(correct_result);
            return done();
        }
        middlewareFunc(req, res, next);
    });

});


describe("jsonConcat callback", function() {

    it("is passed an error object, if error occurs");

    it("is passed `null` in place of error object if no error occurs");

    it("is passed a JSON object if successful");

});

/**
* Run script for Grunt, task runner
*
* The MIT License (MIT)
* Copyright (c) 2014-2015 GochoMugo <mugo@forfuture.co.ke>
*/


exports = module.exports = function(grunt) {
    "use strict";

    grunt.initConfig({
        coffee: {
            options: {
                expand: true,
                flatten: true,
                ext: ".js"
            },
            src: {
                cwd: "src/",
                src: ["*.coffee"],
                dest: "dist/"
            },
            test: {
                cwd: "test/",
                src: ["*.coffee"],
                dest: "dist/"
            }
        },
        copy: {
            dist: {
                expand: true,
                src: ["LICENSE", "README.md", "package.json"],
                dest: "dist/"
            },
            test: {
                expand: true,
                cwd: "test/",
                src: [".jshintrc", "data"],
                dest: "_test/"
          }
        },
        jshint: {
            all: ["Gruntfile.js", "dist/**/*.js", "_test/**/*.js"],
            options: {
                jshintrc: true
            }
        },
        mochaTest: {
            test: {
                options: {
                    reporter: 'spec',
                    quiet: false,
                    clearRequireCache: false
                },
                src: ['_test/test.*.js']
            }
        }
    });

    grunt.loadNpmTasks("grunt-contrib-coffee");
    grunt.loadNpmTasks("grunt-contrib-copy");
    grunt.loadNpmTasks("grunt-contrib-jshint");
    grunt.loadNpmTasks("grunt-mocha-test");

    grunt.registerTask("default", ["coffee:src", "copy:dist"]);
    grunt.registerTask("_test", ["coffee:test", "copy:test"]);
    grunt.registerTask("test", ["default", "_test", "jshint", "mochaTest"]);

};

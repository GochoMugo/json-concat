###
Run script for Grunt, task runner

The MIT License (MIT)
Copyright (c) 2014-2016 GochoMugo <mugo@forfuture.co.ke>
###


exports = module.exports = (grunt) ->
    "use strict"

    grunt.initConfig
        clean:
            test: [".test/", "concat.json"]
        coffee:
            src:
                expand: true,
                flatten: false,
                ext: ".js"
                extDot: "last",
                cwd: "src/",
                src: ["**/*.coffee"],
                dest: "lib/"
            test:
                expand: true,
                flatten: false,
                ext: ".js"
                extDot: "last",
                cwd: "test/",
                src: ["**/*.coffee"],
                dest: ".test/"
        copy:
            test:
                expand: true,
                cwd: "test/",
                src: ["data/**/*", "!data/**/*.coffee"],
                dest: ".test/"
        mochaTest:
            test:
                options:
                    reporter: 'spec',
                    quiet: false,
                    clearRequireCache: false
                src: ['.test/test.*.js']

    grunt.loadNpmTasks("grunt-contrib-clean")
    grunt.loadNpmTasks("grunt-contrib-coffee")
    grunt.loadNpmTasks("grunt-contrib-copy")
    grunt.loadNpmTasks("grunt-mocha-test")

    grunt.registerTask("default", ["coffee:src"])
    grunt.registerTask("test", ["default", "coffee:test", "copy:test", "mochaTest"])

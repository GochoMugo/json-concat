
# json-concat

A [Node.js][nodejs] module for concatenating JSON files and objects. Use in Node.js as __plain module__, in [Connect][connect] and [Express][express] as a __middleware__ and in your terminal as an __executable__.


|Aspect|Detail|
|------|------:|
|Version|0.0.0-alpha|
|Dependencies|None|
|Last Update|2nd Sept 2014|


## Installation

    > npm install json-concat --save

For the latest version with bug fixes and improvements, before a version bump is effected, use ([coffeescript][coffee] is required)(preferable for *nix users):

    > git clone https://github.com/GochoMugo/json-concat
    > cd json-concat
    > make
    > npm install ./dist

To install json-concat onto your command line, you require passing the `-g` flag. You may also require some `sudo` powers to make it work.

    > sudo npm install -g json-concat


## Usage

### In Connect/Express apps

```js

var express    = require("express"),
    app        = express(),
    jsonConcat = require("json-concat");

app.use(jsonConcat({
    src: ["appVars.json", "userVars.json"],
    dest: __dirname + "/config.json",
    middleware: true
}));

```


### In your other apps

```js

var jsonConcat = require("json-concat");

jsonConcat({
    src: ["appVars.json", "userVars.json"],
    dest: "./config.json"
}, function (json) {
    console.log(json);
});

```

### In the Command line

```bash

# As simple as this. Output file should be last
> json-concat file1.json file2.json ouput.json

# for usage tip, invoke with no args
> json-concat


```

## Notes

* The options object passed may have the following keys:
    * **src**:
        * path pointing to a folder
        * array of paths pointing to files or folders
        * defaults to `.` (current working directory)
        * **Note:** if this points to a file, nothing will be done.
    * **dest**: 
        * path pointing to a file in which the JSON output will be written to
        * assign `null` to have no file written to
        * defaults to `./concat.json`
    * **middleware**: `true`/`false`(default). This lets the module know whether it is being used as a middleware or not
* The **callback** receives one argument:
    * **json**: 
        * On Sucess, the concatenated json is passed
        *  On error, the json will be an empty string `""`
* In Connect/Express apps, the concatenation is done on **server requests**
* It is **asynchronous**, the Node.js way
* It is **forgiving**, keeps going even when an error occurs. For example, a non-existent file or syntax errors in json files
* It is **recursive**, following the folders specified. Files with the extension `.json` are considered. Symbolic links are ignored


## Use Cases

In most cases, while building an Express app, you will end up using [jade][jade] as your view engine. Jade allows you to pass a javascript object, which may be JSON, for external variables. Instead of writing all your variables in one file, you may distribute the variables across folders and concatenate them later into one file. Eventually passing it to the jade engine.


## TODO

* Include tests
* Allow Synchronous Execution: be called as a function with splats

```js

    // invoke directly as a function
    var json = jsonConcat("appVars.json", "userVars.json", {"name": "@mugo_gocho"});
    console.log(json);

```

* Get the JSON output in a pretty format i.e. with identations


## License

This Module and its Source code is license under the [MIT License][mit]. View *LICENSE* file accompanying this file.


[nodejs]:https://nodejs.org
[coffee]:https://coffeescript.org
[connect]:https://senchalabs.github.com/connect
[express]:https://expressjs.com
[jade]:https://jade-lang.com
[mit]:https://opensource.org/licenses/MIT

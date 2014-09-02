
/*

Concatenating Json Objects

Author: @mugo_gocho <mugo@forfuture.co.ke>
License: MIT
 */

(function() {
  var concat, emitter, events, fs, jsonFromFile, path;

  events = require("events");

  fs = require("fs");

  path = require("path");

  emitter = new events.EventEmitter();

  emitter.setMaxListeners(0);

  module.exports = function() {
    var callback, collectJson, done, index, options, readAndWrite, target;
    callback = null;
    index = 0;
    while (index < arguments.length) {
      if (typeof arguments[index] === "function") {
        callback = arguments[index];
        break;
      }
      index++;
    }
    target = 0;
    done = 0;
    collectJson = [];
    emitter.on("done", function(json) {
      var result;
      done++;
      if (json != null) {
        collectJson[collectJson.length] = json;
      }
      if (done === target) {
        result = concat(collectJson);
        if (callback != null) {
          callback(result);
        }
        return emitter.emit("complete", result);
      }
    });
    emitter.on("more", function() {
      return target++;
    });
    if (arguments.length === 1 || arguments.length === 2 && (callback != null)) {
      target = 0;
      options = {
        src: ".",
        dest: "./concat.json",
        middleware: false
      };
      if (arguments[0].src != null) {
        options.src = arguments[0].src;
      }
      if (arguments[0].dest != null) {
        options.dest = arguments[0].dest;
      }
      if (arguments[0].middleware != null) {
        options.middleware = arguments[0].middleware;
      }
      readAndWrite = function() {
        var _i, _len, _ref, _results;
        emitter.on("complete", function(json) {
          if (options.dest != null) {
            fs.writeFile(options.dest, JSON.stringify(json));
          }
          return emitter.emit("next");
        });
        if (typeof options.src === "object") {
          _ref = options.src;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            path = _ref[_i];
            _results.push(jsonFromFile(path));
          }
          return _results;
        } else {
          return jsonFromFile(options.src);
        }
      };
      if (options.middleware) {
        return function(req, res, next) {
          emitter.on("next", function() {
            next();
            return emitter.removeAllListeners("next");
          });
          return readAndWrite();
        };
      } else {
        return readAndWrite();
      }
    }
  };

  concat = function(objs) {
    var obj, result, string, _i, _len;
    if (objs.length !== 0) {
      string = "";
      for (_i = 0, _len = objs.length; _i < _len; _i++) {
        obj = objs[_i];
        string += JSON.stringify(obj);
      }
      string = string.replace(/^({})*|({})*$/g, "");
      string = string.replace(/}({})*{/g, ",");
      string = string.replace(/}{/g, ",");
      return result = JSON.parse(string);
    } else {
      return result = "";
    }
  };

  jsonFromFile = function(filename) {
    emitter.emit("more");
    return fs.stat(filename, function(err, stats) {
      if (err) {
        return emitter.emit("done", null);
      } else {
        if (stats.isDirectory()) {
          return fs.readdir(filename, function(err, files) {
            var file, _i, _len;
            if (err) {
              return emitter.emit("done", null);
            } else {
              for (_i = 0, _len = files.length; _i < _len; _i++) {
                file = files[_i];
                if (path.extname(file) === ".json") {
                  jsonFromFile(path.resolve(filename, file));
                }
              }
              return emitter.emit("done", null);
            }
          });
        } else if (stats.isFile()) {
          return fs.readFile(filename, function(err, content) {
            var e, json;
            if (err) {
              return emitter.emit("done", null);
            } else {
              try {
                json = JSON.parse(content);
                return emitter.emit("done", json);
              } catch (_error) {
                e = _error;
                return emitter.emit("done", null);
              }
            }
          });
        } else {
          return emitter.emit("done", null);
        }
      }
    });
  };

}).call(this);

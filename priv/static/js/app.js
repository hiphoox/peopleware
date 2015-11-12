(function(/*! Brunch !*/) {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';

    if (has(cache, path)) return cache[path].exports;
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex].exports;
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  var define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
"use strict";

(function () {
  "use strict";

  var globals = typeof window !== "undefined" ? window : global;
  if (typeof globals.require === "function") return;

  var modules = {};
  var cache = {};

  var has = function has(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function expand(root, name) {
    var results = [],
        parts,
        part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join("/").split("/");
    } else {
      parts = name.split("/");
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === "..") {
        results.pop();
      } else if (part !== "." && part !== "") {
        results.push(part);
      }
    }
    return results.join("/");
  };

  var dirname = function dirname(path) {
    return path.split("/").slice(0, -1).join("/");
  };

  var localRequire = function localRequire(path) {
    return function (name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function initModule(name, definition) {
    var module = { id: name, exports: {} };
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function require(name, loaderPath) {
    var path = expand(name, ".");
    if (loaderPath == null) loaderPath = "/";

    if (has(cache, path)) {
      return cache[path].exports;
    }if (has(modules, path)) {
      return initModule(path, modules[path]);
    }var dirIndex = expand(path, "./index");
    if (has(cache, dirIndex)) {
      return cache[dirIndex].exports;
    }if (has(modules, dirIndex)) {
      return initModule(dirIndex, modules[dirIndex]);
    }throw new Error("Cannot find module \"" + name + "\" from " + "\"" + loaderPath + "\"");
  };

  var define = function define(bundle, fn) {
    if (typeof bundle === "object") {
      for (var key in bundle) {
        if (has(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  var list = function list() {
    var result = [];
    for (var item in modules) {
      if (has(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  globals.require = require;
  globals.require.define = define;
  globals.require.register = define;
  globals.require.list = list;
  globals.require.brunch = true;
})();
require.define({ phoenix: function phoenix(exports, require, module) {
    "use strict";

    var _classCallCheck = function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    };

    var SOCKET_STATES = { connecting: 0, open: 1, closing: 2, closed: 3 };
    var CHANNEL_EVENTS = {
      close: "phx_close",
      error: "phx_error",
      join: "phx_join",
      reply: "phx_reply",
      leave: "phx_leave"
    };

    var Push = (function () {

      // Initializes the Push
      //
      // chan - The Channel
      // event - The event, ie `"phx_join"`
      // payload - The payload, ie `{user_id: 123}`
      // mergePush - The optional `Push` to merge hooks from

      function Push(chan, event, payload, mergePush) {
        var _this = this;

        _classCallCheck(this, Push);

        this.chan = chan;
        this.event = event;
        this.payload = payload || {};
        this.receivedResp = null;
        this.afterHooks = [];
        this.recHooks = {};
        this.sent = false;
        if (mergePush) {
          mergePush.afterHooks.forEach(function (hook) {
            return _this.after(hook.ms, hook.callback);
          });
          for (var status in mergePush.recHooks) {
            if (mergePush.recHooks.hasOwnProperty(status)) {
              this.receive(status, mergePush.recHooks[status]);
            }
          }
        }
      }

      Push.prototype.send = function send() {
        var _this = this;

        var ref = this.chan.socket.makeRef();
        var refEvent = this.chan.replyEventName(ref);

        this.chan.on(refEvent, function (payload) {
          _this.receivedResp = payload;
          _this.matchReceive(payload);
          _this.chan.off(refEvent);
          _this.cancelAfters();
        });

        this.startAfters();
        this.sent = true;
        this.chan.socket.push({
          topic: this.chan.topic,
          event: this.event,
          payload: this.payload,
          ref: ref
        });
      };

      Push.prototype.receive = function receive(status, callback) {
        if (this.receivedResp && this.receivedResp.status === status) {
          callback(this.receivedResp.response);
        }
        this.recHooks[status] = callback;
        return this;
      };

      Push.prototype.after = function after(ms, callback) {
        var timer = null;
        if (this.sent) {
          timer = setTimeout(callback, ms);
        }
        this.afterHooks.push({ ms: ms, callback: callback, timer: timer });
        return this;
      };

      // private

      Push.prototype.matchReceive = function matchReceive(_ref) {
        var status = _ref.status;
        var response = _ref.response;
        var ref = _ref.ref;

        var callback = this.recHooks[status];
        if (!callback) {
          return;
        }

        if (this.event === CHANNEL_EVENTS.join) {
          callback(this.chan);
        } else {
          callback(response);
        }
      };

      Push.prototype.cancelAfters = function cancelAfters() {
        this.afterHooks.forEach(function (hook) {
          clearTimeout(hook.timer);
          hook.timer = null;
        });
      };

      Push.prototype.startAfters = function startAfters() {
        this.afterHooks.map(function (hook) {
          if (!hook.timer) {
            hook.timer = setTimeout(function () {
              return hook.callback();
            }, hook.ms);
          }
        });
      };

      return Push;
    })();

    var Channel = exports.Channel = (function () {
      function Channel(topic, message, callback, socket) {
        _classCallCheck(this, Channel);

        this.topic = topic;
        this.message = message;
        this.callback = callback;
        this.socket = socket;
        this.bindings = [];
        this.afterHooks = [];
        this.recHooks = {};
        this.joinPush = new Push(this, CHANNEL_EVENTS.join, this.message);

        this.reset();
      }

      Channel.prototype.after = function after(ms, callback) {
        this.joinPush.after(ms, callback);
        return this;
      };

      Channel.prototype.receive = function receive(status, callback) {
        this.joinPush.receive(status, callback);
        return this;
      };

      Channel.prototype.rejoin = function rejoin() {
        this.reset();
        this.joinPush.send();
      };

      Channel.prototype.onClose = function onClose(callback) {
        this.on(CHANNEL_EVENTS.close, callback);
      };

      Channel.prototype.onError = function onError(callback) {
        var _this = this;

        this.on(CHANNEL_EVENTS.error, function (reason) {
          callback(reason);
          _this.trigger(CHANNEL_EVENTS.close, "error");
        });
      };

      Channel.prototype.reset = function reset() {
        var _this = this;

        this.bindings = [];
        var newJoinPush = new Push(this, CHANNEL_EVENTS.join, this.message, this.joinPush);
        this.joinPush = newJoinPush;
        this.onError(function (reason) {
          setTimeout(function () {
            return _this.rejoin();
          }, _this.socket.reconnectAfterMs);
        });
        this.on(CHANNEL_EVENTS.reply, function (payload) {
          _this.trigger(_this.replyEventName(payload.ref), payload);
        });
      };

      Channel.prototype.on = function on(event, callback) {
        this.bindings.push({ event: event, callback: callback });
      };

      Channel.prototype.isMember = function isMember(topic) {
        return this.topic === topic;
      };

      Channel.prototype.off = function off(event) {
        this.bindings = this.bindings.filter(function (bind) {
          return bind.event !== event;
        });
      };

      Channel.prototype.trigger = function trigger(triggerEvent, msg) {
        this.bindings.filter(function (bind) {
          return bind.event === triggerEvent;
        }).map(function (bind) {
          return bind.callback(msg);
        });
      };

      Channel.prototype.push = function push(event, payload) {
        var pushEvent = new Push(this, event, payload);
        pushEvent.send();

        return pushEvent;
      };

      Channel.prototype.replyEventName = function replyEventName(ref) {
        return "chan_reply_" + ref;
      };

      Channel.prototype.leave = function leave() {
        var _this = this;

        return this.push(CHANNEL_EVENTS.leave).receive("ok", function () {
          _this.socket.leave(_this);
          chan.reset();
        });
      };

      return Channel;
    })();

    var Socket = exports.Socket = (function () {

      // Initializes the Socket
      //
      // endPoint - The string WebSocket endpoint, ie, "ws://example.com/ws",
      //                                               "wss://example.com"
      //                                               "/ws" (inherited host & protocol)
      // opts - Optional configuration
      //   transport - The Websocket Transport, ie WebSocket, Phoenix.LongPoller.
      //               Defaults to WebSocket with automatic LongPoller fallback.
      //   heartbeatIntervalMs - The millisec interval to send a heartbeat message
      //   reconnectAfterMs - The millisec interval to reconnect after connection loss
      //   logger - The optional function for specialized logging, ie:
      //            `logger: function(msg){ console.log(msg) }`
      //   longpoller_timeout - The maximum timeout of a long poll AJAX request.
      //                        Defaults to 20s (double the server long poll timer).
      //
      // For IE8 support use an ES5-shim (https://github.com/es-shims/es5-shim)
      //

      function Socket(endPoint) {
        var opts = arguments[1] === undefined ? {} : arguments[1];

        _classCallCheck(this, Socket);

        this.states = SOCKET_STATES;
        this.stateChangeCallbacks = { open: [], close: [], error: [], message: [] };
        this.flushEveryMs = 50;
        this.reconnectTimer = null;
        this.channels = [];
        this.sendBuffer = [];
        this.ref = 0;
        this.transport = opts.transport || window.WebSocket || LongPoller;
        this.heartbeatIntervalMs = opts.heartbeatIntervalMs || 30000;
        this.reconnectAfterMs = opts.reconnectAfterMs || 5000;
        this.logger = opts.logger || function () {}; // noop
        this.longpoller_timeout = opts.longpoller_timeout || 20000;
        this.endPoint = this.expandEndpoint(endPoint);

        this.resetBufferTimer();
      }

      Socket.prototype.protocol = function protocol() {
        return location.protocol.match(/^https/) ? "wss" : "ws";
      };

      Socket.prototype.expandEndpoint = function expandEndpoint(endPoint) {
        if (endPoint.charAt(0) !== "/") {
          return endPoint;
        }
        if (endPoint.charAt(1) === "/") {
          return "" + this.protocol() + ":" + endPoint;
        }

        return "" + this.protocol() + "://" + location.host + "" + endPoint;
      };

      Socket.prototype.disconnect = function disconnect(callback, code, reason) {
        if (this.conn) {
          this.conn.onclose = function () {}; // noop
          if (code) {
            this.conn.close(code, reason || "");
          } else {
            this.conn.close();
          }
          this.conn = null;
        }
        callback && callback();
      };

      Socket.prototype.connect = function connect() {
        var _this = this;

        this.disconnect(function () {
          _this.conn = new _this.transport(_this.endPoint);
          _this.conn.timeout = _this.longpoller_timeout;
          _this.conn.onopen = function () {
            return _this.onConnOpen();
          };
          _this.conn.onerror = function (error) {
            return _this.onConnError(error);
          };
          _this.conn.onmessage = function (event) {
            return _this.onConnMessage(event);
          };
          _this.conn.onclose = function (event) {
            return _this.onConnClose(event);
          };
        });
      };

      Socket.prototype.resetBufferTimer = function resetBufferTimer() {
        var _this = this;

        clearTimeout(this.sendBufferTimer);
        this.sendBufferTimer = setTimeout(function () {
          return _this.flushSendBuffer();
        }, this.flushEveryMs);
      };

      // Logs the message. Override `this.logger` for specialized logging. noops by default

      Socket.prototype.log = function log(msg) {
        this.logger(msg);
      };

      // Registers callbacks for connection state change events
      //
      // Examples
      //
      //    socket.onError function(error){ alert("An error occurred") }
      //

      Socket.prototype.onOpen = function onOpen(callback) {
        this.stateChangeCallbacks.open.push(callback);
      };

      Socket.prototype.onClose = function onClose(callback) {
        this.stateChangeCallbacks.close.push(callback);
      };

      Socket.prototype.onError = function onError(callback) {
        this.stateChangeCallbacks.error.push(callback);
      };

      Socket.prototype.onMessage = function onMessage(callback) {
        this.stateChangeCallbacks.message.push(callback);
      };

      Socket.prototype.onConnOpen = function onConnOpen() {
        var _this = this;

        clearInterval(this.reconnectTimer);
        if (!this.conn.skipHeartbeat) {
          clearInterval(this.heartbeatTimer);
          this.heartbeatTimer = setInterval(function () {
            return _this.sendHeartbeat();
          }, this.heartbeatIntervalMs);
        }
        this.rejoinAll();
        this.stateChangeCallbacks.open.forEach(function (callback) {
          return callback();
        });
      };

      Socket.prototype.onConnClose = function onConnClose(event) {
        var _this = this;

        this.log("WS close:");
        this.log(event);
        clearInterval(this.reconnectTimer);
        clearInterval(this.heartbeatTimer);
        this.reconnectTimer = setInterval(function () {
          return _this.connect();
        }, this.reconnectAfterMs);
        this.stateChangeCallbacks.close.forEach(function (callback) {
          return callback(event);
        });
      };

      Socket.prototype.onConnError = function onConnError(error) {
        this.log("WS error:");
        this.log(error);
        this.stateChangeCallbacks.error.forEach(function (callback) {
          return callback(error);
        });
      };

      Socket.prototype.connectionState = function connectionState() {
        switch (this.conn && this.conn.readyState) {
          case this.states.connecting:
            return "connecting";
          case this.states.open:
            return "open";
          case this.states.closing:
            return "closing";
          default:
            return "closed";
        }
      };

      Socket.prototype.isConnected = function isConnected() {
        return this.connectionState() === "open";
      };

      Socket.prototype.rejoinAll = function rejoinAll() {
        this.channels.forEach(function (chan) {
          return chan.rejoin();
        });
      };

      Socket.prototype.join = function join(topic, message, callback) {
        var chan = new Channel(topic, message, callback, this);
        this.channels.push(chan);
        if (this.isConnected()) {
          chan.rejoin();
        }
        return chan;
      };

      Socket.prototype.leave = function leave(chan) {
        this.channels = this.channels.filter(function (c) {
          return !c.isMember(chan.topic);
        });
      };

      Socket.prototype.push = function push(data) {
        var _this = this;

        var callback = function callback() {
          return _this.conn.send(JSON.stringify(data));
        };
        if (this.isConnected()) {
          callback();
        } else {
          this.sendBuffer.push(callback);
        }
      };

      // Return the next message ref, accounting for overflows

      Socket.prototype.makeRef = function makeRef() {
        var newRef = this.ref + 1;
        if (newRef === this.ref) {
          this.ref = 0;
        } else {
          this.ref = newRef;
        }

        return this.ref.toString();
      };

      Socket.prototype.sendHeartbeat = function sendHeartbeat() {
        this.push({ topic: "phoenix", event: "heartbeat", payload: {}, ref: this.makeRef() });
      };

      Socket.prototype.flushSendBuffer = function flushSendBuffer() {
        if (this.isConnected() && this.sendBuffer.length > 0) {
          this.sendBuffer.forEach(function (callback) {
            return callback();
          });
          this.sendBuffer = [];
        }
        this.resetBufferTimer();
      };

      Socket.prototype.onConnMessage = function onConnMessage(rawMessage) {
        this.log("message received:");
        this.log(rawMessage);

        var _JSON$parse = JSON.parse(rawMessage.data);

        var topic = _JSON$parse.topic;
        var event = _JSON$parse.event;
        var payload = _JSON$parse.payload;

        this.channels.filter(function (chan) {
          return chan.isMember(topic);
        }).forEach(function (chan) {
          return chan.trigger(event, payload);
        });
        this.stateChangeCallbacks.message.forEach(function (callback) {
          callback(topic, event, payload);
        });
      };

      return Socket;
    })();

    var LongPoller = exports.LongPoller = (function () {
      function LongPoller(endPoint) {
        _classCallCheck(this, LongPoller);

        this.retryInMs = 5000;
        this.endPoint = null;
        this.token = null;
        this.sig = null;
        this.skipHeartbeat = true;
        this.onopen = function () {}; // noop
        this.onerror = function () {}; // noop
        this.onmessage = function () {}; // noop
        this.onclose = function () {}; // noop
        this.states = SOCKET_STATES;
        this.upgradeEndpoint = this.normalizeEndpoint(endPoint);
        this.pollEndpoint = this.upgradeEndpoint + (/\/$/.test(endPoint) ? "poll" : "/poll");
        this.readyState = this.states.connecting;

        this.poll();
      }

      LongPoller.prototype.normalizeEndpoint = function normalizeEndpoint(endPoint) {
        return endPoint.replace("ws://", "http://").replace("wss://", "https://");
      };

      LongPoller.prototype.endpointURL = function endpointURL() {
        return this.pollEndpoint + ("?token=" + encodeURIComponent(this.token) + "&sig=" + encodeURIComponent(this.sig));
      };

      LongPoller.prototype.closeAndRetry = function closeAndRetry() {
        this.close();
        this.readyState = this.states.connecting;
      };

      LongPoller.prototype.ontimeout = function ontimeout() {
        this.onerror("timeout");
        this.closeAndRetry();
      };

      LongPoller.prototype.poll = function poll() {
        var _this = this;

        if (!(this.readyState === this.states.open || this.readyState === this.states.connecting)) {
          return;
        }

        Ajax.request("GET", this.endpointURL(), "application/json", null, this.timeout, this.ontimeout.bind(this), function (resp) {
          if (resp) {
            var status = resp.status;
            var token = resp.token;
            var sig = resp.sig;
            var messages = resp.messages;

            _this.token = token;
            _this.sig = sig;
          } else {
            var status = 0;
          }

          switch (status) {
            case 200:
              messages.forEach(function (msg) {
                return _this.onmessage({ data: JSON.stringify(msg) });
              });
              _this.poll();
              break;
            case 204:
              _this.poll();
              break;
            case 410:
              _this.readyState = _this.states.open;
              _this.onopen();
              _this.poll();
              break;
            case 0:
            case 500:
              _this.onerror();
              _this.closeAndRetry();
              break;
            default:
              throw "unhandled poll status " + status;
          }
        });
      };

      LongPoller.prototype.send = function send(body) {
        var _this = this;

        Ajax.request("POST", this.endpointURL(), "application/json", body, this.timeout, this.onerror.bind(this, "timeout"), function (resp) {
          if (!resp || resp.status !== 200) {
            _this.onerror(status);
            _this.closeAndRetry();
          }
        });
      };

      LongPoller.prototype.close = function close(code, reason) {
        this.readyState = this.states.closed;
        this.onclose();
      };

      return LongPoller;
    })();

    var Ajax = exports.Ajax = (function () {
      function Ajax() {
        _classCallCheck(this, Ajax);
      }

      Ajax.request = function request(method, endPoint, accept, body, timeout, ontimeout, callback) {
        if (window.XDomainRequest) {
          var req = new XDomainRequest(); // IE8, IE9
          this.xdomainRequest(req, method, endPoint, body, timeout, ontimeout, callback);
        } else {
          var req = window.XMLHttpRequest ? new XMLHttpRequest() : // IE7+, Firefox, Chrome, Opera, Safari
          new ActiveXObject("Microsoft.XMLHTTP"); // IE6, IE5
          this.xhrRequest(req, method, endPoint, accept, body, timeout, ontimeout, callback);
        }
      };

      Ajax.xdomainRequest = function xdomainRequest(req, method, endPoint, body, timeout, ontimeout, callback) {
        var _this = this;

        req.timeout = timeout;
        req.open(method, endPoint);
        req.onload = function () {
          var response = _this.parseJSON(req.responseText);
          callback && callback(response);
        };
        if (ontimeout) {
          req.ontimeout = ontimeout;
        }

        // Work around bug in IE9 that requires an attached onprogress handler
        req.onprogress = function () {};

        req.send(body);
      };

      Ajax.xhrRequest = function xhrRequest(req, method, endPoint, accept, body, timeout, ontimeout, callback) {
        var _this = this;

        req.timeout = timeout;
        req.open(method, endPoint, true);
        req.setRequestHeader("Content-Type", accept);
        req.onerror = function () {
          callback && callback(null);
        };
        req.onreadystatechange = function () {
          if (req.readyState === _this.states.complete && callback) {
            var response = _this.parseJSON(req.responseText);
            callback(response);
          }
        };
        if (ontimeout) {
          req.ontimeout = ontimeout;
        }

        req.send(body);
      };

      Ajax.parseJSON = function parseJSON(resp) {
        return resp && resp !== "" ? JSON.parse(resp) : null;
      };

      return Ajax;
    })();

    Ajax.states = { complete: 4 };
    exports.__esModule = true;
  } });
if (typeof window === "object" && !window.Phoenix) {
  window.Phoenix = require("phoenix");
};
/*! Brunch !*/require.register("web/static/js/app", function(exports, require, module) {
"use strict";

var Socket = require("phoenix").Socket;

// let socket = new Socket("/ws")
// socket.join("topic:subtopic", {}, chan => {
// })

var App = {};

module.exports = App;});

;require.register("web/static/js/jquery.mask", function(exports, require, module) {
/**
 * jquery.mask.js
 * @version: v1.13.4
 * @author: Igor Escobar
 *
 * Created by Igor Escobar on 2012-03-10. Please report any bug at http://blog.igorescobar.com
 *
 * Copyright (c) 2012 Igor Escobar http://blog.igorescobar.com
 *
 * The MIT License (http://www.opensource.org/licenses/mit-license.php)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/* jshint laxbreak: true */
/* global define, jQuery, Zepto */

"use strict";

// UMD (Universal Module Definition) patterns for JavaScript modules that work everywhere.
// https://github.com/umdjs/umd/blob/master/jqueryPluginCommonjs.js
(function (factory) {

    if (typeof define === "function" && define.amd) {
        define(["jquery"], factory);
    } else if (typeof exports === "object") {
        module.exports = factory(require("jquery"));
    } else {
        factory(jQuery || Zepto);
    }
})(function ($) {

    var Mask = function Mask(el, mask, options) {
        el = $(el);

        var jMask = this,
            oldValue = el.val(),
            regexMask;

        mask = typeof mask === "function" ? mask(el.val(), undefined, el, options) : mask;

        var p = {
            invalid: [],
            getCaret: function getCaret() {
                try {
                    var sel,
                        pos = 0,
                        ctrl = el.get(0),
                        dSel = document.selection,
                        cSelStart = ctrl.selectionStart;

                    // IE Support
                    if (dSel && navigator.appVersion.indexOf("MSIE 10") === -1) {
                        sel = dSel.createRange();
                        sel.moveStart("character", el.is("input") ? -el.val().length : -el.text().length);
                        pos = sel.text.length;
                    }
                    // Firefox support
                    else if (cSelStart || cSelStart === "0") {
                        pos = cSelStart;
                    }

                    return pos;
                } catch (e) {}
            },
            setCaret: function setCaret(pos) {
                try {
                    if (el.is(":focus")) {
                        var range,
                            ctrl = el.get(0);

                        if (ctrl.setSelectionRange) {
                            ctrl.setSelectionRange(pos, pos);
                        } else if (ctrl.createTextRange) {
                            range = ctrl.createTextRange();
                            range.collapse(true);
                            range.moveEnd("character", pos);
                            range.moveStart("character", pos);
                            range.select();
                        }
                    }
                } catch (e) {}
            },
            events: function events() {
                el.on("input.mask keyup.mask", p.behaviour).on("paste.mask drop.mask", function () {
                    setTimeout(function () {
                        el.keydown().keyup();
                    }, 100);
                }).on("change.mask", function () {
                    el.data("changed", true);
                }).on("blur.mask", function () {
                    if (oldValue !== el.val() && !el.data("changed")) {
                        el.triggerHandler("change");
                    }
                    el.data("changed", false);
                })
                // it's very important that this callback remains in this position
                // otherwhise oldValue it's going to work buggy
                .on("blur.mask", function () {
                    oldValue = el.val();
                })
                // select all text on focus
                .on("focus.mask", function (e) {
                    if (options.selectOnFocus === true) {
                        $(e.target).select();
                    }
                })
                // clear the value if it not complete the mask
                .on("focusout.mask", function () {
                    if (options.clearIfNotMatch && !regexMask.test(p.val())) {
                        p.val("");
                    }
                });
            },
            getRegexMask: function getRegexMask() {
                var maskChunks = [],
                    translation,
                    pattern,
                    optional,
                    recursive,
                    oRecursive,
                    r;

                for (var i = 0; i < mask.length; i++) {
                    translation = jMask.translation[mask.charAt(i)];

                    if (translation) {

                        pattern = translation.pattern.toString().replace(/.{1}$|^.{1}/g, "");
                        optional = translation.optional;
                        recursive = translation.recursive;

                        if (recursive) {
                            maskChunks.push(mask.charAt(i));
                            oRecursive = { digit: mask.charAt(i), pattern: pattern };
                        } else {
                            maskChunks.push(!optional && !recursive ? pattern : pattern + "?");
                        }
                    } else {
                        maskChunks.push(mask.charAt(i).replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&"));
                    }
                }

                r = maskChunks.join("");

                if (oRecursive) {
                    r = r.replace(new RegExp("(" + oRecursive.digit + "(.*" + oRecursive.digit + ")?)"), "($1)?").replace(new RegExp(oRecursive.digit, "g"), oRecursive.pattern);
                }

                return new RegExp(r);
            },
            destroyEvents: function destroyEvents() {
                el.off(["input", "keydown", "keyup", "paste", "drop", "blur", "focusout", ""].join(".mask "));
            },
            val: function val(v) {
                var isInput = el.is("input"),
                    method = isInput ? "val" : "text",
                    r;

                if (arguments.length > 0) {
                    if (el[method]() !== v) {
                        el[method](v);
                    }
                    r = el;
                } else {
                    r = el[method]();
                }

                return r;
            },
            getMCharsBeforeCount: function getMCharsBeforeCount(index, onCleanVal) {
                for (var count = 0, i = 0, maskL = mask.length; i < maskL && i < index; i++) {
                    if (!jMask.translation[mask.charAt(i)]) {
                        index = onCleanVal ? index + 1 : index;
                        count++;
                    }
                }
                return count;
            },
            caretPos: function caretPos(originalCaretPos, oldLength, newLength, maskDif) {
                var translation = jMask.translation[mask.charAt(Math.min(originalCaretPos - 1, mask.length - 1))];

                return !translation ? p.caretPos(originalCaretPos + 1, oldLength, newLength, maskDif) : Math.min(originalCaretPos + newLength - oldLength - maskDif, newLength);
            },
            behaviour: function behaviour(e) {
                e = e || window.event;
                p.invalid = [];
                var keyCode = e.keyCode || e.which;
                if ($.inArray(keyCode, jMask.byPassKeys) === -1) {

                    var caretPos = p.getCaret(),
                        currVal = p.val(),
                        currValL = currVal.length,
                        changeCaret = caretPos < currValL,
                        newVal = p.getMasked(),
                        newValL = newVal.length,
                        maskDif = p.getMCharsBeforeCount(newValL - 1) - p.getMCharsBeforeCount(currValL - 1);

                    p.val(newVal);

                    // change caret but avoid CTRL+A
                    if (changeCaret && !(keyCode === 65 && e.ctrlKey)) {
                        // Avoid adjusting caret on backspace or delete
                        if (!(keyCode === 8 || keyCode === 46)) {
                            caretPos = p.caretPos(caretPos, currValL, newValL, maskDif);
                        }
                        p.setCaret(caretPos);
                    }

                    return p.callbacks(e);
                }
            },
            getMasked: function getMasked(skipMaskChars) {
                var buf = [],
                    value = p.val(),
                    m = 0,
                    maskLen = mask.length,
                    v = 0,
                    valLen = value.length,
                    offset = 1,
                    addMethod = "push",
                    resetPos = -1,
                    lastMaskChar,
                    check;

                if (options.reverse) {
                    addMethod = "unshift";
                    offset = -1;
                    lastMaskChar = 0;
                    m = maskLen - 1;
                    v = valLen - 1;
                    check = function () {
                        return m > -1 && v > -1;
                    };
                } else {
                    lastMaskChar = maskLen - 1;
                    check = function () {
                        return m < maskLen && v < valLen;
                    };
                }

                while (check()) {
                    var maskDigit = mask.charAt(m),
                        valDigit = value.charAt(v),
                        translation = jMask.translation[maskDigit];

                    if (translation) {
                        if (valDigit.match(translation.pattern)) {
                            buf[addMethod](valDigit);
                            if (translation.recursive) {
                                if (resetPos === -1) {
                                    resetPos = m;
                                } else if (m === lastMaskChar) {
                                    m = resetPos - offset;
                                }

                                if (lastMaskChar === resetPos) {
                                    m -= offset;
                                }
                            }
                            m += offset;
                        } else if (translation.optional) {
                            m += offset;
                            v -= offset;
                        } else if (translation.fallback) {
                            buf[addMethod](translation.fallback);
                            m += offset;
                            v -= offset;
                        } else {
                            p.invalid.push({ p: v, v: valDigit, e: translation.pattern });
                        }
                        v += offset;
                    } else {
                        if (!skipMaskChars) {
                            buf[addMethod](maskDigit);
                        }

                        if (valDigit === maskDigit) {
                            v += offset;
                        }

                        m += offset;
                    }
                }

                var lastMaskCharDigit = mask.charAt(lastMaskChar);
                if (maskLen === valLen + 1 && !jMask.translation[lastMaskCharDigit]) {
                    buf.push(lastMaskCharDigit);
                }

                return buf.join("");
            },
            callbacks: function callbacks(e) {
                var val = p.val(),
                    changed = val !== oldValue,
                    defaultArgs = [val, e, el, options],
                    callback = function callback(name, criteria, args) {
                    if (typeof options[name] === "function" && criteria) {
                        options[name].apply(this, args);
                    }
                };

                callback("onChange", changed === true, defaultArgs);
                callback("onKeyPress", changed === true, defaultArgs);
                callback("onComplete", val.length === mask.length, defaultArgs);
                callback("onInvalid", p.invalid.length > 0, [val, e, el, p.invalid, options]);
            }
        };

        // public methods
        jMask.mask = mask;
        jMask.options = options;
        jMask.remove = function () {
            var caret = p.getCaret();
            p.destroyEvents();
            p.val(jMask.getCleanVal());
            p.setCaret(caret - p.getMCharsBeforeCount(caret));
            return el;
        };

        // get value without mask
        jMask.getCleanVal = function () {
            return p.getMasked(true);
        };

        jMask.init = function (onlyMask) {
            onlyMask = onlyMask || false;
            options = options || {};

            jMask.byPassKeys = $.jMaskGlobals.byPassKeys;
            jMask.translation = $.jMaskGlobals.translation;

            jMask.translation = $.extend({}, jMask.translation, options.translation);
            jMask = $.extend(true, {}, jMask, options);

            regexMask = p.getRegexMask();

            if (onlyMask === false) {

                if (options.placeholder) {
                    el.attr("placeholder", options.placeholder);
                }

                // this is necessary, otherwise if the user submit the form
                // and then press the "back" button, the autocomplete will erase
                // the data. Works fine on IE9+, FF, Opera, Safari.
                if ($("input").length && "oninput" in $("input")[0] === false && el.attr("autocomplete") === "on") {
                    el.attr("autocomplete", "off");
                }

                p.destroyEvents();
                p.events();

                var caret = p.getCaret();
                p.val(p.getMasked());
                p.setCaret(caret + p.getMCharsBeforeCount(caret, true));
            } else {
                p.events();
                p.val(p.getMasked());
            }
        };

        jMask.init(!el.is("input"));
    };

    $.maskWatchers = {};
    var HTMLAttributes = function HTMLAttributes() {
        var input = $(this),
            options = {},
            prefix = "data-mask-",
            mask = input.attr("data-mask");

        if (input.attr(prefix + "reverse")) {
            options.reverse = true;
        }

        if (input.attr(prefix + "clearifnotmatch")) {
            options.clearIfNotMatch = true;
        }

        if (input.attr(prefix + "selectonfocus") === "true") {
            options.selectOnFocus = true;
        }

        if (notSameMaskObject(input, mask, options)) {
            return input.data("mask", new Mask(this, mask, options));
        }
    },
        notSameMaskObject = function notSameMaskObject(field, mask, options) {
        options = options || {};
        var maskObject = $(field).data("mask"),
            stringify = JSON.stringify,
            value = $(field).val() || $(field).text();
        try {
            if (typeof mask === "function") {
                mask = mask(value);
            }
            return typeof maskObject !== "object" || stringify(maskObject.options) !== stringify(options) || maskObject.mask !== mask;
        } catch (e) {}
    };

    $.fn.mask = function (mask, options) {
        options = options || {};
        var selector = this.selector,
            globals = $.jMaskGlobals,
            interval = $.jMaskGlobals.watchInterval,
            maskFunction = function maskFunction() {
            if (notSameMaskObject(this, mask, options)) {
                return $(this).data("mask", new Mask(this, mask, options));
            }
        };

        $(this).each(maskFunction);

        if (selector && selector !== "" && globals.watchInputs) {
            clearInterval($.maskWatchers[selector]);
            $.maskWatchers[selector] = setInterval(function () {
                $(document).find(selector).each(maskFunction);
            }, interval);
        }
        return this;
    };

    $.fn.unmask = function () {
        clearInterval($.maskWatchers[this.selector]);
        delete $.maskWatchers[this.selector];
        return this.each(function () {
            var dataMask = $(this).data("mask");
            if (dataMask) {
                dataMask.remove().removeData("mask");
            }
        });
    };

    $.fn.cleanVal = function () {
        return this.data("mask").getCleanVal();
    };

    $.applyDataMask = function (selector) {
        selector = selector || $.jMaskGlobals.maskElements;
        var $selector = selector instanceof $ ? selector : $(selector);
        $selector.filter($.jMaskGlobals.dataMaskAttr).each(HTMLAttributes);
    };

    var globals = {
        maskElements: "input,td,span,div",
        dataMaskAttr: "*[data-mask]",
        dataMask: true,
        watchInterval: 300,
        watchInputs: true,
        watchDataMask: false,
        byPassKeys: [9, 16, 17, 18, 36, 37, 38, 39, 40, 91],
        translation: {
            "0": { pattern: /\d/ },
            "9": { pattern: /\d/, optional: true },
            "#": { pattern: /\d/, recursive: true },
            A: { pattern: /[a-zA-Z0-9]/ },
            S: { pattern: /[a-zA-Z]/ }
        }
    };

    $.jMaskGlobals = $.jMaskGlobals || {};
    globals = $.jMaskGlobals = $.extend(true, {}, globals, $.jMaskGlobals);

    // looking for inputs with data-mask attribute
    if (globals.dataMask) {
        $.applyDataMask();
    }

    setInterval(function () {
        if ($.jMaskGlobals.watchDataMask) {
            $.applyDataMask();
        }
    }, globals.watchInterval);
});});


//# sourceMappingURL=app.js.map
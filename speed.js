(function() {
  "use strict";
  var LITERALS, Speed, TYPES, Types, breakIfEqual, createForce, extend, instanceOf, testValues, typeOf, _;

  instanceOf = function(type, value) {
    return value instanceof type;
  };

  typeOf = function(value, type) {
    if (type == null) {
      type = 'object';
    }
    return typeof value === type;
  };

  LITERALS = {
    'Boolean': false,
    'String': '',
    'Object': {},
    'Array': [],
    'Function': function() {},
    'Number': (function() {
      var number;
      number = new Number;
      number["void"] = true;
      return number;
    })()
  };

  TYPES = {
    'Undefined': function(value) {
      return value === void 0;
    },
    'Null': function(value) {
      return value === null;
    },
    'Function': function(value) {
      return typeOf(value, 'function');
    },
    'Boolean': function(value) {
      return typeOf(value, 'boolean');
    },
    'String': function(value) {
      return typeOf(value, 'string');
    },
    'Array': function(value) {
      return typeOf(value) && instanceOf(Array, value);
    },
    'RegExp': function(value) {
      return typeOf(value) && instanceOf(RegExp, value);
    },
    'Date': function(value) {
      return typeOf(value) && instanceOf(Date, value);
    },
    'Number': function(value) {
      return typeOf(value, 'number') && (value === value) || (typeOf(value) && instanceOf(Number, value));
    },
    'Object': function(value) {
      return typeOf(value) && (value !== null) && !instanceOf(Boolean, value) && !instanceOf(Number, value) && !instanceOf(Array, value) && !instanceOf(RegExp, value) && !instanceOf(Date, value);
    },
    'NaN': function(value) {
      return typeOf(value, 'number') && (value !== value);
    },
    'Defined': function(value) {
      return value !== void 0;
    }
  };

  TYPES.StringOrNumber = function(value) {
    return TYPES.String(value) || TYPES.Number(value);
  };

  Types = _ = {
    parseIntBase: 10
  };

  createForce = function(type) {
    var convertType;
    convertType = function(value) {
      switch (type) {
        case 'Number':
          if ((_.isNumber(value = parseInt(value, _.parseIntBase))) && !value["void"]) {
            return value;
          }
          break;
        case 'String':
          if (_.isStringOrNumber(value)) {
            return value + '';
          }
          break;
        default:
          if (Types['is' + type](value)) {
            return value;
          }
      }
    };
    return function(value, replacement) {
      if ((value != null) && void 0 !== (value = convertType(value))) {
        return value;
      }
      if ((replacement != null) && void 0 !== (replacement = convertType(replacement))) {
        return replacement;
      }
      return LITERALS[type];
    };
  };

  testValues = function(predicate, breakState, values) {
    var value, _i, _len;
    if (values == null) {
      values = [];
    }
    if (values.length < 1) {
      return predicate === TYPES.Undefined;
    }
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      value = values[_i];
      if (predicate(value) === breakState) {
        return breakState;
      }
    }
    return !breakState;
  };

  breakIfEqual = true;

  (function() {
    var name, predicate, _results;
    _results = [];
    for (name in TYPES) {
      predicate = TYPES[name];
      _results.push((function(name, predicate) {
        Types['is' + name] = predicate;
        Types['not' + name] = function(value) {
          return !predicate(value);
        };
        Types['has' + name] = function() {
          return testValues(predicate, breakIfEqual, arguments);
        };
        Types['all' + name] = function() {
          return testValues(predicate, !breakIfEqual, arguments);
        };
        if (name in LITERALS) {
          return Types['force' + name] = createForce(name);
        }
      })(name, predicate));
    }
    return _results;
  })();

  extend = function(target, source, append) {
    var key, value;
    if (target == null) {
      target = {};
    }
    for (key in source) {
      value = source[key];
      if (_.isObject(value)) {
        extend(target[key], value, append);
      } else {

      }
      if (!(append && target.hasOwnProperty(key))) {
        target[key] = value;
      }
    }
    return target;
  };

  _.append = function(target, source) {
    return extend(_.forceObject(target), _.forceObject(source), true);
  };

  Speed = (function() {
    var align, format, resolveNameFunc, tooMany, warmup;

    format = function(nr, interval, char) {
      var formatted, index, length, pos, _i;
      if (interval == null) {
        interval = 3;
      }
      if (char == null) {
        char = '.';
      }
      if ('' === (nr = _.forceString(nr))) {
        return '';
      }
      length = nr.length - 1;
      formatted = nr[length--];
      if (length < 0) {
        return formatted;
      }
      pos = interval;
      for (index = _i = length; length <= 0 ? _i <= 0 : _i >= 0; index = length <= 0 ? ++_i : --_i) {
        if ((--pos % interval) === 0) {
          formatted = char + formatted;
          pos = interval;
        }
        formatted = nr[index] + formatted;
      }
      return formatted;
    };

    align = function(string, length) {
      var aligned, n, _i;
      if (length == null) {
        length = 20;
      }
      length -= string.length;
      aligned = '';
      if (length > 0) {
        for (n = _i = 1; 1 <= length ? _i <= length : _i >= length; n = 1 <= length ? ++_i : --_i) {
          aligned += ' ';
        }
      }
      if (align.right) {
        return aligned + string;
      }
      return string + aligned;
    };

    align.right = true;

    tooMany = function(calls) {
      if (calls > Speed.maxCalls) {
        console.log('You are trying to run more than ' + format(Speed.maxCalls) + ' calls, increase Speed.maxCalls if you really want this.');
        console.log('Aborting..');
        return true;
      }
    };

    warmup = function() {
      var n, _i, _ref, _results;
      _results = [];
      for (n = _i = 1, _ref = Speed.warmupCycles; 1 <= _ref ? _i <= _ref : _i >= _ref; n = 1 <= _ref ? ++_i : --_i) {
        _results.push(n = n);
      }
      return _results;
    };

    resolveNameFunc = function(ctx, name, func) {
      if (_.isFunction(name)) {
        func = name;
        name = 'anonymus-' + ++ctx.anonymusCount;
      }
      return [name, func];
    };

    Speed.Types = Types;

    Speed.details = false;

    Speed.rounds = 1;

    Speed.calls = 1;

    Speed.maxCalls = 100000000;

    Speed.warmupCycles = 1000000;

    Speed.run = function(callback, calls, rounds, details, name) {
      var average, count, end, kickOff, round, start, totalElapsed, _i;
      if (name == null) {
        name = 'anonymus';
      }
      if (!(callback = _.forceFunction(callback, null))) {
        return console.log(name);
      }
      rounds = _.forceNumber(rounds, Speed.rounds);
      calls = _.forceNumber(calls, Speed.calls);
      details = _.forceBoolean(details, Speed.details);
      if (tooMany(rounds * calls)) {
        return;
      }
      console.log('*speed.js* -> "' + name + '", run ' + format(rounds) + ' rounds ' + format(calls) + ' calls');
      warmup();
      kickOff = Date.now();
      for (round = _i = 1; 1 <= rounds ? _i <= rounds : _i >= rounds; round = 1 <= rounds ? ++_i : --_i) {
        count = 1;
        start = Date.now();
        while (count++ < calls) {
          callback();
        }
        end = Date.now();
        if (details) {
          console.log('round: ' + round + ': ' + align((end - start) + ' ms', 9));
        }
      }
      totalElapsed = Date.now() - kickOff;
      average = format(~~(totalElapsed / rounds));
      totalElapsed = format(totalElapsed);
      console.log('average time for ' + align(format(calls) + ' calls : ') + align(average + ' ms', 9));
      console.log('total time for   ' + align(format(calls * rounds) + ' calls : ') + align(totalElapsed + ' ms', 9));
      return console.log();
    };

    function Speed(settings) {
      _.append(this, settings);
      this.callbacks = {};
      this.anonymusCount = 0;
    }

    Speed.prototype.add = function(name, func) {
      var _ref;
      _ref = resolveNameFunc(this, name, func), name = _ref[0], func = _ref[1];
      if ((!this.callbacks[name]) && _.isFunction(func)) {
        this.callbacks[name] = func;
      }
      return this;
    };

    Speed.prototype.run = function(name, func) {
      var callback, _ref, _ref1;
      _ref = resolveNameFunc(this, name, func), name = _ref[0], func = _ref[1];
      if (name != null) {
        Speed.run(func, this.calls, this.rounds, this.details, name);
      } else {
        _ref1 = this.callbacks;
        for (name in _ref1) {
          callback = _ref1[name];
          Speed.run(callback, this.calls, this.rounds, this.details, name);
        }
      }
      return this;
    };

    return Speed;

  })();

  if (typeof window !== "undefined" && window !== null) {
    window.Speed = Speed;
  } else if (typeof module !== "undefined" && module !== null) {
    module.exports = Speed;
  }

}).call(this);

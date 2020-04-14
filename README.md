speed.js
========
<br/>

**A quick rudimentary console speed/benchmark test for algorithms**

- create multiple speed tests in a snap
- run all tests at once
- output test results to console and file
- runs warmup round internally 

<br/>

```javascript
const Speed= require( 'speed.js' );

// create an instance with specific settings
const test= new Speed({
	rounds	: 3,		// 3 rounds
	calls	: 10000000,	// 10.000.000 function calls per round
	details	: false		// set true to show details for each round
	file	: './speed.log'	// write log output also to file

});

// add some tests
test
	// you can add a names/id for a test	
	.add( 'create Object instances', () => new Object() )
	.add( 'create Object literals', () => {} )
	// or add an anonymus test	
	.add( () => 24 * 1.75 );

// run them all
test.run();
// *speed.js* - running 3 tests.. 

// 1: create Object instances: 3 rounds of 10.000.000 calls..
// average time for  10.000.000 calls :     82 ms
// total time for    30.000.000 calls :    246 ms

// 2: create Object literals: 3 rounds of 10.000.000 calls..
// average time for  10.000.000 calls :     50 ms
// total time for    30.000.000 calls :    150 ms

// 3: anonymus: 3 rounds of 10.000.000 calls..
// average time for  10.000.000 calls :     54 ms
// total time for    30.000.000 calls :    163 ms

// done! test results have been saved to: ./speed.log

```
Actual milliseconds elapsed are system and setup specific of course.
___

#### node.js

Install with npm: `npm install speed.js`

___
#### disclaimer

speed.js is not a 100% accurate and scientific benchmark tool for everything Javascript. It is just a quick rudimentary test-tool to help you compare the running speed of different algorithms while optimizing for speed.

For more advanced testing I'd recommend benchmark.
___


Speed
=====


**Speed.details**
> `<boolean> Speed.details`

Set to show measurements for every round. This is a global fallback setting, defaults to false.
___
**Speed.rounds**
> `<number> Speed.rounds`

This is a global fallback setting, defaults to 1.
___
**Speed.calls**
> `<number> Speed.calls`

This is a global fallback setting, defaults to 1.
___
**Speed.maxCalls**
> `<number> Speed.maxCalls`

This is a global fallback setting.

Defaults to 100.000.000 function calls. Can be set to any value, to prevent accidently launching a test that could take hours to complete or hang your system..
___
**Speed.warmupCycles**
> `<number> Speed.warmupCycles`

Defaults to 1.000.000 cycles.
___
**Speed.run**
> `<function> Speed.run( callback, calls, rounds, details, name= 'anonymus' )`

The static method available, can instanlty run a test.
```javascript
Speed.run( 
	() => new String( "Any callback for speed testing" ),
	100000,
	8
);
```
___
### prototype
___

**Speed.prototype.constructor**
> `<function> constructor( <object> settings )`

.rounds, .calls and .details can be pre-set via settings.
___

**Speed.prototype.callbacks**
> `<object> callbacks`

An object holding all functions added with .add or .run
___

**Speed.prototype.rounds**
> `<number> rounds`

___

**Speed.prototype.calls**
> `<number> calls`

___

**Speed.prototype.details**
> `<boolean> details`

___

**Speed.prototype.add**
> `<function> add( name= 'anonymus', callback )`

Adds a function to the tests
___

**Speed.prototype.run**
> `<function> run( name= 'anonymus', callback )`

Runs all functions set with .add. If name and/or callback is set, .run will override the already added functions, not running them. This can come in handy if you have some tests set up, and you want to do some quick manual test apart from the others.

```javascript
const speed= new Speed();

speed.run( function(){
	const thisThing= 'inhibiting the other tests..';
}, 1000000, 5);
```
___

___
change log
==========

**0.1.5**

- adds log file option
- adds babel transpiler stage for more stable build
- use last update of dependency
- adds test script, run with: npm run test
- update readme
___

**0.1.0**

Initial commit.

___

**additional**

I am always open for feature requests or any feedback. You can reach me at Github.
speed.js
========
<br/>
***A quick rudimentary speed test for algorithms***

<br/>
___
**example**
```javascript
var Speed= require( 'speed.js' );

// create an instance with specific settings
var test= new Speed({
	 rounds		: 3				// 3 rounds
	,calls		: 10000000		// 10.000.000 function calls per round
	,details	: true			// show details for each round
});

// add some tests
test
	.add( 'create Object instances', function(){
		var object= new Object();
	})
	.add( 'create Object literals', function(){
		var object= {};
	});

// run them all
test.run();
// *speed.js* -> "create Object instances", run 3 rounds 10.000.000 calls
// round: 1:    469 ms
// round: 2:    447 ms
// round: 3:    449 ms
// average time for  10.000.000 calls :    455 ms
// total time for    30.000.000 calls :  1.367 ms
//
// *speed.js* -> "create Object literals", run 3 rounds 10.000.000 calls
// round: 1:    110 ms
// round: 2:     42 ms
// round: 3:     42 ms
// average time for  10.000.000 calls :     65 ms
// total time for    30.000.000 calls :    195 ms
```
Despite the internal warmup function, the first round always takes more time to run.
Therefore, always run multiple rounds and look at the averages and total time elapsed.

Of course the milliseconds elapsed are system and setup specific, and are only of value for comparing algorithms
on a specific system.
___

#### node.js

Install with npm: `npm install speed.js`, then
```javascript
var Speed= require( 'speed.js' );
```
___
#### browser
Make Speed global in the browser.
```html
<script src="path/to/speed.min.js"></script>
```
___
#### disclaimer

speed.js is not a 100% accurate and scientific benchmark tool for everything Javascript. It is just a quick
rudimentary test-tool to help you compare the running speed of different algorithms while optimizing for speed.
___

API
===

```html
object overview

	Speed			<object>
		details			<boolean>
		rounds			<number>
		calls			<number>
		maxCalls		<number>
		warmupCycles	<number>
		run				<function>

		prototype		<object>
			constructor		<function>
			rounds			<number>
			calls			<number>
			details			<boolean>
			add				<function>
			run				<function>
```
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

Defaults to 100.000.000 function calls. Can be set to any value, to prevent accidently launching a test that could
take hours to complete or hang your system..
___
**Speed.warmupCycles**
> `<number> Speed.warmupCycles`

Defaults to 1.000.000 cycles.
___
**Speed.run**
> `<function> Speed.run( callback, calls, rounds, details, name= 'anonymus' )`

The static method available, can instanlty run a test.
```javascript
Speed.run( function(){
	var speed= new Speed();
}, 100000, 8);
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

Runs all functions set with .add. If name and/or callback is set, .run will override the already added functions,
not running them. This can come in handy if you have some tests set up, and you want to do some quick manual test
apart from the others.
```javascript
var speed= new Speed();

speed.run( function(){
	var thisThing= 'inhibiting the other tests..';
}, 1000000, 5);
```
___

___
change log
==========

**0.1.0**

Initial commit.

___
**additional**

I am always open for feature requests or any feedback. You can reach me at Github.
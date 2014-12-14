speed.js
========
<br/>
***A quick rudimentary speed test for algorithms***

<br/>
___
**A basic example**
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
// *speed-test* -> "create Object instances", run 3 rounds 10.000.000 calls
// round: 1:    469 ms
// round: 2:    447 ms
// round: 3:    449 ms
// average time for  10.000.000 calls :    455 ms
// total time for    30.000.000 calls :  1.367 ms
//
// *speed-test* -> "create Object literals", run 3 rounds 10.000.000 calls
// round: 1:    110 ms
// round: 2:     42 ms
// round: 3:     42 ms
// average time for  10.000.000 calls :     65 ms
// total time for    30.000.000 calls :    195 ms
```
As you can see in the output, despite the internal warmup function, the first round always takes more time to run.
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

Should follow soon..

```html
object overview

	Speed			<object>
		formatInterval	<number>
		formatChar		<string>
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



___
change log
==========

**0.1.0**

Initial commit.

___
**additional**

I am always open for feature requests or any feedback. You can reach me at Github.
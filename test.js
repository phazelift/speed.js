const Speed= require( './speed.min.js' );


// create an instance with specific settings
const test= new Speed({
	rounds	: 3,					// 3 rounds
	calls		: 10000000,			// 10.000.000 function calls per round
	details	: false,				// hide details for each round
	file		: './speed.log'	// write log output also to file
});


// add some tests
test	
	// quiz, which one takes the most time to run ;)
	.add( 'create Object instances', () => new Object() )
	.add( 'create Object literals', () => {} )
	.add( 'create Number literals', () => 42 )
	.add( 'create String literals', () => "Hello World!" )
	.add( 'create RegExp instances', () => new RegExp() )
	.add( 'create Date instances', () => new Date() )
	.add( () => null )
	.add( () => undefined );

// run them all
test.run();
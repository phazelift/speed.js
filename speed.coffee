# speed.coffee - A quick rudimentary Javascript speed test utility, written in Coffeescript.
#
# Copyright (c) 2014 Dennis Raymondo van der Sluis
#
# This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>

"use strict"

#---------------------------------------------------------------------------------------------------
#
#												from types.js v1.5.1
#

instanceOf	= ( type, value ) -> value instanceof type
# type defaults to object, for internal can do, saves for a few bytes..
typeOf		= ( value, type= 'object' ) -> typeof value is type

LITERALS=
	'Boolean'	: false
	'String'		: ''
	'Object'		: {}
	'Array'		: []
	'Function'	: ->
	'Number'		: do ->
		number= new Number
		number.void= true
		return number

TYPES=
	'Undefined'		: ( value ) -> value is undefined
	'Null'			: ( value ) -> value is null
	'Function'		: ( value ) -> typeOf value, 'function'
	'Boolean'		: ( value ) -> typeOf value, 'boolean'
	'String'			: ( value ) -> typeOf value, 'string'
	'Array'			: ( value ) -> typeOf(value) and instanceOf Array, value
	'RegExp'			: ( value ) -> typeOf(value) and instanceOf RegExp, value
	'Date'			: ( value ) -> typeOf(value) and instanceOf Date, value
	'Number'			: ( value ) -> typeOf(value, 'number') and (value is value) or ( typeOf(value) and instanceOf(Number, value) )
	'Object'			: ( value ) -> typeOf(value) and (value isnt null) and not instanceOf(Boolean, value) and not instanceOf(Number, value) and not instanceOf(Array, value) and not instanceOf(RegExp, value) and not instanceOf(Date, value)
	'NaN'				: ( value ) -> typeOf(value, 'number') and (value isnt value)
	'Defined'		: ( value ) -> value isnt undefined

TYPES.StringOrNumber= (value) -> TYPES.String(value) or TYPES.Number(value)

Types= _=
	parseIntBase: 10

createForce= ( type ) ->

	convertType= ( value ) ->
		switch type
			when 'Number' then return value if (_.isNumber value= parseInt value, _.parseIntBase) and not value.void
			when 'String' then return value+ '' if _.isStringOrNumber value
			else return value if Types[ 'is'+ type ] value

	return ( value, replacement ) ->
		return value if value? and undefined isnt value= convertType value
		return replacement if replacement? and undefined isnt replacement= convertType replacement
		return LITERALS[ type ]


testValues= ( predicate, breakState, values= [] ) ->
	return ( predicate is TYPES.Undefined ) if values.length < 1
	for value in values
		return breakState if predicate(value) is breakState
	return not breakState

breakIfEqual= true
do -> for name, predicate of TYPES then do ( name, predicate ) ->

	Types[ 'is'+ name ]	= predicate
	Types[ 'not'+ name ]	= ( value ) -> not predicate value
	Types[ 'has'+ name ]	= -> testValues predicate, breakIfEqual, arguments
	Types[ 'all'+ name ]	= -> testValues predicate, not breakIfEqual, arguments
	Types[ 'force'+ name ]= createForce name if name of LITERALS

#
# end of types.js selection
#-----------------------------------------------------------------------------------------------------------
#
#														from tools.js v0.1.4

extend= ( target= {}, source, append ) ->
	for key, value of source
		if _.isObject value
     		extend target[ key ], value, append
      else
			target[ key ]= value if not ( append and target.hasOwnProperty key )
	return target

_.append= ( target, source ) -> extend _.forceObject( target ), _.forceObject( source ), true

#
#----------------------------------------------------------------------------------------------------------
#

#--------------------------------------------------------------------------------------

class Speed

#														Speed Private part
#

	format= ( nr, interval= 3, char= '.' ) ->
		return '' if '' is nr= _.forceString nr

		length	= nr.length- 1
		formatted= nr[ length-- ]
		return formatted if length < 0

		pos= interval
		for index in [length..0]
			if ( --pos % interval ) is 0
				formatted= char+ formatted
				pos= interval
			formatted= nr[ index ]+ formatted

		return formatted


	align= ( string, length= 20 ) ->
		length-= string.length
		aligned= ''
		if length > 0
			for n in [1..length]
				aligned+= ' '
		if align.right
			return aligned+ string
		return string+ aligned

	align.right	= true;

	tooMany= ( calls ) ->
		if calls > Speed.maxCalls
			console.log 'You are trying to run more than '+ format(Speed.maxCalls)+ ' calls, increase Speed.maxCalls if you really want this.'
			console.log 'Aborting..'
			return true

	warmup= -> n= n for n in [1..Speed.warmupCycles]


	resolveNameFunc= ( ctx, name, func ) ->
		if _.isFunction name
			func= name
			name= 'anonymus-'+ ++ctx.anonymusCount
		return [ name, func ]

#
#															Speed Static part
#

	@Types				: Types

	# static defaults
	@details			: false
	@rounds				: 1
	@calls				: 1
	@maxCalls			: 100000000
	@warmupCycles	: 1000000


	@run: ( callback, calls, rounds, details, name= 'anonymus' ) ->

		return console.log name if not callback= _.forceFunction callback, null

		rounds		= _.forceNumber rounds, Speed.rounds
		calls			= _.forceNumber calls, Speed.calls
		details		= _.forceBoolean details, Speed.details

		return if tooMany rounds* calls

		console.log '*speed.js* -> "'+name + '", '+ format(rounds)+ ' rounds ' + format(calls)+ ' calls'

		warmup()

		kickOff= Date.now()
		for round in [1..rounds]
			count	= 0
			start	= Date.now()
			callback() while count++ < calls
			end	= Date.now()
			if details
				console.log 'round: '+ round+ ': '+ align ( (end- start)+ ' ms' ), 9

		totalElapsed= Date.now()- kickOff
		average= format ~~( totalElapsed/ rounds )

		totalElapsed= format totalElapsed
		console.log 'average time for '+ align( format(calls)+ ' calls : ' )+ align (average+ ' ms'), 9
		console.log 'total time for   '+ align( format(calls* rounds)+ ' calls : ' )+ align (totalElapsed+ ' ms'), 9
		console.log()

#
#															Speed Dynamic part
#

	constructor: ( settings ) ->
		_.append this, settings
		@callbacks		= {}
		@anonymusCount	= 0

	add: ( name, func ) ->
		[ name, func ]= resolveNameFunc @, name, func
		@callbacks[ name ]= func if ( not @callbacks[name] ) and _.isFunction func
		return @

	run: ( name, func ) ->
		[ name, func ]= resolveNameFunc @, name, func
		if name?
			Speed.run func, @calls, @rounds, @details, name
		else
			for name, callback of @callbacks
				Speed.run callback, @calls, @rounds, @details, name
		return @

# end of Speed
#----------------------------------------------------------------------------------------------

if module?
	module.exports= Speed
else if window?
	window.Speed= Speed
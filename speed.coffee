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

Types	= _ = require 'types.js'
fs		= require 'fs'
util	= require 'util'


class Speed

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

	align.right	= true

	tooMany= ( calls ) ->
		if calls > Speed.maxCalls
			log 'You are trying to run more than '+ format(Speed.maxCalls)+ ' calls, increase Speed.maxCalls if you really want this.'
			log 'Aborting..'
			return true


	resolveNameFunc= ( ctx, name, func ) ->
		if _.isFunction name
			func = name
			name = 'anonymus'
		name = ++ctx.callbackCount + ': ' + name
		return [ name, func ]


	@Types				: Types

	@details				: false
	@rounds				: 1
	@calls				: 1
	@maxCalls			: 100000000
	@file					: './speed.log'
	@log					: (args...) -> console.log args...



	@run: ( callback, calls, rounds, details, name= 'anonymus', warmup ) ->

		return Speed.log(name) if not callback= _.forceFunction callback, null

		rounds		= _.forceNumber rounds, Speed.rounds
		calls			= _.forceNumber calls, Speed.calls
		details		= _.forceBoolean details, Speed.details

		return if tooMany (rounds * calls)

		if not warmup then Speed.log name + ': ' + format(rounds) + ' rounds of ' + format(calls) + ' calls..'

		kickOff= Date.now()
		for round in [1..rounds]
			count	= 0
			start	= Date.now()
			callback() while count++ < calls
			end	= Date.now()
			if details and not warmup then Speed.log 'round: '+ round+ ': '+ align ( (end- start)+ ' ms' ), 9

		totalElapsed= Date.now()- kickOff
		average= format ~~( totalElapsed/ rounds )

		totalElapsed= format totalElapsed
		if not warmup
			Speed.log 'average time for '+ align( format(calls)+ ' calls : ' )+ align (average+ ' ms'), 9
			Speed.log 'total time for   '+ align( format(calls* rounds)+ ' calls : ' )+ align (totalElapsed+ ' ms'), 9
			Speed.log()



	constructor: ( settings ) ->
		settings			= _.forceObject settings
		@rounds			= _.forceNumber settings.rounds, Speed.rounds
		@calls			= _.forceNumber settings.calls, Speed.calls
		@details			= _.forceBoolean settings.details, Speed.details
		@callbacks		= {}
		@callbackCount	= 0

		if settings.file
			@filename = _.forceString settings.file, Speed.file
			@logFile = fs.createWriteStream @filename, {flags: 'w'}
			Speed.log = (args...) =>
				@logFile.write util.format args + '\n'
				console.log args...


	add: ( _name, _func ) =>
		[ name, func ]= resolveNameFunc @, _name, _func
		@callbacks[ name ]= func if ( not @callbacks[name] ) and _.isFunction func
		return @

	run: ( _name, _func ) ->
		Speed.log '*speed.js* - running ' + @callbackCount + ' tests..' + '\n'
		if _.isFunction _name and not _func
			# this first call with last argument is for warmup round without logging
			Speed.run func, @calls, @rounds, @details, name, true
			Speed.run func, @calls, @rounds, @details, name
		else	# run all tests
			Speed.run callback, @calls, @rounds, @details, name, true
			for name, callback of @callbacks
				Speed.run callback, @calls, @rounds, @details, name
		if @logFile then console.log "done! test results have been saved to:", @filename, '\n'
		return @




if module?
	module.exports= Speed
else if window?
	window.Speed= Speed

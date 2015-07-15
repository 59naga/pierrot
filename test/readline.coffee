# Dependencies
EventEmitter= (require 'events').EventEmitter

# Public
class Readline extends EventEmitter
  constructor: ->
    super

    @line= ''
    @output=
      write: (str)->
        @__raw__= str
      
      end: -> this
      mute: -> this
      unmute: -> this
      __raw__: ''

  write: -> this
  moveCursor: -> this
  setPrompt: -> this
  close: -> this
  pause: -> this
  resume: -> this
  _getCursorPos: -> {cols:0,rows:0}

module.exports= Readline

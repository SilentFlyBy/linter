{Range} = require 'atom'
BubbleView = require './bubble-view'

class Bubble
  constructor: (@linter) ->
    @bubble = null

  update: (point) ->
    @remove()
    return unless @linter.view.messages.length
    textEditor = @linter.activeEditor
    found = false
    @linter.view.messages.forEach (message) =>
      return if found
      return unless message.currentFile
      return unless message.Position
      p = message.Position
      errorRange = new Range([p[0][0] - 1, p[0][1] - 1], [p[1][0] - 1, p[1][1]])
      return unless errorRange.containsPoint point
      marker = textEditor.markBufferRange errorRange, {invalidate: 'never'}
      @bubble = textEditor.decorateMarker marker, type: 'overlay', item: BubbleView(@linter, message)
      found = true

  remove: ->
    @bubble?.destroy()

module.exports = Bubble

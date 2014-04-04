{Tool} = window?.MarkingSurface || require 'marking-surface'

class FreeDrawTool extends Tool
  stroke: 'currentColor'
  strokeWidth: 1
  fill: "rgba(255, 0, 0, 0.3)"

  constructor: ->
    super
    @mark.relPath = []
    @path = @addShape 'path', stroke: @stroke, fill: "transparent", strokeWidth: 1
    @path.addEvent "start", @startMove
    @path.addEvent "move", @moveMark

  onInitialStart: (e) ->
    super
    {x, y} = @coords e
    @mark.startingPoint = [x, y]
    @mark.relPath.push [0,0]

  onInitialMove: (e) ->
    super
    {x, y} = @coords e

    @mark.relPath.push [@xDiff(x), @yDiff(y)]

    @mark.set {startingPoint: @mark.startingPoint, relPath: @mark.relPath}
    @render()

  onInitialRelease: (e) ->
    super
    @path.attr {fill: @fill}
    @render()

  xDiff: (x) ->
    x - (@mark.startingPoint[0] + (p[0] for p in @mark.relPath).reduce (acc, p) -> acc + p)

  yDiff: (y) ->
    y - (@mark.startingPoint[1] + (p[1] for p in @mark.relPath).reduce (acc, p) -> acc + p)

  startMove: (e) =>
    {x, y} = @coords e
    @xOffset = x - @mark.startingPoint[0]
    @yOffset = y - @mark.startingPoint[1]

  moveMark: (e) =>
    {x, y} = @coords e

    @mark.startingPoint = [x - @xOffset, y - @yOffset]
    @mark.set {startingPoint: @mark.startingPoint}

  render: ->
    super
    if @mark.relPath.length > 1
      @path.attr {d: @pathDescription()}

  pathDescription: ->
    "m #{@mark.startingPoint}, #{@mark.relPath.join(',')} #{if @isComplete() then ' Z' else ''}"

window?.MarkingSurface.FreeDrawTool = FreeDrawTool
module?.exports = FreeDrawTool

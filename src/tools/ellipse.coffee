{Tool} = window?.MarkingSurface || require 'marking-surface'

class EllipseTool extends Tool
  handleRadius: if @mobile then 20 else 10
  strokeWidth: 2

  defaultRadius: 2
  defaultSquash: 0.5

  startOffset: null

  constructor: ->
    super

    @mark.x = 0
    @mark.y = 0
    @mark.angle = 0
    @mark.rx = 0
    @mark.ry = 0

    @radii = @addShape 'path.radii', stroke: 'currentColor'
    @outline = @addShape 'ellipse.outline', fill: 'transparent', stroke: 'currentColor'
    @xHandle = @addShape 'circle.x-handle', fill: 'currentColor'
    @yHandle = @addShape 'circle.y-handle', fill: 'currentColor'

    @addEvent 'marking-surface:element:start', '.outline', @startDrag
    @addEvent 'marking-surface:element:move', '.outline', @moveOutline
    @addEvent 'marking-surface:element:move', '.x-handle', @dragXHandle
    @addEvent 'marking-surface:element:move', '.y-handle', @dragYHandle

  onInitialStart: (e) ->
    super
    {x, y} = @coords e

    @mark.set
      x: x
      y: y
      rx: @defaultRadius
      ry: @defaultRadius * @defaultSquash

  onInitialMove: (e) ->
    super
    @dragXHandle e
    @mark.set 'ry', @mark.rx * @defaultSquash

  startDrag: (e) ->
    {x, y} = @coords e
    @startOffset =
      x: @mark.x - x
      y: @mark.y - y

  moveOutline: (e) ->
    {x, y} = @coords e
    @mark.set
      x: x + @startOffset.x
      y: y + @startOffset.y

  dragXHandle: (e) ->
    {x, y} = @coords e
    @mark.set
      angle: @getAngle @mark.x, @mark.y, x, y
      rx: @getDistance @mark.x, @mark.y, x, y

  dragYHandle: (e) ->
    {x, y} = @coords e
    @mark.set
      angle: @getAngle(@mark.x, @mark.y, x, y) - 90
      ry: @getDistance @mark.x, @mark.y, x, y

  render: ->
    super

    scale = (@markingSurface?.scaleX + @markingSurface?.scaleY) / 2
    strokeWidth = @strokeWidth / scale
    handleRadius = @handleRadius / scale

    @radii.attr 'strokeWidth', strokeWidth / 2
    @outline.attr 'strokeWidth', strokeWidth
    @xHandle.attr 'r', handleRadius
    @yHandle.attr 'r', handleRadius

    # NOTE: SVG rotates clockwise, angles are measured counterclockwise.
    @attr 'transform', "translate(#{@mark.x}, #{@mark.y}) rotate(#{-@mark.angle})"

    @radii.attr 'd', "M 0 #{-@mark.ry} L 0 0 M #{@mark.rx} 0 L 0 0"
    @outline.attr rx: @mark.rx, ry: @mark.ry
    @xHandle.attr 'cx', @mark.rx
    @yHandle.attr 'cy', -@mark.ry

    @controls?.moveTo @mark

  getAngle: (x1, y1, x2, y2) ->
    deltaX = x2 - x1
    deltaY = y2 - y1
    Math.atan2(deltaY, deltaX) * (-180 / Math.PI)

  getDistance: (x1, y1, x2, y2) ->
    aSquared = Math.pow x2 - x1, 2
    bSquared = Math.pow y2 - y1, 2
    Math.sqrt aSquared + bSquared

window?.MarkingSurface.EllipseTool = EllipseTool
module?.exports = EllipseTool

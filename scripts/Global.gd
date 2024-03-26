extends Node

const CARD_SIZE = Vector2(822, 1122)
const CARD_DRAW_OFFSET = Vector2(-411, -561)

var CARD_SHAPE = RectangleShape2D.new()
var CARD_COLLISION = CollisionShape2D.new()

var GLYPH_EMPTY = Glyph.new()

# Temporary vectors.
var tmpv1 = Vector2()
var tmpv2 = Vector2()
var tmpv3 = Vector2()


func _init():
	CARD_SHAPE.set_size(CARD_SIZE)
	CARD_COLLISION.set_shape(CARD_SHAPE)

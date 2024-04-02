extends Node
class_name Glyph

@export var glyph_name = "empty"
# each rarity level has a lower and lower chance of appearing.
@export var rarity : int
# used for determining which glyph of the card goes on top.
@export var value : int
# set greater than 0 to force the color on affected halves to be this one.
@export var color = -1
# disable for special cards like those in ui.
@export var allow_autogen = false
# makes cards generate with an empty glyph in the second slot.
@export var full_card = false
# ignores the placement restrictions of the other glyph on a card.
@export var override_placement = false
@export var force_accents = false
@export var texture : Texture2D # TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
var card : Card

func _process(_delta):
	if Settings.game_theme and not texture: texture = Settings.game_theme.get_glyph_tex(glyph_name)

# These are both static and dynamic objects at once. I am mildly disgusted.
func initialize(c:Card):
	card = c
	if color < 0: color = randi_range(0, 3)
	if force_accents: card.accented = true

func _ready():
	Global.register_glyph(self)
	if(full_card): Global.register_glyph(self) # this is the easiest way to counteract the halved chance of appearing

func allow_placement():
	return true

func trigger(): for i in get_children(): i.trigger()

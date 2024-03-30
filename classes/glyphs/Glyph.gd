extends Node
class_name Glyph

@export var glyph_name = "empty"
# each rarity level has a lower and lower chance of appearing.
@export var rarity : int
# used for determining which glyph of the card goes on top.
@export var value : int
# disable for special cards like those in ui.
@export var allow_autogen = false
# force cards to not produce cursed images like a half "start match" card.
@export var force_full_card = false
# force the color on affected halves to be this one. This takes full cards into account.
@export var force_color = -1
# ignores the placement restrictions of the other glyph on a card.
@export var override_placement = false
@export var force_accents = false
@export var texture : Texture2D # TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO
var color = -1
var card : Card

func _process(_delta):
	if Settings.game_theme and not texture: texture = Settings.game_theme.get_glyph_tex(glyph_name)

# These are both static and dynamic objects at once. I am mildly disgusted.
func initialize(c:Card):
	card = c
	if force_color >= 0: color = force_color
	else: if color < 0: color = randi_range(0, 3)
	
	if force_accents: card.accented = true

func _ready():
	Global.register_glyph(self)
	if(force_full_card): Global.register_glyph(self) # this is the easiest way to counteract the halved chance of appearing

func allow_placement(parent:Card, other:Card):
	return true

func trigger():
	if get_children():
		for i in get_children():
			i.trigger()

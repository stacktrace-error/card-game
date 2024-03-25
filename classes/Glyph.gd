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
@export var force_color : int

var texture : Texture2D

func _process(delta):
	if not texture: texture = Settings.game_theme.get_glyph_tex(glyph_name)

func _ready():
	Settings.register_glyph(self)

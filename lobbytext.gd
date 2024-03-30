extends Label


func _process(delta):
	var p = Multiplayer.get_children().filter(func(x): return x is Player)
	
	text = ""
	for i in p:
		text = str(text, i.player_name, ": ", i.name, "\n")

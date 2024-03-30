extends Label


func _process(delta):
	if multiplayer.multiplayer_peer.get_unique_id(): text = str(multiplayer.multiplayer_peer.get_unique_id())
	else: text = "Not networking."

extends MultiplayerSpawner

var peer = ENetMultiplayerPeer.new()
var p = preload("res://scenes/player.tscn")


func _ready():
	spawn_path = "."
	add_spawnable_scene(p.resource_path)
	add_player(1, false)

func create_server():
	peer.create_server(8998)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(func(_id): find_child(str(_id)).call_defered("free"))

func close_server():
	peer.close()

func add_player(_id = 1, deferred = true):
	var _player = p.instantiate()
	_player.name = str(_id)
	if deferred: add_child.call_deferred(_player)
	else: add_child(_player)

func join_server():
	peer.create_client("10.242.31.243", 8998)
	multiplayer.multiplayer_peer = peer

func leave_server():
	pass

func player(_id): return find_child(str(_id))

func id(): return multiplayer.multiplayer_peer.get_unique_id()

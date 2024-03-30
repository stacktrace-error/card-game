extends Node

var peer = ENetMultiplayerPeer.new()
var p = preload("res://player.tscn")


func _ready():
	var s = MultiplayerSpawner.new()
	s.spawn_path = get_path_to(self)
	s.add_spawnable_scene(p.resource_path)

func create_server():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(func(id): find_child(str(id)).call_defered("free"))
	add_player()

func close_server():
	peer.close()

func add_player(id = 1):
	var player = p.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func join_server():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer

func leave_server():
	pass

func id(): return multiplayer.multiplayer_peer.generate_unique_id()

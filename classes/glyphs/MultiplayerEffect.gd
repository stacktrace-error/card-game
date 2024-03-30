extends Effect

@export var function = 0

func trigger():
	match function:
		0: Multiplayer.create_server()
		1: Multiplayer.join_server()
		2: Multiplayer.close_server()
		3: Multiplayer.leave_server()

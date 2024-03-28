extends Camera2D

var balls = Vector2(0.1, 0.1)

func _input(event):
	if event.is_action_pressed("up"):
		zoom += balls
	if event.is_action_pressed("down"):
		zoom -= balls

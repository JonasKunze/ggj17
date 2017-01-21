extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var player1 = load("res://player/player.tscn").instance()
	player1.get_node("player").playerNumber = 0
	add_child(player1)
	player1.set_translation(Vector3(5, 0, 0))
	var player2 = load("res://player/player.tscn").instance()
	player2.get_node("player").playerNumber = 1
	player2.set_translation(Vector3(-5, 0, 0))
	add_child(player2)

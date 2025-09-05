extends Timer
@onready var current_scene: Node2D = $".."
const BOULDER = preload("res://scenes/Boulder.tscn")


func _on_timeout() -> void:
	var new_boulder = BOULDER.instantiate()
	new_boulder.position = Vector2(100,-100)
	current_scene.add_child(new_boulder)
	
	

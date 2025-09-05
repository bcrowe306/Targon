extends Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.kill() # Replace with function body.

extends AudioStreamPlayer

var loop: bool = true
func _on_rigid_body_2d_movement(is_moved: bool) -> void:
	if is_moved and not playing:
		pass
	else:
		pass # Replace with function body.

func _on_finished() -> void:
	if loop:
		pass # Replace with function body.

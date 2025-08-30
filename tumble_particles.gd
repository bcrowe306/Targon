extends CPUParticles2D


func _on_player_direction_changed(d: int) -> void:
	if d > 0:
		direction.x = -1
	elif d < 0:
		direction.x = 1 # Replace with function body.




func _on_player_state_changed(state: int) -> void:
	if state == GlobalEnums.CharacterState.TUMBLE:
		self.emitting = true
	else:
		self.emitting = false # Replace with function body.

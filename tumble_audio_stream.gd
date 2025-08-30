extends AudioStreamPlayer2D


func _on_player_state_changed(state: int) -> void:
	if state == GlobalEnums.CharacterState.TUMBLE:
		play()
	else:
		if playing:
			stop() # Replace with function body.

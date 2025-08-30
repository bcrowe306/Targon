extends AudioStreamPlayer


func _on_player_state_changed(state: int) -> void:
	if state == GlobalEnums.CharacterState.STOMP:
		play()
	else:
		if playing:
			pass # Replace with function body.

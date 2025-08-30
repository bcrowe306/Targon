extends Label


func _on_player_state_changed(state: int) -> void:
	pass


func _on_health_node_changed(health: float, delta: float) -> void:
	text = str(health)# Replace with function body.

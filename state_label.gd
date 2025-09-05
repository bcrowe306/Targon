extends Label
@onready var player: Player = $".."



func _on_player_state_changed(state: int) -> void:
	pass


func _on_health_node_changed(health: float, _delta: float) -> void:
	pass


func _on_player_loot_coins_changed(coins: int, delta: int) -> void:
	text = str(coins) # Replace with function body.


func _on_state_machine_state_changed(current_state: String, next_state: String) -> void:
	text = next_state # Replace with function body.

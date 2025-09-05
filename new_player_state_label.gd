extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_state_machine_state_changed(current_state: String, next_state: String) -> void:
	text = next_state # Replace with function body.

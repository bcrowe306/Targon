extends Timer

var expired: bool = true:
	get():
		return expired
	set(value):
		if value != expired:
			expired = value
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_attack(attack_number: int) -> void:
	expired = false
	start() # Replace with function body.
	


func _on_timeout() -> void:
	expired = true # Replace with function body.

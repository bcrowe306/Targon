extends Timer

signal expired_changed(expired: bool)

@onready var playerNode := $".."
# Called when the node enters the scene tree for the first time.
var expired: bool = true:
	get():
		return expired
	set(value):
		if value != expired:
			expired = value
			expired_changed.emit(expired)
			

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_character_body_2d_state_changed(state: int) -> void:
	if state == 3: # Fall State
		expired = false
		self.start()
	elif state == 2: # Jump state
		self.stop()


func _on_timeout() -> void:
	expired = true

extends State
@onready var new_player: CharacterBody2D = $"../.."
var ended: bool = true

func _ready() -> void:
	animated_sprite.animation_finished.connect(self.on_finished)

func _update(delta: float):
	if not ended:
		new_player.velocity.x += 500 * new_player.direction
	else:
		new_player.velocity.x = 0

func _enter(prev_state: String):
	new_player.velocity.x = 0
	animated_sprite.play(animation_name)
	audio_stream.play()
	ended = false

func on_finished():
	new_player.velocity.x -= 100
	ended = true
	
func state_guard(next_state: String) -> bool:
	if next_state == "Jump" or next_state == "Jump2" or next_state == "Tumble" or next_state == "Attack1":
		return true
	else:
		return ended

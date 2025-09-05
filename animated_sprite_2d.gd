extends AnimatedSprite2D
@onready var character_body_2d: CharacterBody2D = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_and_play_animation("Idle") # Replace with function body.


func _on_character_body_2d_state_changed(state: int) -> void:
	var d :float = character_body_2d.direction
	_on_mob_boar_white_direction_changed(d)
	if state == GlobalEnums.CharacterState.IDLE:
		return set_and_play_animation("Idle")
	if state == GlobalEnums.CharacterState.WALK:
		return set_and_play_animation("Walk")
	if state == GlobalEnums.CharacterState.HIT:
		return set_and_play_animation("Hit")
	if state == GlobalEnums.CharacterState.DYING:
		return set_and_play_animation("Dying")

func set_and_play_animation(animation_name: String):
	self.animation = animation_name
	play()
	return

	


func _on_mob_boar_white_direction_changed(direction: int) -> void:
	if direction > 0:
		flip_h = true
	elif direction < 0:
		flip_h = false # Replace with function body.

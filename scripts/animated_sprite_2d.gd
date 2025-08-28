extends AnimatedSprite2D

@onready var playerNode := $".."
@onready var sword : Area2D = $"../Sword"
@onready var audio_stream_player: AudioStreamPlayer = $"../FootStepsPlayer"

var animationStateMap = {
	0: "Idle",
	1: "Run",
	2: "Jump",
	3: "Stomp",
	4: "Attack1"
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.animation = "Idle"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_state_changed(state: int) -> void:
	var animationName : String = animationStateMap[state]
	if self.animation == "Attack1" or self.animation == "Attack2":
		pass
	else:
		play(animationName)


func _on_character_body_2d_direction_changed(direction: int) -> void:
	if direction < 0:
		flip_h = true
	elif direction > 0:
		flip_h = false
	else:
		pass # Replace with function body.
		

func _on_player_attack(attack_number: int) -> void:
	var attackAnimationName : String
	if attack_number == 0:
		attackAnimationName = "Attack1"
	elif attack_number == 1:
		attackAnimationName = "Attack2"
	else:
		attackAnimationName = "Attack1"
	play(attackAnimationName)
	set_frame_and_progress(0,0)


func _on_animation_finished() -> void:
	if self.animation == "Attack1" or self.animation == "Attack2":
		var pState = playerNode.state # Replace with function body.
		var animationName : String = animationStateMap[pState]
		play(animationName)
	 
func _is_attack() -> bool:
	return self.animation == "Attack1" or self.animation == "Attack2"


func _on_frame_changed() -> void:
	if _is_attack():
		if frame == 0 or frame == 3:
			sword.monitoring = false
		else:
			sword.monitoring = true
	if animation == "Run":
		if frame % 4 == 0:
			audio_stream_player.play()
			

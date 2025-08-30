extends AnimatedSprite2D

@onready var playerNode := $".."
@onready var sword : Area2D = $"../Sword"
@onready var audio_stream_player: AudioStreamPlayer = $"../FootStepsPlayer"



var animationStateMap = {
	GlobalEnums.CharacterState.IDLE: "Idle",
	GlobalEnums.CharacterState.RUN: "Run",
	GlobalEnums.CharacterState.JUMP: "Jump",
	GlobalEnums.CharacterState.FALL: "Fall",
	GlobalEnums.CharacterState.ATTACK1: "Attack1",
	GlobalEnums.CharacterState.ATTACK2: "Attack2",
	GlobalEnums.CharacterState.ATTACK3: "Attack1",
	GlobalEnums.CharacterState.STOMP: "Stomp",
	GlobalEnums.CharacterState.TUMBLE: "Tumble",
	GlobalEnums.CharacterState.HIT: "Hit",
	GlobalEnums.CharacterState.DYING: "Dying"
	
}

var mustFinishBeforeChange: Array[String] = [
	"Attack1",
	"Attack2",
	"Hit"
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.animation = "Idle"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_state_changed(state: int) -> void:
	var animationName : String = animationStateMap[state]
	play(animationStateMap[state])


func _on_character_body_2d_direction_changed(direction: int) -> void:
	if direction < 0:
		flip_h = true
	elif direction > 0:
		flip_h = false
	else:
		pass # Replace with function body.
		
	 
func _is_attack() -> bool:
	return self.animation == "Attack1" or self.animation == "Attack2"

func _must_finish() -> bool:
	for a in mustFinishBeforeChange:
		if a == animation:
			return true
	return false
	

func is_animation_finished() -> bool:
	var is_loop: bool = sprite_frames.get_animation_loop(animation)
	var end_of_animation: bool = frame ==  sprite_frames.get_frame_count(animation) - 1
	if is_loop:
		return true
	else:
		if _must_finish():
			return end_of_animation
		else:
			return true
		

func _on_frame_changed() -> void:
	if animation == "Run":
		if frame % 4 == 0:
			audio_stream_player.play()
			

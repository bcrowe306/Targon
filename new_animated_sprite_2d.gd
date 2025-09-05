extends AnimatedSprite2D
@onready var new_player: CharacterBody2D = $".."
@onready var run_particles: CPUParticles2D = $"../RunParticles"
@onready var run_step_audio: AudioStreamPlayer = $"../RunStepAudio"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if new_player.facing_direction:
		flip_h = false
	else:
		flip_h = true
		
			
func _on_frame_changed() -> void:
	if animation == "Run":
		if frame == 1 or frame == 5:
			run_particles.restart()
			if frame == 5:
				run_step_audio.pitch_scale = 1
			else:
				run_step_audio.pitch_scale = 1.05
			run_step_audio.play()

extends Area2D
@onready var armor_timer: Timer = $ArmorTimer
@onready var armor_sfx_1: AudioStreamPlayer = $ArmorSFX1
@onready var armor_sfx_2: AudioStreamPlayer = $ArmorSFX2
@onready var armor_particles: CPUParticles2D = $ArmorParticles
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default") # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		self.monitoring = false
		set_collision_mask_value(2, false)
		armor_timer.start()
		armor_particles.restart()
		armor_sfx_1.play()
		armor_sfx_2.play()
		animated_sprite_2d.visible = false
		animated_sprite_2d.stop()
		body.collect_armor(10.0)
	 # Replace with function body.


func _on_armor_timer_timeout() -> void:
	queue_free() # Replace with function body.

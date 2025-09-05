extends Area2D

@onready var coin_particles: CPUParticles2D = $CoinParticles
@onready var coin_sprite: Sprite2D = $CoinSprite
@onready var coin_animation: AnimationPlayer = $CoinAnimation
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var coin_timer: Timer = $CoinTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_animation.play("Spin") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		monitoring = false
		set_collision_mask_value(2, false)
		coin_timer.start()
		coin_particles.restart()
		coin_sound.play()
		coin_sprite.visible = false
		coin_animation.stop()
		body.collect_coins(1)
	 # Replace with function body.


func _on_coin_timer_timeout() -> void:
	queue_free() # Replace with function body.

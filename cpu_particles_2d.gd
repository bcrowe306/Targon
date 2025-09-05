extends CPUParticles2D
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_health_node_died() -> void:
	self.restart() # Replace with function body.



func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d:
		
		if animated_sprite_2d.animation == "Run":
			if animated_sprite_2d.frame % 4 == 0:
				self.restart() # Replace with function body.

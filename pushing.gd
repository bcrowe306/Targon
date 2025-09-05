extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _enter(_prev: String ):
	animated_sprite.play(animation_name)

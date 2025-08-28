extends AudioStreamPlayer
const DESIGNED_PICKAXE_2 = preload("res://resources/sfx/DesignedPickaxe2.wav")
const DESIGNED_PICKAXE_3 = preload("res://resources/sfx/DesignedPickaxe3.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_health_node_damaged(health: float, delta: float) -> void:
	if health == 0:
		stream =DESIGNED_PICKAXE_3
	else:
		stream = DESIGNED_PICKAXE_2
	play() # Replace with function body.

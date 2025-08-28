extends Timer
@onready var current_scene: Node2D = $".."
const BOULDER = preload("res://scenes/Boulder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	var new_boulder = BOULDER.instantiate()
	new_boulder.position = Vector2(100,-100)
	current_scene.add_child(new_boulder)
	
	

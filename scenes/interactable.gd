extends RigidBody2D

var external_position: Vector2
var interacting: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if interacting:
		freeze = true
		position = external_position # Set your desired new position
	else:
		freeze = false
		
		#var new_transform = state.get_transform()
		#new_transform.origin = external_position# Set your desired new position
		#state.set_transform(new_transform)

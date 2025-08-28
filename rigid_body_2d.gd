extends RigidBody2D

@onready var rockNode: Sprite2D = $CollisionPolygon2D/Sprite2D
# Called when the node enters the scene tree for the first time.
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cpu_particles_2d_finished() -> void:
	collision_polygon_2d.disabled = true
	queue_free()


func _on_health_node_died() -> void:
	
	rockNode.visible = false # Replace with function body.

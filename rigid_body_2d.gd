extends RigidBody2D

# Called when the node enters the scene tree for the first time.
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite_2d: Sprite2D = $Sprite2D

signal movement(is_moved: bool)

var pos: Vector2
var rot: float
var moved: bool = false:
	get():
		return moved
	set(value):
		if value != moved:
			moved = value
			movement.emit(value)

func _ready() -> void:
	pos = position # Replace with function body.
	rot = rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if position != pos or rotation != rot:
		moved = true
	else:
		moved = false
	pos = position
	rot = rotation


func _on_cpu_particles_2d_finished() -> void:
	queue_free()


func _on_health_node_died() -> void:
	sprite_2d.visible = false
	set_collision_layer_value(4, false)

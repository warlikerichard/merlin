extends StaticBody2D

class_name JumpableWall

@onready var collision_area : Area2D = $CollisionShape2D/Area2D
@onready var player : Player = get_tree().get_first_node_in_group("Player")

@export var max_fall_velocity := 380.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_area.connect("body_entered", _on_body_entered)
	collision_area.connect("body_exited", _on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_wall_jumping(delta)

func _on_body_entered(body):
	if body is Player:
		#body.velocity.y = 0
		body.is_wall_jumping = true
		body.left_or_right_wall = (global_position - body.global_position).x
			
func _on_body_exited(body):
	if body is Player:
		body.is_wall_jumping = false

func handle_wall_jumping(delta: float):
	if player.is_wall_jumping:
		if player.velocity.y <= 0:
			player.velocity.y = lerp(player.velocity.y, 1.0, 7*delta)
		else:
			player.velocity.y = lerp(player.velocity.y, max_fall_velocity, 1*delta)

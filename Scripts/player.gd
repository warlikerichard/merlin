extends Character
class_name Player

@export var SPEED = 600.0
@export var AIR_SPEED = 400.0
@export var JUMP_VELOCITY = -600.0
@export var wall_jump_force := 1000.0
@export var dexterity := 1
@export var force := 1
@export var charisma := 1
var direction := 0.0
var prev_direction := 0.0
var just_pressed_jump := false
var released_jump := false
var is_wall_jumping := false
var left_or_right_wall := 0

@onready var animations : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_animations()
	move_and_slide()

#Handles animations
func handle_animations():
	if is_on_floor():
		animations.flip_h = false
	
	#Idle
	if direction == 0 and is_on_floor():
		if prev_direction < 0:
			animations.play("IdleLeft")
		else:
			animations.play("IdleRight")
	
	#Run
	elif direction < 0 and is_on_floor():
		prev_direction = direction
		animations.play("RunLeft")
		
	elif direction > 0 and is_on_floor():
		prev_direction = direction
		animations.play("RunRight")
		
	#Jump and fall
	elif not is_on_floor() and not is_wall_jumping:
		if prev_direction < 0:
			animations.flip_h = true
		elif prev_direction > 0:
			animations.flip_h = false
		
		if just_pressed_jump:
			just_pressed_jump = false
			animations.play("JumpRight")
			await animations.animation_finished
			animations.play("FallingRight")
		elif animations.animation == "JumpRight":
			await animations.animation_finished
			animations.play("FallingRight")
		else:
			animations.play("FallingRight")
		
	#Wall Jumping	
	elif is_wall_jumping:
		animations.flip_h = false
		if left_or_right_wall < 0:
			animations.play("GrabWallLeft")
		elif left_or_right_wall > 0:
			animations.play("GrabWallRight")
		
#Handles the movement
func handle_movement(delta: float):
	if velocity.x < 0:
		prev_direction = -1.0
	elif velocity.x > 0:
		prev_direction = 1.0
	
	# Add the gravity.
	if not is_on_floor() and not is_wall_jumping:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		just_pressed_jump = true
		
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and not released_jump and velocity.y < 0:
		released_jump = true
		velocity.y *= 0.3
	elif is_on_floor():
		released_jump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/15)
		else:
			velocity.x = move_toward(velocity.x, direction * AIR_SPEED, AIR_SPEED/15)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/15)

	#Handle wall jumping
	if is_wall_jumping and Input.is_action_just_pressed("ui_accept"):
		if left_or_right_wall < 0:
			velocity = Vector2(1.0, -1.8).normalized()*wall_jump_force
		elif left_or_right_wall > 0:
			velocity = Vector2(-1.0, -1.8).normalized()*wall_jump_force

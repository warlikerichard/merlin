extends Node2D

var footsteps = preload("res://Assets/Audio/FX/Walk.ogg")
var jump = preload("res://Assets/Audio/FX/Jump.ogg")
var land = preload("res://Assets/Audio/FX/Land.ogg")

var player : Player
var walk_FX1 : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var walk_FX2 : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var jump_FX : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
var land_FX : AudioStreamPlayer2D = AudioStreamPlayer2D.new()

var just_landed := false

func _ready() -> void:
	player = get_parent()
	
	walk_FX1.stream = footsteps
	walk_FX1.volume_db = -15
	walk_FX2.stream = footsteps
	walk_FX2.volume_db = -15
	add_child(walk_FX1)
	add_child(walk_FX2)
	
	jump_FX.stream = jump
	land_FX.stream = land
	add_child(jump_FX)
	add_child(land_FX)

	player.just_landed.connect(on_player_landed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_footsteps()
	handle_jump()
	handle_land()

func handle_footsteps():
	if player.animations.animation.begins_with("Run") and (player.animations.frame == 2 or player.animations.frame == 5):
		if walk_FX1.playing:
			walk_FX2.pitch_scale = randf_range(0.85, 1.1)
			walk_FX2.play()
		elif walk_FX2.playing:
			walk_FX1.pitch_scale = randf_range(0.85, 1.1)
			walk_FX1.play()
		else:
			walk_FX1.pitch_scale = randf_range(0.85, 1.1)
			walk_FX1.play()
			
func handle_jump():
	if player.just_pressed_jump:
		jump_FX.pitch_scale = randf_range(0.9, 1.2)
		jump_FX.play()

func handle_land():
	if just_landed == true:
		just_landed = false
		land_FX.pitch_scale = randf_range(0.9, 1.2)
		land_FX.play()
	
func on_player_landed():
	just_landed = true

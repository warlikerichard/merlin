@tool
extends CPUParticles2D

@export_range(0, 5) var fire_scale : float = 1:
	set(value):
		fire_scale = value
		print("Fire scale: ", value)
		if Engine.is_editor_hint():
			scale_fire(value)

var original_lifetime = 1.0
var original_emission_scale := 1.0
var original_scale_min_scale := 1.0
var original_scale_max_scale := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_lifetime = lifetime
	original_emission_scale = emission_sphere_radius
	original_scale_min_scale = scale_amount_min
	original_scale_max_scale = scale_amount_max


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func scale_fire(value: float):
	$PointLight2D.scale = Vector2(1,1)*value
	lifetime = original_lifetime*value
	emission_sphere_radius = original_emission_scale*value
	scale_amount_min = original_scale_min_scale*value
	scale_amount_max = original_scale_max_scale*value

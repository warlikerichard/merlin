@icon("res://Resources/Icons/mountains-sun-svgrepo-com.svg")
extends Node2D
##This node intends to be a simple alternative to the Parallax2D node, in a way that you can position
##the objects on the screen without having to worry about the viewport. The idea is simple:
##If you want an object to appear in a certain place in the world of your game when the camera gets near
##that point, that's exactly where that object will show up on your screen. 

class_name ParallaxEnhanced

##How far the objects in this node are from the camera.
##Use a value of 1 for objects that are in the same "layer" as the player, so they will move at the same speed of the camera.
##Use a value higher than 1 for objects that are further (like background mountains or clouds), meaning that they will move slower than the camera.
##Use a value between 0 and 1 for objects that are closer to the camera than the player, so they will move faster than the camera.
##If you want to have an object that follows the screen as a background, mark "Is Background" as true.
@export_range(0.001, 2000.0) var distance : float = 1

##Mark this as true if you want the children of this node to follow the camera.
@export var is_background : bool = false

@export var camera : Camera2D

##You'll want to activate this most times when objects are too far.
##This will ensure that the children's spacing doesn't change. For example, if there's a space os 200 pixels
##between objectA and objectB, that will be preserved when you hit play.
##However, by activating this, the objects you putted on the screen won't show in the exact same places when the camera
##gets near their original position.
@export var preserve_spacing := false

@export_group("Repeating")
@export var repeating_amount : int = 0
@export var repeating_offset : int = 0

@export_group("Visuals")
@export var toggle_atmosphere := false

#Variables
@onready var images : Array[Node2D] = []
@onready var positions : Array[Vector2] = []
var center : Node2D = Node2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if repeating_amount > 0:
		process_repeating()
	
	if preserve_spacing:
		var average_pos := Vector2(0, 0)
		#Get sum of all children positions
		for child in get_children():
			if child is Node2D:
				average_pos += child.global_position
		
		center.global_position = average_pos/get_children().size()
		add_child(center)
		
		for child in get_children():
			if child is Node2D and child != center:
				child.reparent(center)
		
	for child in get_children():
		if child is Node2D:
			images.append(child)
			positions.append(child.global_position)
	
	if toggle_atmosphere:
		process_images_atmosphere()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_images_position()
	
	if repeating_amount > 0:
		process_repeating()

func process_images_position():
	for i in range(len(images)):
		if is_background:
			images[i].global_position = camera.get_target_position()
		else:
			images[i].global_position = camera.get_target_position() + (positions[i] - camera.get_target_position())/distance

func process_images_atmosphere():
	for image in images:
		var opacity := image.modulate.a
		image.modulate = Color.SKY_BLUE/(pow(distance, 0.5))
		image.modulate.a = opacity

func process_repeating():
	pass

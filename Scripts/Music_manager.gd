extends Node

enum {MAIN_MENU, EXPLORING, COMBAT, DEATH, END_COMBAT}
var current_state = EXPLORING
var music_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(music_player)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_state()

func handle_state():
	match current_state:
		MAIN_MENU:
			main_menu()
		EXPLORING:
			exploring()
		COMBAT:
			combat()
		DEATH: 
			death()
		END_COMBAT:
			end_combat()
			
func main_menu():
	pass
	
func exploring():
	pass
	
func combat():
	pass
	
func death():
	pass
	
func end_combat():
	pass

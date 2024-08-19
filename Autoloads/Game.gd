extends Node

## GAME
## This autoload contains all the method and variable used along the game

var win_treshold = 10
var end_timer = 300

var freedom_meter = 0
var stress_meter = 0
var enemy_killed_dico = {0:{"Type" : "BASE_CITY", "Nb": 0},1:{"Type" : "BASIC_UNIT","Nb" : 0}}
var allied_killed_dico = {0:{"Type" : "BASE_CITY", "Nb": 0},1:{"Type" : "BASIC_UNIT","Nb" : 0}}

var target

var last_shot_kills : int = 0

var current_scene = null
var current_path = ""

var time_left = 300

signal freedom_change()
signal stress_change()

### BUILT-IN

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	current_path = current_scene.scene_file_path
	
	EVENTS.lose_state.connect(_On_Lose_State)

### LOGIC

func check_freedom_meter():
	if freedom_meter >= win_treshold:
		EVENTS.win_state.emit()
	elif freedom_meter <= 0:
		EVENTS.lose_state.emit(1)
		
	freedom_change.emit()

func end_game_transition(_lose_reson : int):
	goto_scene("res://Scenes/menu/end_menu.tscn")


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.

	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()

	# Load new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()
	current_path = current_scene.scene_file_path

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optional, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func reload_scene():
	call_deferred("_deferred_goto_scene", current_path)

func _On_Lose_State(lose_reson : int):
	end_game_transition(lose_reson)

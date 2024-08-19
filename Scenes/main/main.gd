extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	
	EVENTS.end_game.connect(_on_EVENTS_end_game)

	## RESETING GAME VARIABLES
	GAME.end_condition = "Victory"

	GAME.freedom_meter = 0
	GAME.stress_meter = 0
	GAME.enemy_killed_dico = {0:{"Type" : "BASE_CITY", "Nb": 0},1:{"Type" : "BASIC_UNIT","Nb" : 0}}
	GAME.allied_killed_dico = {0:{"Type" : "BASE_CITY", "Nb": 0},1:{"Type" : "BASIC_UNIT","Nb" : 0}}

	GAME.last_shot_kills = 0

	GAME.time_left = 300


func end_game_transition():
	var anim_player = $UI/Control/AnimationPlayer
	anim_player.play("close_windows")
	await anim_player.animation_finished
	anim_player.play_backwards("deploy_ui")
	$UI/Control/Title.visible=false
	$UI/Control/PresstoStart.visible=false
	await anim_player.animation_finished
	GAME.goto_scene("res://Scenes/menu/end_menu.tscn")

func _on_EVENTS_end_game(end_type : int):
	GAME.end_condition = end_type
	end_game_transition()

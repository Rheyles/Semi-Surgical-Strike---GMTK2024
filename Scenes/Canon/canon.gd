extends Node2D

@onready var click_timer = $ClickTimer
@onready var error_text=$"Canon UI/Label"
@onready var caution_text=$"Canon UI/Label2"
@onready var sound_player=$AudioStreamPlayer
@onready var sound_player2=$AudioStreamPlayer2
@onready var sound_player3=$AudioStreamPlayer3

@export var map_disto: ColorRect
@export var laserLight : Light2D
@export var next_pattern_visual : Control

@export var canon_shoot_sound : Resource
@export var canon_impact_sound :  Array[Resource]
@export var canon_reload_sound : Resource

var canonNode_array = []

var pattern_array_lvl1 = [
	[true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[true, false, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
]

var pattern_array_lvl2 = [
	[true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, false, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, true, true, true, false, true, false, true, true, true, true, false, true, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, true, false, true, true, false, true, true, false, false, false, false, true, true, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, true, true, true, false, true, true, false, false, false, false, true, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[true, true, false, false, false, true, false, false, true, false, true, false, false, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
,[false, false, false, false, false, true, true, true, true, true, false, false, false, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
]

var pattern_array_lvl3 = [ 
	#[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	#[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	[true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[false,false,false,false,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[true,false,true,false,false,false,true,false,false,false,false,false,false,false,false,true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[false, false, false, false, false, false, false, false, true, true, true, true, false, false, true, true, false, true, true, false, true, true, true, true, true, true, false, true, true, false, false, true, true, false, false, true, true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, true, true, true, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	#,[false, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, true, true, false, false, true, true, false, true, false, false, true, false, false, false, false, false, true, true, true, true]
	,[false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, false, false, false, true, true, false, false, false, true, true, true, true, false, false, true, true, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[true, false, true, true, true, false, true, false, false, false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[true, false, false, true, true, false, false, false, true, true, true, true, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, true, true, true, true, true, true, true, true, true, true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	,[true, false, true, true, true, false, false, true, false, false, false, true, true, false, true, false, false, true, false, true, true, false, false, true, false, true, true, true, true, true, true, true, true, true, false, false, true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	]

var pattern_array_lvl4 = [
	#[true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, false, true, true, false, false, false, false, true, true, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
,[true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, true, true, true, false, false, true, true, true, false, false, true, true, false, false, true, true, false, false, true, true, true, true, true, true, false, true, false, false, false, true, true, false, false, false, false, true, true, true, true, true, true, true]
,[false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, true, true, true, false, false, true, true, false, false, true, true, false, false, true, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
,[false, false, false, false, false, false, false, true, true, false, false, true, true, true, true, true, false, true, true, false, true, false, false, true, false, true, false, false, true, false, false, false, false, true, true, false, false, true, false, false, true, false, false, true, false, false, true, false, false, false, true, false, false, true, false, false, false, false, false, false, false]
,[true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, false, false, false, true, true, true, false, false, false, true, true, true, false, false, false, false, false, false, false, false, false]
,[true, true, true, false, false, true, true, false, false, false, false, false, false, false, true, true, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, true, true, false, false, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, false, false]
,[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
,[false, false, false, false, true, true, false, true, true, true, false, false, false, false, false, false, true, false, true, false, false, false, false, false, true, true, true, true, true, false, false, false, true, true, true, false, true, true, true, true, false, false, false, true, true, true, false, false, false, false, false, false, true, true, true, true, true, false, false, false, true]
,[false, false, false, false, true, true, false, false, false, true, false, true, true, true, true, false, true, true, false, false, false, false, true, false, true, false, false, false, false, true, false, false, false, false, true, true, true, false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
,[true, false, false, true, true, false, false, true, false, false, false, false, true, false, false, false, false, false, false, true, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, true, true, false, false, false, false, true, false, false, false, false, true, true]
,[true, true, true, true, true, true, true, false, true, false, true, false, false, true, false, false, true, false, false, false, true, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, true, false, false, true, false, false, true, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
]

var canon_level : int = 1

var move_tween
@export var move_speed: float = 0.3
@export var base_reload_delay: float = 3
@export var reload_delay_bonus: float = 0.2
@export var impact_delay: float = 0.9
var reload_delay : float = 4
var follow_mouse = true

var ready_to_shoot: bool = false
var reload_timer: float = 0

var last_pattern_index: int = 0
var current_pattern_index: int = 0
var next_pattern_index: int = 0

var click_buffer : bool = false

### Intro
var intro_text : bool = true
var first_shoot: bool = true

func _ready():
	click_timer.timeout.connect(_on_ClickTimer_timeout)
	GAME.freedom_change.connect(_on_GAME_freedom_change)
	
	#pattern_array = [pattern2,pattern3,pattern4,pattern5, pattern6]
	
	for i in get_node("Node_Container").get_child_count():
		var node = get_node("Node_Container").get_child(i)
		canonNode_array.append(node)
	error_text._start()
	caution_text._start()

func _process(delta):
	if ready_to_shoot == false:
		reload_timer += 1*delta
		if reload_timer >= reload_delay:
			if(intro_text):
				intro_text = false
				error_text.text = "... ERROR"
			ready_to_shoot = true
			reload_timer = 0
			sound_play(canon_reload_sound)
			for hex in canonNode_array.size():
				canonNode_array[hex].get_node("Sprite2D").modulate = Color.WHITE
	
	if Input.is_action_just_pressed("Click"):
		click_buffer = true
		click_timer.start()
	
	if Input.is_action_just_pressed("Rotate_Up"):
		get_node("Node_Container").rotation_degrees += 60
	
	if Input.is_action_just_pressed("Rotate_Down"):
		get_node("Node_Container").rotation_degrees -= 60
	
	
	if click_buffer && ready_to_shoot == true:
		click_buffer = false
		if first_shoot:
			first_shoot_spawn(get_global_mouse_position())
			pass
		else:
			_CanonActivation()
	
	if follow_mouse:
		var mouse_po = get_global_mouse_position()
		move_tween = get_tree().create_tween()
		move_tween.tween_property(self,"position", mouse_po,move_speed)
	


### LOGIC 

func _CanonActivation():

#VFX & SFX au clic :
	EVENTS.emit_signal("set_shake")
	var energy = get_tree().create_tween()
	energy.tween_property(laserLight,"energy", 9.5,0.1)
	energy.tween_property(laserLight,"energy", 0,0.2)
	sound_play(canon_shoot_sound)

#Setup et Delay avant le tir
	move_tween.kill()
	ready_to_shoot = false
	follow_mouse = false
	await  get_tree().create_timer(impact_delay).timeout
#Call activate canonNode shoot function
	sound_play(canon_impact_sound.pick_random())
	for hex in canonNode_array.size():
		if canonNode_array[hex].visible == true:
			canonNode_array[hex].nodeShoot()
			canonNode_array[hex].get_node("Sprite2D").modulate = Color.FIREBRICK
	shader_disto_toggle(true)
	error_text._start(2,6,false)
	caution_text._start(2,6,false)

# End state
	follow_mouse = true;
	#print("Shoot : " + str(last_pattern_index))
	#print(str(GAME.enemy_killed_list.size()) + " target erased from the surface....")
	#print(str(GAME.allied_killed_list.size()) + " friends fallen for democracy !! <3 <3")
	reload_delay = base_reload_delay - (GAME.last_shot_kills * reload_delay_bonus)
	if reload_delay <= 1.5:
		reload_delay = 1.5
	print("reload delay after : " + str(GAME.last_shot_kills) + "kills is " + str(reload_delay))
	GAME.last_shot_kills = 0
	_load_Next_Pattern()

func _load_Next_Pattern():
	current_pattern_index = next_pattern_index
	match canon_level:
		1:
			for hex in canonNode_array.size():
				canonNode_array[hex].visible = pattern_array_lvl1[current_pattern_index][hex]
			next_pattern_index += 1
			if next_pattern_index > pattern_array_lvl1.size()-1:
				next_pattern_index = 0
			for hex in canonNode_array.size():
				next_pattern_visual.canonNode_array[hex].visible = pattern_array_lvl1[next_pattern_index][hex]
		2:
			for hex in canonNode_array.size():
				canonNode_array[hex].visible = pattern_array_lvl2[current_pattern_index][hex]
			next_pattern_index += 1
			if next_pattern_index > pattern_array_lvl2.size()-1:
				next_pattern_index = 0
			for hex in canonNode_array.size():
				next_pattern_visual.canonNode_array[hex].visible = pattern_array_lvl2[next_pattern_index][hex]
		3:
			for hex in canonNode_array.size():
				canonNode_array[hex].visible = pattern_array_lvl3[current_pattern_index][hex]
				last_pattern_index = current_pattern_index
			next_pattern_index += 1
			if next_pattern_index > pattern_array_lvl3.size()-1:
				next_pattern_index = 1
			for hex in canonNode_array.size():
				next_pattern_visual.canonNode_array[hex].visible = pattern_array_lvl3[next_pattern_index][hex]
		4:
			for hex in canonNode_array.size():
				canonNode_array[hex].visible = pattern_array_lvl4[current_pattern_index][hex]
				last_pattern_index = current_pattern_index
			next_pattern_index += 1
			if next_pattern_index > pattern_array_lvl4.size()-1:
				next_pattern_index = 0
			for hex in canonNode_array.size():
				next_pattern_visual.canonNode_array[hex].visible = pattern_array_lvl4[next_pattern_index][hex]
				


func shader_disto_toggle(onOff):
	if !onOff:
		map_disto.get_material().set("shader_parameter/offset",0.1)
		map_disto.get_material().set("shader_parameter/scanlines_opacity",0)
		map_disto.get_material().set("shader_parameter/small_scanlines_opacity",0.1)
	elif onOff:
		map_disto.get_material().set("shader_parameter/offset",0.3)
		map_disto.get_material().set("shader_parameter/scanlines_opacity",0.8)
		map_disto.get_material().set("shader_parameter/small_scanlines_opacity",3)
		await  get_tree().create_timer(0.5).timeout
		shader_disto_toggle(false)
		pass

func first_shoot_spawn(new_pos : Vector2):
	_CanonActivation()
	await  get_tree().create_timer(impact_delay+0.1).timeout
	get_node("../Units/FactoryComponent2Ally").create_unit_at_position(new_pos)
	EVENTS.start_battlefield.emit()
	first_shoot = false

func sound_play(stream : AudioStream):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var audio_players = [sound_player, sound_player2, sound_player3]
	var i = 0
	while audio_players[i].is_playing() and i < audio_players.size() -1 :
		i+=1
	var free_player = audio_players[i%audio_players.size()]
	free_player.stream = stream
	free_player.pitch_scale = rng.randf_range(0.95,1.05)
	free_player.play()

#func upgrade_canon(level : int):
	#if level == 1:
		#for hex in canonNode_array.size():
			#canonNode_array[hex].visible = canon_upgrade[current_pattern_index][hex]

### SIGNAL RESPONSES

func _on_GAME_freedom_change() -> void:
	if GAME.freedom_meter == 2 && canon_level < 2:
		canon_level = 2
	elif GAME.freedom_meter == 4 && canon_level < 3:
		canon_level = 3
	elif GAME.freedom_meter == 6 && canon_level < 4:
		canon_level = 4

func _on_ClickTimer_timeout() -> void:
	click_buffer = false

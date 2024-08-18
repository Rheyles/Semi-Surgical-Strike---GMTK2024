extends Node2D

@onready var click_timer = $ClickTimer
@onready var error_text=$"Canon UI/Label"
@onready var caution_text=$"Canon UI/Label2"
@export var map_disto: ColorRect
@export var laserLight : Light2D
@export var next_pattern_visual : Control

var canonNode_array = []

var pattern_array = [ 
	#[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	[true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]
	,[false,false,false,false,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]
	,[true,false,true,false,false,false,true,false,false,false,false,false,false,false,false,true,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,true,false]
	,[false, false, false, false, false, false, false, false, true, true, true, true, false, false, true, true, false, true, true, false, true, true, true, true, true, true, false, true, true, false, false, true, true, false, false, true, true]
	,[true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false, true, true, true, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false]
	#,[false, true, true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, true, true, false, false, true, true, false, true, false, false, true, false, false, false, false, false, true, true, true, true]
	,[false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, false, false, false, true, true, false, false, false, true, true, true, true, false, false, true, true, false, false]
	,[false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true]
	,[true, false, true, true, true, false, true, false, false, false, false, false, false, false, false, true, false, true, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, true, true, true, true]
	,[true, false, false, true, true, false, false, false, true, true, true, true, false, false, false, false, false, false, false, false, false, false, true, true, false, false, false, true, true, true, true, true, true, true, true, true, true]
	,[true, false, true, true, true, false, false, true, false, false, false, true, true, false, true, false, false, true, false, true, true, false, false, true, false, true, true, true, true, true, true, true, true, true, false, false, true]
	]

var move_tween
@export var move_speed: float = 0.3
@export var base_reload_delay: float = 2.5
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

### Text & Visual
var intro_text : bool = true

func _ready():
	click_timer.timeout.connect(_on_ClickTimer_timeout)
	
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
			_load_Next_Pattern()

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
		_CanonActivation()
	
	if follow_mouse:
		var mouse_po = get_global_mouse_position()
		move_tween = get_tree().create_tween()
		move_tween.tween_property(self,"position", mouse_po,move_speed)
	


### LOGIC 

func _CanonActivation():

#VFX au clic :
	EVENTS.emit_signal("set_shake")
	var energy = get_tree().create_tween()
	energy.tween_property(laserLight,"energy", 9.5,0.1)
	energy.tween_property(laserLight,"energy", 0,0.2)	


#Setup et Delay avant le tir
	move_tween.kill()
	ready_to_shoot = false
	follow_mouse = false
	await  get_tree().create_timer(impact_delay).timeout
#Call activate canonNode shoot function
	

#Global VFX (ScreenShake, distortion sur l'écran ?) 
	for hex in canonNode_array.size():
		if canonNode_array[hex].visible == true:
			canonNode_array[hex].nodeShoot()
			canonNode_array[hex].get_node("Sprite2D").modulate = Color.FIREBRICK
	shader_disto_toggle(true)
	error_text._start(2,6,false)
	caution_text._start(2,6,false)

#SFX

# End state
	follow_mouse = true;
	print("Shoot : " + str(last_pattern_index))
	print(str(GAME.enemy_killed_list.size()) + " target erased from the surface....")
	print(str(GAME.allied_killed_list.size()) + " friends fallen for democracy !! <3 <3")
	reload_delay = base_reload_delay - (GAME.last_shot_kills * reload_delay_bonus)
	if reload_delay <= 1:
		reload_delay = 1
	print("reload delay after : " + str(GAME.last_shot_kills) + "kills is " + str(reload_delay))
	GAME.last_shot_kills = 0

func _load_Next_Pattern():
	current_pattern_index = next_pattern_index
	for hex in canonNode_array.size():
			canonNode_array[hex].visible = pattern_array[current_pattern_index][hex]
	last_pattern_index = current_pattern_index
	next_pattern_index += 1
	if next_pattern_index > pattern_array.size()-1:
		next_pattern_index = 1
		
	for hex in canonNode_array.size():
		next_pattern_visual.canonNode_array[hex].visible = pattern_array[next_pattern_index][hex]

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
	
### SIGNAL RESPONSES

func _on_ClickTimer_timeout() -> void:
	click_buffer = false

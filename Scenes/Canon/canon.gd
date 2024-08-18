extends Node2D

@onready var click_timer = $ClickTimer
@export var next_pattern_visual : Node2D

var canonNode_array = []

var pattern_array = [ 
	#[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
	#,[true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]
	[false,false,false,false,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]
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
var reload_delay : float
@export var follow_mouse = true

var ready_to_shoot: bool = true
var reload_timer: float = 0

var last_pattern_index: int = 0
var current_pattern_index: int = 1
var next_pattern_index: int = 2

var click_buffer : bool = false

func _ready():
	click_timer.timeout.connect(_on_ClickTimer_timeout)
	
	#pattern_array = [pattern2,pattern3,pattern4,pattern5, pattern6]
	
	for i in get_node("Node_Container").get_child_count():
		var node = get_node("Node_Container").get_child(i)
		canonNode_array.append(node)

func _process(delta):
	if ready_to_shoot == false:
		reload_timer += 1*delta
		if reload_timer >= reload_delay:
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
		_CanonActivation()
	
	if follow_mouse:
		var mouse_po = get_global_mouse_position()
		move_tween = get_tree().create_tween()
		move_tween.tween_property(self,"position", mouse_po,move_speed)
	


### LOGIC 

func _CanonActivation():

#Delay avant le tir
	move_tween.kill()
	ready_to_shoot = false
	follow_mouse = false
	await  get_tree().create_timer(0.4).timeout
#Call activate canonNode shoot function
	

#Global VFX (ScreenShake, distortion sur l'écran ?) 
	for hex in canonNode_array.size():
		if canonNode_array[hex].visible == true:
			canonNode_array[hex].nodeShoot()
			canonNode_array[hex].get_node("Sprite2D").modulate = Color.FIREBRICK

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
		next_pattern_index = 0
		
	for hex in canonNode_array.size():
			next_pattern_visual.canonNode_array[hex].visible = pattern_array[next_pattern_index][hex]


### SIGNAL RESPONSES

func _on_ClickTimer_timeout() -> void:
	click_buffer = false

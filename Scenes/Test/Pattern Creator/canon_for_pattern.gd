extends Node2D

@export var canonNode_array = []
var pattern0 = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]


@export var move_speed: float = 0.3
@export var reload_delay: float = 1.0

@export var follow_mouse = true
var ready_to_shoot: bool = true
var reload_timer: float = 0

var last_pattern_index: int = 1

func _ready():
	for i in get_node("Node_Container").get_child_count():
		var node = get_node("Node_Container").get_child(i)
		canonNode_array.append(node)

func _process(delta):
	if Input.is_action_just_pressed("RightClick"):	
		var actual_pattern = pattern0
		for hex in canonNode_array.size():
			actual_pattern[hex] = canonNode_array[hex].loaded
		print(actual_pattern)

func _shoot():
#Logic de detection de collision de chaque canon Node du pattern

#Delay avant le tir

#Check if each visible hex is overlaping an other entity
	
	for hex in canonNode_array.size():
		if canonNode_array[hex].visible == true:
			canonNode_array[hex].get_node("Sprite2D").modulate = Color.FIREBRICK
	ready_to_shoot = false
#Graphisme (Particules, ScreenShake, distortion sur l'écran ?) 

#Son

#Activate Next Pattern or at gun ready ? 
	print("Shoot : " + str(last_pattern_index))


### SIGNAL RESPONSES

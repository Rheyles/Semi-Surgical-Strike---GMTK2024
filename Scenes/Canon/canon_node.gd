extends Control

@export var shoot_particule : Resource

var loaded : bool = true
var selected : bool = false

	
func _process(_delta):
	if Input.is_action_just_pressed("Click") && selected && get_tree().get_current_scene().get_name() == "Create_pattern":
		if loaded:
			loaded = false
			get_node("Sprite2D").modulate = Color.RED
		elif !loaded:
			loaded = true
			get_node("Sprite2D").modulate = Color.WHITE

### LOGIC

func nodeShoot():
# Detection collision overlaping

# Local VFX
	var part = shoot_particule.instantiate()
	get_tree().get_current_scene().add_child(part)
	part.position = global_position

	pass

### SIGNAL RESPONSES

func _on_area_2d_mouse_entered():
	selected = true

func _on_area_2d_mouse_exited():
	selected = false


extends Control

@export var shoot_particule : Resource

@onready var shoot_area = $Area2D

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
	var targets = shoot_area.get_overlapping_bodies()
	for unit in targets:
		if "health_component" in unit:
			if unit.TEAM == DATA.TEAMS.ALLY:
				if unit not in GAME.allied_killed_list:
					GAME.allied_killed_list.append(unit)
			elif unit.TEAM == DATA.TEAMS.ENEMY:
				if unit not in GAME.enemy_killed_list:
					GAME.enemy_killed_list.append(unit)
					GAME.last_shot_kills += 1
			unit.health_component.damage(9999)
# Local VFX
	var part = shoot_particule.instantiate()
	get_tree().get_current_scene().add_child(part)
	part.position = global_position

### SIGNAL RESPONSES

func _on_area_2d_mouse_entered():
	selected = true

func _on_area_2d_mouse_exited():
	selected = false

func _on_area_2d_body_entered(body):
	if "TEAM" in body:
			get_node("Sprite2D").modulate = Color.FIREBRICK
			get_node("Sprite2D/Sprite2D").modulate = Color.FIREBRICK


func _on_area_2d_body_exited(body):
	get_node("Sprite2D").modulate = Color.WHITE
	get_node("Sprite2D/Sprite2D").modulate = Color.WHITE

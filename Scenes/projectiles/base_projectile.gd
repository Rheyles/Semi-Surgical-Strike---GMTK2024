extends Node2D

@export var SPEED := 80.0
@export var DAMAGE := 2.0
@export var COLOR := Color.RED

var target_object = null
var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = COLOR
	target_position = target_object.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_instance_valid(target_object):
		target_position = target_object.global_position
		rotation = (target_position - global_position).angle()
	
	if global_position.distance_to(target_position) <= SPEED * delta:
		global_position = target_position
		target_reached()
	else:
		global_position += (target_position - global_position).normalized() * SPEED * delta

func target_reached():
	if is_instance_valid(target_object): 
		if "health_component" in target_object:
			if is_instance_valid(target_object.health_component):
				target_object.health_component.damage(DAMAGE,false)
	destroy()

func destroy():
	queue_free()

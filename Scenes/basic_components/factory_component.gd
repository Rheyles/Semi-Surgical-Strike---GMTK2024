extends Node2D

@export var target_scene : Resource
@export var COOLDOWN := 5.0
@export_category("StandAlone")
@export var standalone = false
@export var battlefield : Node
@export var TEAM : DATA.TEAMS

@onready var cooldown_timer = $CooldownTimer
@onready var shape_caster = $ShapeCast2D

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	if "TEAM" in get_parent():
		TEAM = get_parent().TEAM
	cooldown_timer.timeout.connect(_on_CooldownTimer_timeout)
	cooldown_timer.start(COOLDOWN)

### LOGIC

func create_unit():
	var new_unit = target_scene.instantiate()
	new_unit.TEAM = TEAM
	EVENTS.emit_signal("add_node_to_battlefield", new_unit)
	
	if standalone :
		assert(battlefield, "Battlefield Object not referenced")
		var new_pos = Vector2.ZERO
		while new_pos==Vector2.ZERO:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var new_angle = rng.randf_range(0, 2 * PI)
			var new_dist = clampf(rng.randfn(battlefield.radius/3, battlefield.radius/8),10.0,battlefield.radius)
			#print("new dist : ", new_dist)
			#print("battlefield radius : ", battlefield.radius)
			shape_caster.global_position = (Vector2.ONE * new_dist).rotated(new_angle) + battlefield.global_position
			shape_caster.enabled = true
			shape_caster.force_shapecast_update()
			if shape_caster.get_collision_count() == 0:
				new_pos = (Vector2.ONE * new_dist).rotated(new_angle) + battlefield.global_position
			shape_caster.enabled = false
		new_unit.global_position = new_pos
	else:
		new_unit.global_position = global_position

### SIGNAL RESPONSES

func _on_CooldownTimer_timeout():
	create_unit()
	cooldown_timer.start(COOLDOWN)

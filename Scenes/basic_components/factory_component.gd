extends Node2D

@export var target_scene : Resource
@export var COOLDOWN :float = 5.0
@export var nb_per_wave : int = 1
@export var create_at_ready : bool = false
@export_category("StandAlone")
@export var standalone = false
@export var battlefield : Node
@export var TEAM : DATA.TEAMS

@onready var cooldown_timer = $CooldownTimer
@onready var shape_caster = $ShapeCast2D
@onready var spawn_zone = $SpawnZone

var active = true

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	if "TEAM" in get_parent():
		TEAM = get_parent().TEAM
	cooldown_timer.timeout.connect(_on_CooldownTimer_timeout)
	cooldown_timer.start(COOLDOWN)

func _physics_process(_delta):
	if create_at_ready:
		create_at_ready = false
		_on_CooldownTimer_timeout()

### LOGIC

func create_unit():
	var new_unit = target_scene.instantiate()
	new_unit.TEAM = TEAM
	EVENTS.emit_signal("add_node_to_battlefield", new_unit)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var new_angle = rng.randf_range(0, 2 * PI)
	if standalone :
		assert(battlefield, "Battlefield Object not referenced")
		var new_pos = Vector2.ZERO
		while new_pos==Vector2.ZERO:
			var new_dist = clampf(rng.randfn(battlefield.radius/3, battlefield.radius/8),10.0,battlefield.radius- 100)
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
		new_unit.global_position = global_position + (Vector2.ONE * spawn_zone.shape.radius).rotated(new_angle)
		

func create_unit_at_position(pos : Vector2):
	var new_unit = target_scene.instantiate()
	new_unit.TEAM = TEAM
	EVENTS.emit_signal("add_node_to_battlefield", new_unit)
	
	if standalone :
		assert(battlefield, "Battlefield Object not referenced")
		var new_pos = pos
		new_unit.global_position = new_pos

### SIGNAL RESPONSES

func _on_CooldownTimer_timeout():
	if active:
		var counter = nb_per_wave
		while counter > 0:
			create_unit()
			counter -= 1
		cooldown_timer.start(COOLDOWN)

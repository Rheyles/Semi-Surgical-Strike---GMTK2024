extends CharacterBody2D
class_name BaseUnit

@export var TARGET_SPEED = 50.0
@export var WANDERING_SPEED = 25.0
@export var TEAM : DATA.TEAMS
@export var UNIT_TYPE : DATA.UNIT_TYPE

@onready var health_component = $HealthComponent
@onready var attack_component = $AttackComponent

@onready var nav = $NavigationAgent2D
@onready var vision_zone = $VisionZone
@onready var wandering_timer = $WanderingTimer
@onready var wandering_zone = $WanderingZone

var attack_radius : float = 0.0
var vision_radius : float = 0.0

var visible_bodies = []

var distance_to_target = INF
var current_target = null
var wandering_target = null
var moving = false
var current_speed = 0.0
var first_frame = true
var active = true

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = DATA.team_color[TEAM]
	
	$Art/AnimationPlayer.play("idle")
	$Art.visible = true
	$Cross.visible = false
	
	attack_radius = attack_component.radius
	vision_radius = $VisionZone/CollisionShape2D.shape.radius
	
	nav.velocity_computed.connect(_on_NavigationAgent_velocity_computed)
	vision_zone.body_entered.connect(_on_VisionZone_body_entered)
	vision_zone.body_exited.connect(_on_VisionZone_body_exited)
	wandering_timer.timeout.connect(_on_WanderingTimer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if first_frame:
		first_frame = false
	elif active:
		find_closest_target()
		
		#print("\nNew turn:")
		#print("visible bodies : ", visible_bodies)
		#print("current_target : ",current_target)
		#print("wandering_target : ",wandering_target)
		
		moving = false
		if current_target :
			if distance_to_target < attack_radius:
				# ATTACK
				nav.set_velocity(Vector2.ZERO)
			else:
				moving = true
				nav.target_position = current_target.global_position
				current_speed = TARGET_SPEED
		else:
			moving = true
			if not wandering_target:
				find_wandering_target()
			nav.target_position = wandering_target
			current_speed = WANDERING_SPEED
		
		if moving :
			var direction = global_position.direction_to(nav.get_next_path_position())
			var intended_velocity = direction * current_speed
			nav.set_velocity(intended_velocity)
			#velocity = intended_velocity
			#move_and_slide()

func destroy():
	active = false
	attack_component.active = false
	$CollisionShape2D.disabled = true
	$NavigationAgent2D.avoidance_enabled = false
### Freedom point on kill optional
	#if TEAM == DATA.TEAMS.ENEMY:
		#GAME.freedom_meter += 1
		#GAME.check_freedom_meter()

	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

### LOGIC

func find_closest_target() -> void:
	distance_to_target = INF
	current_target = null
	for body in visible_bodies:
		var current_distance = body.global_position.distance_to(global_position)
		if current_distance < distance_to_target:
			distance_to_target = current_distance
			current_target = body

func find_wandering_target() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var angle = rng.randf_range(0, 2 * PI)
	var wander_direction = (Vector2.ONE * wandering_zone.shape.radius).rotated(angle)
	wandering_target = global_position + wander_direction
	wandering_timer.start(rng.randf_range(wandering_timer.wait_time*0.9,wandering_timer.wait_time*1.2))

### SIGNAL RESPONSES

func _on_NavigationAgent_velocity_computed(safe_velocity:Vector2):
	velocity = safe_velocity
	move_and_slide()

func _on_VisionZone_body_entered(body:Node2D) -> void:
	if body not in visible_bodies and body != self and "TEAM" in body:
		if body.TEAM != TEAM:
			visible_bodies.append(body)

func _on_VisionZone_body_exited(body:Node2D) -> void:
	if body in visible_bodies:
		visible_bodies.erase(body)

func _on_WanderingTimer_timeout() -> void:
	wandering_target = null

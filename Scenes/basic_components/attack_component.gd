extends Area2D
class_name AttackComponent

@export var DAMAGE := 2.0
@export var COOLDOWN := 2.0
@export var PROJECTILE_SCENE : Resource

@onready var cooldown_timer = $CooldownTimer

var visible_bodies = []
var radius : float = 0.0
var in_cooldown = false

var active = true

### BUILT-IN

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = $CollisionShape2D.shape.radius
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	cooldown_timer.timeout.connect(_on_CooldownTimer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if active :
		if visible_bodies.size() > 0 and not in_cooldown:
			for body in visible_bodies :
				if "health_component" in body:
					if body.health_component.health > 0.0:
						attack(body)
						break


### LOGIC

func attack(target:Node)->void:
	#print(get_parent(), " attacks ",target)
	cooldown_timer.start(COOLDOWN)
	in_cooldown = true
	var new_projectile = PROJECTILE_SCENE.instantiate()
	new_projectile.DAMAGE = DAMAGE
	new_projectile.COLOR = DATA.team_color[get_parent().TEAM]
	new_projectile.target_object = target
	EVENTS.emit_signal("add_node_to_battlefield", new_projectile)
	new_projectile.global_position = global_position


### SIGNAL RESPONSES

func _on_body_entered(body:Node2D) -> void:
	if body not in visible_bodies and body != get_parent() and "TEAM" in body:
		if body.TEAM != get_parent().TEAM:
			visible_bodies.append(body)

func _on_body_exited(body:Node2D) -> void:
	if body in visible_bodies:
		visible_bodies.erase(body)

func _on_CooldownTimer_timeout() -> void:
	in_cooldown = false

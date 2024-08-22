extends Node2D
class_name HealthComponent

@onready var health_bar = $ProgressBar
@onready var invincibility_timer = $InvincibilityFrame

@export var MAX_HEALTH := 10.0
var health : float : set = _set_health
var invincible = false

func _set_health(new_value:float):
	health = new_value
	health_bar.value = health
	if health<=0:
		health_bar.visible = false

func _ready():
	invincibility_timer.timeout.connect(_on_InvincibilityFrame_timeout)
	health_bar.max_value = MAX_HEALTH
	_set_health(MAX_HEALTH)

func damage(amount:float, damage_from_canon:bool = false):
	if not damage_from_canon or (damage_from_canon and not invincible):
		_set_health(health - amount)
		if damage_from_canon:
			invincible = true
			invincibility_timer.start()
		if health<=0:
			if damage_from_canon:
				GAME.last_shot_kills += 1
				if get_parent().TEAM == DATA.TEAMS.ALLY:
					GAME.allied_killed_dico[get_parent().UNIT_TYPE]["Nb"] += 1
				elif get_parent().TEAM == DATA.TEAMS.ENEMY:
					GAME.enemy_killed_dico[get_parent().UNIT_TYPE]["Nb"] += 1
			get_parent().destroy()

func _on_InvincibilityFrame_timeout():
	invincible = false

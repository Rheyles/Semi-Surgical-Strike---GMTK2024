extends Node2D

@export var UNIT_TEXTURES : Array[Resource]
@export var dead_unit_scene : Resource

@onready var pop_timer = $PopTimer

var unit_count = {"ENEMY" : 0, "ALLY" : 0 }

var SUBTITLES = {
	DATA.END_TYPE.VICTORY : "Boom! Mission wrapped up nice and tidy!",
	DATA.END_TYPE.DEFEAT_TIMER : "Playtime's over, gotta go pick up the kiddos!",
	DATA.END_TYPE.DEFEAT_BASE : "Houston, we have a problem... Our bases have vanished!"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	match GAME.end_condition:
		DATA.END_TYPE.VICTORY :
			$UI/Base/Title.text = 'Victory !'
		_:
			$UI/Base/Title.text = 'Defeat...'
	$UI/Base/SubTitle.text = SUBTITLES[GAME.end_condition]
	timer_left()
	$UI/Base/Memo.visible = false
	$AnimationPlayer.play("start")
	await $AnimationPlayer.animation_finished
	call_deferred('show_frags')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not $AnimationPlayer.is_playing() and Input.is_action_just_pressed("Click"):
		$AnimationPlayer.play("end")
		await $AnimationPlayer.animation_finished
		GAME.goto_scene("res://Scenes/main/main.tscn")


func show_frags():
	var containers = {DATA.TEAMS.keys()[DATA.TEAMS.ENEMY] : $UI/Base/Enemies,
					  DATA.TEAMS.keys()[DATA.TEAMS.ALLY] : $UI/Base/Allies}
	var count_text = {DATA.TEAMS.keys()[DATA.TEAMS.ENEMY]: $UI/Base/Memo/Content/EnemyUnits/E_count,
					  DATA.TEAMS.keys()[DATA.TEAMS.ALLY] : $UI/Base/Memo/Content/AllyUnits/A_count}
	
	for team in ["ENEMY", "ALLY"]:
		var unit_dict = GAME.enemy_killed_dico
		if team == "ALLY":
			unit_dict = GAME.allied_killed_dico
		
		for unit_type in unit_dict.keys():
			for j in range (unit_dict[unit_type]['Nb']):
				var new_dead_unit = dead_unit_scene.instantiate()
				new_dead_unit.unit_texture = UNIT_TEXTURES[unit_type]
				new_dead_unit.modulate = DATA.team_color[DATA.TEAMS[team]]
				containers[team].add_child(new_dead_unit)
				unit_count[team] += 1
				count_text[team].text = str(unit_count[team])
				
				pop_timer.start(0.04)
				await pop_timer.timeout

func timer_left():
	var seconds_left = int(GAME.time_left)%60
	var seconds_text = str(seconds_left)
	if seconds_left < 10:
		seconds_text = '0' + str(seconds_left)
	@warning_ignore("integer_division")
	$UI/Base/Memo/Timer/Content/Label.text = '0'+str(round(int(GAME.time_left)/60)) + ':' + seconds_text

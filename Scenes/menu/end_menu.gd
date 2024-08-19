extends Node2D

@export var UNIT_TEXTURES : Array[Resource]
@export var dead_unit_scene : Resource

@onready var pop_timer = $PopTimer

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
	
	for team in ["ENEMY", "ALLY"]:
		var unit_dict = GAME.enemy_killed_dico
		if team == "ALLY":
			unit_dict = GAME.allied_killed_dico
		
		for unit_type in unit_dict.keys():
			for j in range (unit_dict[unit_type]['Nb']):
				var new_dead_unit = dead_unit_scene.instantiate()
				new_dead_unit.unit_texture = UNIT_TEXTURES[unit_type]
				containers[team].add_child(new_dead_unit)

				pop_timer.start(0.2)
				await pop_timer.timeout

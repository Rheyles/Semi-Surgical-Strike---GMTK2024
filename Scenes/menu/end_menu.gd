extends Node2D

var TITLES = {
	'Victory' : "Boom! Mission wrapped up nice and tidy!",
	'DefeatTimer' : "Playtime's over, gotta go pick up the kiddos!",
	'DefeatBase' : "Houston, we have a problem... Our bases have vanished!"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/Base/Memo.visible = false
	$AnimationPlayer.play("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not $AnimationPlayer.is_playing() and Input.is_action_just_pressed("Click"):
		$AnimationPlayer.play("end")
		await $AnimationPlayer.animation_finished
		GAME.goto_scene("res://Scenes/main/main.tscn")

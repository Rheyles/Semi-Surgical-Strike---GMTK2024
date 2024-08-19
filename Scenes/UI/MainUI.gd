extends Control

var state = "MainMenu"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("start_game")
	
func _process(_delta):
	if Input.is_action_just_pressed("Click") and state=="MainMenu" and not $AnimationPlayer.is_playing():
		state="InGame"
		get_tree().paused = false
		$AnimationPlayer.play("deploy_ui")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("open_windows")

extends Control

@export var main_theme : Resource
@export var intro_theme : Resource
@export var windows_sound : Resource

var state = "MainMenu"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("start_game")
	$MusicPlayer.play()
	
func _process(_delta):
	if Input.is_action_just_pressed("Click") and state=="MainMenu" and not $AnimationPlayer.is_playing():
		state="InGame"
		GAME.init_frag_dicts()
		$StartSound.play()
		get_tree().paused = false
		$StartSound.stream = windows_sound
		$AnimationPlayer.play("deploy_ui")
		await $AnimationPlayer.animation_finished
		$MusicPlayer.stream = main_theme
		$MusicPlayer.play()
		$AnimationPlayer.play("open_windows")

extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Music Player/AudioBars/AnimationPlayer".play("idle")
	$WinJauge/AnimationPlayer.play("idle")
	$NextStrike/AnimationPlayer.play("appear")

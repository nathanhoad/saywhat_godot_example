extends Node2D


const Line = preload("res://addons/saywhat_godot/dialogue_line.gd")


func _ready():
	$AnimationPlayer.play("Idle")


func talk(line: Line, is_talking: bool = true) -> void:
	if line.character == "Nathan" and is_talking:
		$AnimationPlayer.play("Talk")
	else:
		$AnimationPlayer.play("Idle")




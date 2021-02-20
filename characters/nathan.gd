extends Node2D


func _ready():
	$AnimationPlayer.play("Idle")


func talk(line: DialogueLine, is_talking: bool = true) -> void:
	if line.character == "Nathan" and is_talking:
		$AnimationPlayer.play("Talk")
	else:
		$AnimationPlayer.play("Idle")




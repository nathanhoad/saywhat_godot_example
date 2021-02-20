extends Node2D


var Dialogue = preload("res://dialogue.tscn")


func _ready() -> void:
	DialogueManager.resource = preload("res://dialogue.tres")
	DialogueManager.game_state = GameState
	
	# Show some dialogue right away
	show_dialogue("33e17efd-5582-48be-85de-af456fbf1777")
	

func show_dialogue(id: String) -> void:
	# Given an ID, let the dialogue manager find the next line that we should show
	var line = yield(DialogueManager.get_next_dialogue_line(id), "completed")
	if line != null:
		# If we have a line then show it
		var dialogue = Dialogue.instance()
		# Nathan will move his mouth until we finish typing out the text
		dialogue.connect("typing_started", $Nathan, "talk", [true])
		dialogue.connect("typing_finished", $Nathan, "talk", [false])
		# Show the dialogue
		add_child(dialogue)
		dialogue.handle(line)
		show_dialogue(yield(dialogue, "dialogue_actioned"))


func coco_sit(args: Array) -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	$Coco/AnimationPlayer.play("Sit")
	yield($Coco/AnimationPlayer, "animation_finished")
	yield(get_tree().create_timer(0.5), "timeout")
	
	
func coco_stand(args: Array) -> void:
	yield(get_tree().create_timer(0.5), "timeout")
	$Coco/AnimationPlayer.play("Stand")

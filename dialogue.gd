extends Control

signal typing_started(line)
signal dialogue_actioned(next_id)
signal typing_finished(line)


const Line = preload("res://addons/saywhat_godot/dialogue_line.gd")


func _ready():
	# Hide everything until we are ready
	modulate.a = 0


func handle(line: Line) -> void:
	var dialogue : RichTextLabel = $Dialogue
	var responses : VBoxContainer = $Responses
	var button : Label = $Button
	var tween : Tween = $Tween
	
	dialogue.text = line.dialogue
	
	yield(get_tree(), "idle_frame")
	
	# Now that the text has been calculated we can show it
	modulate.a = 1
	
	emit_signal("typing_started", line)
	
	# Type out the text
	tween.interpolate_property(dialogue, "percent_visible", 0, 1, dialogue.get_total_character_count() * 0.01)
	tween.start()
	yield(tween, "tween_all_completed")
	
	emit_signal("typing_finished", line)
	
	# If we have responses the make some "buttons"
	if line.responses.size() > 1:
		for response in line.responses:
			var new_button = button.duplicate()
			new_button.text = response.prompt
			new_button.connect("gui_input", self, "_button_gui_input", [response.next_id])
			responses.add_child(new_button)
		button.queue_free()
	
	# Otherwise just wait for an amount of time
	else:
		yield(get_tree().create_timer(dialogue.get_total_character_count() * 0.05), "timeout")
		next(line.next_id)


func _button_gui_input(event: InputEventMouseButton, next_id: String) -> void:
	if event != null:
		next(next_id)

	
func next(next_id: String) -> void:
	emit_signal("dialogue_actioned", next_id)
	queue_free()

extends Button

signal click_end()

func _on_mouse_entered() -> void:
	pass # Replace with function body.

func _on_pressed() -> void:
	emit_signal("click_end")

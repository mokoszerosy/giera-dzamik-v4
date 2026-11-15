extends Control

@export var main_menu_buttons: VBoxContainer
@export var level_selection_buttons: VBoxContainer

func _ready() -> void:
	_update_level_buttons()

func _update_level_buttons() -> void:
	for button in level_selection_buttons.get_children():
		if not button is SoundButton:
			continue
		var unlocked := Globals.is_level_unlocked(button.transfer)
		button.disabled = not unlocked
		button.modulate = Color.WHITE if unlocked else Color(0.5, 0.5, 0.5, 0.5)

func _on_play_button_pressed() -> void:
	main_menu_buttons.visible = false
	level_selection_buttons.visible = true

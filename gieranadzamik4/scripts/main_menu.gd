extends Control

@export var main_menu_buttons: VBoxContainer
@export var level_selection_buttons: VBoxContainer

func _on_play_button_pressed() -> void:
	main_menu_buttons.visible = false
	level_selection_buttons.visible = true

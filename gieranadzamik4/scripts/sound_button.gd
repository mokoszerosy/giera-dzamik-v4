class_name SoundButton extends Button

@export var transfer: String

func _ready() -> void:
	self.pressed.connect(_play_sound)
	
func _play_sound():
	Sound.play_ui_click()
	_button_action()

func _button_action():
	if transfer == "":
		return
	if transfer == "quit":
		get_tree().quit()
		return
	get_tree().change_scene_to_file(transfer)

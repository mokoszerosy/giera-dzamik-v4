extends Node

func change_sound_effects_vol(value: float):
	$UIClickSound.volume_linear = 2 * value

func change_music_vol(value: float):
	AudioServer.set_bus_volume_linear(1, 2 * value)

func play_ui_click():
	$UIClickSound.pitch_scale = 1.0
	$UIClickSound.play()

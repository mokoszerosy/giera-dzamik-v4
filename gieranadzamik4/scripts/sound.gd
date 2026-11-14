extends Node

func change_sound_effects_vol(value: float):
	$UIClickSound.volume_linear = 2 * value

func change_music_vol(value: float):
	AudioServer.set_bus_volume_linear(1, 2 * value)

func play_ui_click():
	$UIClickSound.pitch_scale = 1.0
	$UIClickSound.play()

func play_bounce(pitch: float):
	$BounceSound.pitch_scale = pitch
	$BounceSound.play(8.76)

func play_falling_rocks():
	$FallingRoksAmbient.stop()
	$FallingRocksSound.play()

func play_falling_rocks_ambient():
	$FallingRoksAmbient.play()

func play_jump():
	$JumpSound.pitch_scale = randf_range(0.75, 1.5)
	$JumpSound.play()
	
func play_land():
	$StepSound.pitch_scale = 3.0
	$StepSound.play(18.5)

func play_slime():
	$SlimeSound.play()

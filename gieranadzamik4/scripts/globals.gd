extends Node

const TILE_SCALE: int = 6
const TILE_PIXEL_SIZE: float = 16.0
const TILE_SIZE: int = int(TILE_PIXEL_SIZE) * TILE_SCALE
const LEVEL_STEP: float = 3 * TILE_SIZE

const LEVELS: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_3.tscn",
	"res://scenes/levels/level_2.tscn",
]
const SAVE_PATH: String = "user://progress.cfg"

var unlocked_levels: Dictionary[String, bool] = {}

func _ready() -> void:
	_load_progress()

func is_level_unlocked(scene_path: String) -> bool:
	return unlocked_levels.has(scene_path) and unlocked_levels[scene_path]

func finish_level(scene_path: String) -> void:
	var index := LEVELS.find(scene_path)
	if index == -1:
		return
	unlocked_levels[scene_path] = true
	if index + 1 < LEVELS.size():
		unlocked_levels[LEVELS[index + 1]] = true
	_save_progress()

func _load_progress() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		var saved: Array = config.get_value("progress", "unlocked", [])
		for scene_path in saved:
			if scene_path is String:
				unlocked_levels[scene_path] = true
	# The first level is always available.
	unlocked_levels[LEVELS[0]] = true

func _save_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("progress", "unlocked", unlocked_levels.keys())
	config.save(SAVE_PATH)

extends Node2D

@export var level_to_load: PackedScene

@onready var world = $WorldVal
@onready var lives = $LivesVal

func _ready() -> void:
  Game.resume_game()
  lives.text = str(Game.lives)
  world.text = "1-1"

func _on_timer_timeout() -> void:
  get_tree().change_scene_to_packed(level_to_load)

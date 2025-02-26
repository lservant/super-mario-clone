extends Node2D

@export var level_to_load: PackedScene

func _ready() -> void:
  Game.resume_game()

func _physics_process(delta: float) -> void:
  if Input.is_anything_pressed():
    Game.restart_game()
extends Area2D
class_name Checkpoint

@export var respawn: Node2D

func _on_body_entered(body: Node) -> void:
  if body.name == "player":
    Game.set_spawn(respawn)
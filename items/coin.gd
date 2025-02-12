extends Area2D

var collected = false

func _on_body_entered(body:Node2D) -> void:
  if body.name != "player" or collected:
    return

  collected = true
  Game.add_coin()
  queue_free()

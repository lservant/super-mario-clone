extends Area2D


func _on_body_entered(body:Node2D) -> void:
  if body.name != "player":
    return
  
  Game.add_coin()
  queue_free()

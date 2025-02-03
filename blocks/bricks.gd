extends StaticBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _on_underside_body_entered(body: Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  if player.is_big:
    destroy()
  else:
    bounce()
    player.change_state("fall")
  
func bounce():
  anim.play("bounce")

func destroy():
  pass

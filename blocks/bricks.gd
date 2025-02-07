extends StaticBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $CollisionShape2D

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
  collider.disabled = true
  anim.play("destroy")
  Game.add_score(50)


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
  if anim_name == "destroy":
    queue_free()

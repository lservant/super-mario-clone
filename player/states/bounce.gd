extends PlayerStateBase

func _ready() -> void:
  state = "bounce"
  
func _physics_process(delta: float) -> void:
  if player.current_state != state:
    return
    
  handle_horizontal(delta)
  
  player.velocity.y = -player.jump_height * 750 * delta
  
  player.change_state("jump")

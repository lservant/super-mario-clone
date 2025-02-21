extends PlayerState

func _ready() -> void:
  state = "idle"
  
func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
  
  if Input.is_action_pressed("move_right"):
    player.change_state("walk")
  if Input.is_action_pressed("move_left"):
    player.change_state("walk")
  if player.velocity.y > 0:
    player.change_state("fall")
  handle_crouch()
  handle_jump(delta)
  player.velocity.x = lerp(player.velocity.x, 0.0, player.friction)

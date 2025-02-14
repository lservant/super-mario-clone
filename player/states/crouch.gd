extends PlayerStateBase

func _ready() -> void:
  state = "crouch"

func _physics_process(delta: float) -> void:
  if player.current_state != state:
    return
  
  if player.is_on_pipe:
    await player.try_teleport(Pipe.ENTER_DIR.TOP)
    return
  
  handle_jump(delta)
  player.velocity.x = lerp(player.velocity.x, 0.0, player.weight)

  if not Input.is_action_pressed("crouch"):
    player.change_state("idle")

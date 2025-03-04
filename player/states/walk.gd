extends PlayerState

func _ready() -> void:
  state = "walk"

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
  
  handle_crouch()

  if player.is_on_pipe and player.velocity.x == 0:
    if Input.is_action_pressed("move_right"):
      if await player.try_teleport(Pipe.ENTER_DIR.LEFT):
        return
    elif Input.is_action_pressed("move_left"):
      if await player.try_teleport(Pipe.ENTER_DIR.RIGHT):
        return

  if player.is_running:
    player.anim_movement.play("run")
  else:
    player.anim_movement.play("walk")

  if player.velocity.y > 0:
    player.change_state("fall")
    
  if handle_horizontal(delta) == 0:
    player.change_state("idle")
  handle_jump(delta)

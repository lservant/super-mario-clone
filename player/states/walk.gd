extends PlayerStateBase

func _ready() -> void:
  state = "walk"

func _physics_process(delta: float) -> void:
  if player.current_state != state:
    return
  
  if player.is_running:
    player.anim.play("run")
  else:
    player.anim.play("walk")

  if handle_horizontal(delta) == 0:
    player.change_state("idle")
  handle_jump(delta)

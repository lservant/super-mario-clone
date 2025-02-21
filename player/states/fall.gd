extends PlayerState

func _ready() -> void:
  state = "fall"

func reset():
  player.anim_movement.play("jump")
  
func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
    
  handle_horizontal(delta)
  
  if player.is_on_floor():
    player.change_state("idle")

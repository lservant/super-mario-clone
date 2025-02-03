extends PlayerStateBase

func _ready() -> void:
  state = "fall"

func reset():
  pass
  
func _physics_process(delta: float) -> void:
  if player.current_state != state:
    return
    
  handle_horizontal(delta)
  
  if player.is_on_floor():
    player.change_state("idle")

extends HamsterState

func _ready() -> void:
  state = "idle"

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return

  if hamster.is_hitting_player and hamster.can_hit_player:
    hamster.hit()
  

  
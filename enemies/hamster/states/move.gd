extends HamsterState

func _ready() -> void:
  state = "move"

func reset() -> void:
  super()
  hamster.anim.play("move")

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
  
  if hamster.is_hitting_player and hamster.can_hit_player:
    hamster.hit()

  hamster.velocity.x = hamster.move_speed * 500 * delta * hamster.dir_scalar
  

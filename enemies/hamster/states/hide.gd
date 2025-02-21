extends HamsterState

func _ready() -> void:
  state = "hide"

func reset() -> void:
  super()
  hamster.player.change_state("bounce")
  hamster.anim.play("hide")

func _physics_process(delta: float) -> void:
  if sm.current_state != state:
    return
  
  hamster.velocity.x = lerp(hamster.velocity.x, 0.0, 0.1)
  

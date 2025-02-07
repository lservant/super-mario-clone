extends Item

@export var direction = DIRECTION.RIGHT
@export var speed = 5

@onready var collider = $CollisionShape2D
@onready var wallray_collider = $ray_wallcheck
@onready var sprite = $Sprite2D

var is_moving = false

func _ready() -> void:
  if direction == DIRECTION.LEFT:
    change_direction()

func _physics_process(delta: float) -> void:
  if collider.disabled or not is_moving:
    return

  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  if wallray_collider.is_colliding():
    print(str(name, "is colliding"))
    change_direction()
    
  velocity.x = speed * 500 * delta
  move_and_slide()

func start_moving():
  is_moving = true

func change_direction():
  if direction == DIRECTION.LEFT:
    direction = DIRECTION.RIGHT
  else:
    direction = DIRECTION.LEFT
    
  wallray_collider.target_position.x = -wallray_collider.target_position.x
  speed *= -1
  sprite.flip_h = !sprite.flip_h

func die():
  Game.add_score(100)
  queue_free()

var is_stomped = false

func _on_collider_hit_body_entered(body:Node2D) -> void:
  if is_stomped:
    return
  if body.name != "player":
    return
  print("hit")
  var player: Player = body
  player.hit()


func _on_collider_stomp_body_entered(body:Node2D) -> void:
  if body.name != "player":
    return
  var player: Player = body
  if player.current_state == "fall" or player.current_state == "jump":
    print("stomp")
    is_stomped = true
    player.change_state("bounce")
    die()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
  start_moving()
  
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
  queue_free()

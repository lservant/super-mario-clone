extends Item

@export var direction = DIRECTION.RIGHT
@export var speed = 5

@onready var collider = $CollisionShape2D
@onready var wallray_collider = $ray_wallcheck
@onready var sprite = $Sprite2D

func _ready() -> void:
  if direction == DIRECTION.LEFT:
    speed = -speed
    sprite.flip_h = true

func _physics_process(delta: float) -> void:
  if collider.disabled:
    return
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta
  
  if wallray_collider.is_colliding():
    direction = (direction + 1) % 2
    wallray_collider.target_position.x = -wallray_collider.target_position.x
    speed *= -1
    sprite.flip_h = !sprite.flip_h
    
  velocity.x = speed * 500 * delta
  move_and_slide()

func die():
  queue_free()

func _on_collider_hit_body_entered(body:Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  player.hit()


func _on_collider_stomp_body_entered(body:Node2D) -> void:
  if body.name != "player":
    return
  
  var player: Player = body
  die()

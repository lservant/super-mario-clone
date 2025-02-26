extends CanvasLayer
class_name UI

@onready var time_label: Label = $TimeVal
@onready var world_label: Label = $WorldVal
@onready var score_label: Label = $ScoreVal
@onready var coins_label: Label = $CoinGroup/Coins

func _ready() -> void:
  world_label.text = "1-1"
  update_ui()

func _process(delta: float) -> void:
  update_ui()

  if Input.is_action_just_pressed("pause"):
    if get_tree().paused:
      Game.resume_game()
    else:
      Game.pause_game()

func update_ui() -> void:
  if Game.time > 0:
    time_label.text = str(Game.time).pad_zeros(3)
  else:
    time_label.text = ""
  score_label.text = str(Game.score).pad_zeros(6)
  coins_label.text = str("x", Game.coins).pad_zeros(2)

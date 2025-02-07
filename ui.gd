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

func update_ui() -> void:
  time_label.text = str(Game.time).pad_zeros(3)
  score_label.text = str(Game.score).pad_zeros(6)
  coins_label.text = str("x", Game.coins).pad_zeros(2)

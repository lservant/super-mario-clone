extends CharacterBody2D
class_name Item

enum DIRECTION {LEFT, RIGHT}

func toggle_physics(enabled: bool):
  pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
  queue_free()
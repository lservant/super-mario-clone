extends Timer

var running = false

func reset(time: float = wait_time):
  running = true
  start(time)
  
func _on_timeout() -> void:
  running = false
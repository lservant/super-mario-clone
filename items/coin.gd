extends Area2D

var collected = false

func _on_body_entered(body:Node2D) -> void:
  if body.name != "player" or collected:
    return
    
  collected = true
  visible = false
  Game.add_coin()
  var coin = SoundManager.play_coin()
  coin.connect("finished", _on_audio_stream_player_finished)

func _on_audio_stream_player_finished() -> void:
  queue_free()

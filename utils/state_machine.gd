extends Node
class_name StateMachine

@export var current_state: String

@onready var parent: Node = get_parent()

func change_state(new_state: String):
  print(parent.name, ": Changing state ", current_state, ", ", new_state)
  current_state = new_state
  
  var states = self.get_child_count()
  for i in states:
    var state = self.get_child(i)
    if new_state == state.name:
      state.reset()

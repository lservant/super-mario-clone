extends Node
class_name StateBase

var state: String
@onready var sm: Node = get_parent()
@onready var actor: Node = sm.get_parent()

func reset():
  print("Resetting ", state)
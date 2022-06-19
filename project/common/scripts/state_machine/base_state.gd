extends Node
class_name BaseState

var context: Node

func init(context_node: Node):
	context = context_node

func enter():
	pass
	
func exit():
	pass
	
func input(event: InputEvent):
	pass
	
func process(delta: float):
	pass
	
func physics_process(delta: float):
	pass

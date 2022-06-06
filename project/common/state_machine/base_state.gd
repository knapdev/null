extends Node
class_name BaseState

var context: Node

func init(context: Node):
	self.context = context

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

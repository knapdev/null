extends Node
class_name StateMachine

var states: Array[BaseState] = []
var current_state: BaseState = null

var context: Node = null

func init(context_node: Node, start_state: BaseState):
	context = context_node
	push_state(start_state)

func input(event: InputEvent):
	if current_state == null:
		return
	
	current_state.input(event)
	
func process(delta: float):
	if current_state == null:
		return
	
	current_state.process(delta)
	
func physics_process(delta: float):
	if current_state == null:
		return
	
	current_state.physics_process(delta)
	
func push_state(state: BaseState):
	states.push_back(state)
	current_state = state
	current_state.init(context)
	current_state.enter()
	
func pop_state():
	if states.size() <= 0:
		return
		
	if current_state != null:
		current_state.exit()
		
	var popped_state = states.pop_back()
	popped_state.queue_free()
	
	if states.size() > 0:
		current_state = states.back()
	
func change_state(state: BaseState):
	pop_state()
	push_state(state)

func clear():
	for state in states:
		state.queue_free()
		
	states.clear()
	current_state = null

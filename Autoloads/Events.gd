extends Node

## EVENTS
## This autoload contains all the signal used along the game
# warnings-disable

signal example()

signal save_player_data()

signal language_changed()

signal lose_state()
signal win_state()

signal play_pop_up_dialog(text, pos)

signal show_unlock()
signal end_unlock()
signal title_shown()


func emit_show_unlock(lvl_id:int):
	EVENTS.emit_signal('show_unlock',lvl_id)

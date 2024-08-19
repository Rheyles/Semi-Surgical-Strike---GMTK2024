extends Node

## EVENTS
## This autoload contains all the signal used along the game
# warnings-disable

signal example()

signal save_player_data()

signal language_changed()

signal start_battlefield()

signal lose_state(lose_reson : int)
signal win_state()

signal add_node_to_battlefield(obj)

signal set_shake()
signal freeze_frame()

extends Node

## DATA
## This autoload contains all the constants used along the game

enum TEAMS {ALLY,ENEMY}
enum UNIT_TYPE {BASE_CITY,BASIC_UNIT, ALIEN_NEST, WEAK_BUG, DEMON}

enum END_TYPE {VICTORY, DEFEAT_BASE, DEFEAT_TIMER}

var team_color = {TEAMS.ALLY : Color("#92E9FF"),
				  TEAMS.ENEMY : Color("#941C2F")}

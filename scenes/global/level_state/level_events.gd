class_name LevelEvents
extends Node

signal game_started

# Emit when the player restarts the game by pressing a button
# Should:
#   - Reset level stats to default
signal game_restarted

# Emit when the player moves on to the next level with new level stats
# Should:
#   - Show perks and items selection scene (later)
#   - Show coin flip scene
signal game_continued

signal game_title_shown

# Emit when the player win rate is updated
# Should:
#   - Update the progress bar
signal level_player_win_rate_updated

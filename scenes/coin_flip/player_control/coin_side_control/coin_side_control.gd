extends Control

signal coin_side_selected


func _ready():
	pass


func _process(_delta):
	pass


func _on_tails_button_pressed():
	coin_side_selected.emit()


func _on_heads_button_pressed():
	coin_side_selected.emit()

extends Node2D

signal adios_completed

@onready var _adios_label = $AdiosLabel
@onready var _adios_animation = $AdiosAnimation


func _ready():
	await get_tree().create_timer(2).timeout
	play()


func play():
	_adios_animation.play("default")
	await _adios_animation.animation_finished
	_adios_label.show()
	adios_completed.emit()

extends Node
class_name Globals


static var instance := Globals.new()

signal _player_pos(pos: Vector3)
static var player_pos := Signal(instance._player_pos)

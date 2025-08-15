extends Node
class_name Globals


static var instance := Globals.new()

signal _player_pos(pos: Vector3)
static var player_pos := Signal(instance._player_pos)

signal _camera_rot(rot: Vector3)
static var camera_rot := Signal(instance._camera_rot)

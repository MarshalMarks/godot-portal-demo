extends Node
class_name Globals


static var instance := Globals.new()

signal _player_pos(pos: Vector3)
static var player_pos := Signal(instance._player_pos)

signal _teleport_to(pos: Vector3)
static var teleport_to := Signal(instance._teleport_to)

signal _camera_rot(rot: Vector3)
static var camera_rot := Signal(instance._camera_rot)

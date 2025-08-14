extends Node3D


@export var entrance_position: Vector3
@export var entrance_rotation: Vector3
@export var entrance_size: Vector2
@export var exit_position: Vector3
@export var exit_rotation: Vector3
@export var exit_size: Vector2

var Entrance: Node3D
var EntranceMeshInstance: MeshInstance3D
var EntranceMesh: PlaneMesh
var EntranceMeshMaterial: StandardMaterial3D

var Exit: Node3D
var ExitViewport: SubViewport
var ExitCamera: Camera3D


func _init():
	
	# Parent Nodes
	Entrance = Node3D.new()
	Exit     = Node3D.new()
	
	add_child(Entrance)
	add_child(Exit)
	
	# Entrance Nodes
	EntranceMeshInstance = MeshInstance3D.new()
	EntranceMesh = PlaneMesh.new()
	EntranceMeshMaterial = StandardMaterial3D.new()
	
	Entrance.add_child(EntranceMeshInstance)
	
	# Exit Nodes
	ExitViewport = SubViewport.new()
	ExitCamera = Camera3D.new()
	
	Exit.add_child(ExitViewport)
	ExitViewport.add_child(ExitCamera)

func _ready():
	
	# Parent Nodes
	Entrance.position = entrance_position
	Entrance.rotation_degrees = entrance_rotation
	Exit.position = exit_position
	Exit.rotation_degrees = exit_rotation
	
	# Exit Node
	ExitCamera.transform = Exit.transform
	Globals.player_pos.connect(on_player_pos)
	
	# Entrance Node
	EntranceMeshInstance.mesh = EntranceMesh
	EntranceMeshInstance.set_surface_override_material(0, EntranceMeshMaterial)
	EntranceMeshMaterial.albedo_texture = ExitViewport.get_texture()

func on_player_pos(pos: Vector3):
	ExitCamera.position = pos - Entrance.position + Exit.position
	ExitCamera.look_at(Exit.position)
	
	# TODO: to handle differing orientations maybe account the basis vectors of the player relative to the portal?

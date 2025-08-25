extends Node3D


@export var entrance_size: Vector2
@export var exit_position: Vector3
@export var exit_rotation: Vector3
@export var exit_size: Vector2

var Entrance: Node3D
var EntranceMeshInstance: MeshInstance3D
var EntranceMesh: PlaneMesh
var EntranceMeshMaterial: ShaderMaterial
var EntranceCollider: Area3D
var EntranceColliderShape: CollisionShape3D

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
	EntranceMeshMaterial = load("res://assets/portal.tres")
	EntranceCollider = Area3D.new()
	EntranceColliderShape = CollisionShape3D.new()
	
	Entrance.add_child(EntranceMeshInstance)
	Entrance.add_child(EntranceCollider)
	EntranceCollider.add_child(EntranceColliderShape)
	
	# Exit Nodes
	ExitViewport = SubViewport.new()
	ExitCamera = Camera3D.new()
	
	Exit.add_child(ExitViewport)
	ExitViewport.add_child(ExitCamera)

func _ready():
	
	# Parent Nodes
	Entrance.transform = transform
	Exit.global_position = exit_position
	Exit.global_rotation_degrees = exit_rotation
	
	# Exit Node
	ExitCamera.transform = Exit.transform
	Globals.player_pos.connect(on_player_pos)
	Globals.camera_rot.connect(on_camera_rot)
	
	# Entrance Node
	EntranceMeshInstance.mesh = EntranceMesh
	EntranceMeshInstance.set_surface_override_material(0, EntranceMeshMaterial)
	EntranceMeshMaterial.set_shader_parameter("tex", ExitViewport.get_texture())
	EntranceColliderShape.shape = EntranceMesh.create_convex_shape()
	EntranceCollider.body_entered.connect(on_body_entered)

func on_player_pos(pos: Vector3):
	var dist_from_entrance = pos - Entrance.global_position
	ExitCamera.global_position = dist_from_entrance + Exit.global_position

func on_camera_rot(rot: Vector3):
	ExitCamera.global_rotation = rot

func on_body_entered(body: Node3D):
	var dist_to_portal = body.global_position - global_position
	
	if (dist_to_portal.dot(ExitCamera.global_rotation) < 0):
		Globals.teleport_to.emit(Exit.global_position + dist_to_portal)

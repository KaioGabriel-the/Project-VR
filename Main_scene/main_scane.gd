extends Node3D

@onready var hand_ridibody_left :RigidBody3D = $HandRigidbodyLeft;
@onready var hand_ridibody_right :RigidBody3D = $HandRigidbodyRight;

@onready var hand_contr_left: Node3D = $XROrigin3D/XRController3DLeft/HandContrLeft;
@onready var hand_contr_right: Node3D = $XROrigin3D/XRController3DRight/HandContrRight;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var  xr_interface: XRInterface = XRServer.find_interface("openXR");
	
	if xr_interface and xr_interface.is_initialized():
		var vp: Viewport = get_viewport();
		vp.use_xr = true;

func _physics_process(delta: float) -> void:
	move_hand_rigibody_to_contro(hand_ridibody_left,hand_contr_left);
	move_hand_rigibody_to_contro(hand_ridibody_right,hand_contr_right);


func move_hand_rigibody_to_contro(hand_rigibody:RigidBody3D,hand_contr: Node3D) -> void:
	var move_delta : Vector3 = hand_contr.global_position - hand_rigibody.global_position;
	
	var coof_force = 300.0;
	hand_rigibody.apply_central_force(move_delta * coof_force);
	
	var quat_hand_rigibody: Quaternion = hand_rigibody.global_transform.basis.get_rotation_quaternion();
	var quat_hand_contr: Quaternion = hand_contr.global_transform.basis.get_rotation_quaternion();
	var quat_delta: Quaternion = quat_hand_contr * (quat_hand_rigibody.inverse());
	var rotetion_delta: Vector3 = Vector3(quat_delta.x, quat_delta.y, quat_delta.z) * quat_delta.w;
	
	var coof_torque := 6.0;
	hand_rigibody.apply_torque(rotetion_delta *coof_torque);

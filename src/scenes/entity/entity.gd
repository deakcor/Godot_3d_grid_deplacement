extends Spatial

class_name Entity

signal require_move(direction)
signal finished_move()

enum STATE{
	moving,
	idle
}

const asset_by_direction:={
	STATE.idle:{
		Vector3.LEFT:preload("res://assets/entity/player/idle/Char_idle_left.png"),
		Vector3.RIGHT:preload("res://assets/entity/player/idle/Char_idle_right.png"),
		Vector3.BACK:preload("res://assets/entity/player/idle/Char_idle_down.png"),
		Vector3.FORWARD:preload("res://assets/entity/player/idle/Char_idle_up.png")
	},STATE.moving:{
		Vector3.LEFT:preload("res://assets/entity/player/walk/Char_walk_left.png"),
		Vector3.RIGHT:preload("res://assets/entity/player/walk/Char_walk_right.png"),
		Vector3.BACK:preload("res://assets/entity/player/walk/Char_walk_down.png"),
		Vector3.FORWARD:preload("res://assets/entity/player/walk/Char_walk_up.png")
	}
}

onready var sprite=$sprite_3d
onready var timer=$timer
onready var tween=$tween

var state:int=STATE.idle
var map_position:Vector3=Vector3(0,0,0)
var map_id:int=0
var direction:Vector3=Vector3.FORWARD
var next_direction:Vector3=Vector3.FORWARD
var required_move_direction:Vector3

var speed:=3.0

func _ready():
	update_sprite()

func require_movement(move_direction=required_move_direction, force=false):
	if move_direction!=Vector3.ZERO:
		print("movement direction : ")
		print(move_direction)
		timer.stop()
		if state==STATE.idle:
			if next_direction==move_direction or force:
				emit_signal("require_move",move_direction)
			else:
				timer.start()
			update_sprite(move_direction)
		next_direction=move_direction
		


func move(target,tiletarget,tileid)->bool:
	if state==STATE.idle and target!=translation:
		
		map_position=tiletarget
		map_id=tileid
		state=(STATE.moving)
		var actual_pos=translation
		direction=(target-actual_pos).normalized()
		tween.interpolate_property(
			self, "translation", 
			actual_pos, target, 1/speed,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		print("moving")
		return true
	return false

func _on_tween_tween_completed(object, key):
	print("end")
	if key==":translation":
		state=(STATE.idle)
		print("movement ended")
		match global.tileid_to_landid[map_id]:
			
			global.LAND.ice:
				print("ice")
				print(direction)
				require_movement(direction,true)
				update_sprite(direction,STATE.idle)
			_:
				print("ground")
				require_movement()
				update_sprite()
		

	

func update_sprite(dir=direction,s=state):
	print("update")
	sprite.texture=asset_by_direction[s][dir]

func get_sprite():
	return sprite

func _on_timer_timeout():
	print("timer out")
	require_movement()


func _on_timer_anim_timeout():
	sprite.frame=(sprite.frame+1)%(sprite.vframes+sprite.hframes-1)
	pass

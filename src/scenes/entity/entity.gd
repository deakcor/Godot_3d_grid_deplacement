extends Spatial

class_name Entity

signal require_move(direction)
signal finished_move()

enum STATE{
	moving,
	idle
}

var state:int=STATE.idle
var map_position:Vector3=Vector3(0,0,0)
var map_id:int=0
var direction:Vector3
var next_direction:Vector3
var required_move_direction:Vector3

var speed:=3.0

func require_movement(move_direction=required_move_direction, force=false):
	if move_direction!=Vector3.ZERO:
		print("movement direction : ")
		print(move_direction)
		$timer.stop()
		if state==STATE.idle:
			if next_direction==move_direction or force:
				emit_signal("require_move",move_direction)
			else:
				$timer.start()
		next_direction=move_direction


func move(target,tiletarget,tileid)->bool:
	if state==STATE.idle and target!=translation:
		
		map_position=tiletarget
		map_id=tileid
		state=STATE.moving
		var actual_pos=translation
		direction=(target-actual_pos).normalized()
		$tween.interpolate_property(
			self, "translation", 
			actual_pos, target, 1/speed,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$tween.start()
		print("moving")
		return true
	return false

func _on_tween_tween_completed(object, key):
	print("end")
	if key==":translation":
		state=STATE.idle
		print("movement ended")
		match global.tileid_to_landid[map_id]:
			
			global.LAND.ice:
				print("ice")
				print(direction)
				require_movement(direction,true)
			_:
				print("ground")
				require_movement()
		


func _on_timer_timeout():
	print("timer out")
	require_movement()

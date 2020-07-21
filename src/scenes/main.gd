extends Spatial

onready var player:=$player
onready var gridmap:=$grid_map

var grid_offset:=Vector3.UP*0.5



func _ready():
	set_position_entity(player)
	player.connect("require_move",self,"_require_player_move")

func _require_player_move(direction:Vector3):
	print("received")
	move_entity(player,direction)

func set_position_entity(entity:Entity):
	
	entity.map_position=gridmap.world_to_map(entity.translation-grid_offset)
	var e_m_p=entity.map_position
	print("position player : ")
	print(entity.map_position)
	entity.map_id=gridmap.get_cell_item(e_m_p.x,e_m_p.y,e_m_p.z)
	entity.translation=gridmap.map_to_world(e_m_p.x,e_m_p.y,e_m_p.z)+grid_offset

func move_entity(entity:Entity,direction:Vector3):
	var target=entity.map_position+direction
	print("target : ")
	print(target)
	var target_groundid=gridmap.get_cell_item(target.x,target.y,target.z)
	var target_wallid=gridmap.get_cell_item(target.x,target.y+1,target.z)
	if target_wallid==-1:
		var land_id=global.tileid_to_landid[target_groundid]
		match land_id:
			global.LAND.ground:
				print("go to ground")
				var succes=player.move(gridmap.map_to_world(target.x,target.y,target.z)+grid_offset,target,land_id)

			global.LAND.ice:
				print("go to ice")
				var succes=player.move(gridmap.map_to_world(target.x,target.y,target.z)+grid_offset,target,target_groundid)
	
#			if succes:
#				gridmap.set_cell_item(target.x,target.y,target.z,1)

func _physics_process(delta):
	#$cam_cont.translation=lerp($cam_cont.translation,player.translation,delta*10)
	var pp=player.translation*1000
	pp=pp-Vector3(fmod(pp.x,62.5),fmod(pp.y,62.5),fmod(pp.z,62.5))
	#player.translation=pp/1000
	$cam_cont.translation=pp/1000
	player.get_sprite().global_transform.origin=$cam_cont.global_transform.origin
	player.get_sprite().translation.y=0.5
	pass

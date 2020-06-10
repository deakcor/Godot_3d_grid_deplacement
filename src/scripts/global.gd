extends Node


enum LAND{
	ground,
	ramp,
	ice,
	mud
}

const tileid_to_landid:Dictionary={
	-1:-1,
	0:LAND.ground,
	1:LAND.ice
}

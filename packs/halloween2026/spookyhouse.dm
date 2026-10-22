#include "../halloween2026/hallowevent_items.dm"
#include "spookyhouse.dmm"

/datum/map_template/ruin/spookyhouse
	name = "Spooky House"
	id = "awaysite_spooky_house"
	description = "A halloween house with a maze."
	suffixes = list("packs/halloween2026/spookyhouse.dmm")
	area_usage_test_exempted_root_areas = list(/area/hotel)

// Area shenanigans


/area/spookyhouse
	name = "spooky house"
	icon_state = "spookyhouse"
	requires_power = FALSE
	lighting_tone = AREA_LIGHTING_WARM
	var/new_brightness = 2
	forced_ambience = list('sound/ambience/maintambience.ogg')
	req_access = FALSE

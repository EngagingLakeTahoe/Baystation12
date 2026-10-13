//DECORATIONS

/obj/structure/hallowlights
	name = "halloween lights"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "stringlights_on"
	anchored = TRUE

/obj/structure/string_light/Initialize()
	. = ..()
	set_light(3, 1, "#ffc58f")

/obj/structure/cauldron/left
	name = "large cauldron"
	icon = 'packs/halloween2026/cauldron.dmi'
	icon_state = "cauldronleft"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE

/obj/structure/cauldron/right
	name = "large cauldron"
	icon = 'packs/halloween2026/cauldron.dmi'
	icon_state = "cauldronright"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE

/obj/structure/tombstone1
	name = "small tombstone"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tombstone1"
	anchored = TRUE

/obj/structure/tombstone2
	name = "tiered tombstone"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tombstone2"
	anchored = TRUE

/obj/structure/tombstone3
	name = "cross tombstone"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tombstone3"
	anchored = TRUE

/obj/structure/cornerdecoweb
	name = "fake spider web"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "cornerweb"
	anchored = TRUE

/obj/structure/bigdecoweb
	name = "big fake spider web"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "bigweb"
	anchored = TRUE

/obj/structure/decospider
	name = "big fake spider"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "spiderdeco"
	anchored = TRUE

/obj/structure/decoghost
	name = "cute spooky ghost"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "cuteghost"
	anchored = TRUE

// FOOD

/obj/item/reagent_containers/food/snacks/dipchip
	name = "a chip"
	desc = "A simple tortilla chip."
	icon_state = "dipchip"

/obj/item/reagent_containers/food/snacks/platter/dipchipbowl
	name = "a bowl of chips"
	desc = "A small bowl of tortilla chips."
	icon_state = "dipchipbowl"

/obj/item/reagent_containers/food/snacks/dip
	name = "sour cream and onion dip"
	desc = "A creamy dip of sour cream and onion."
	icon_state = "dip"

/obj/item/reagent_containers/food/snacks/carmapop
	name = "caramel apple lollipop"
	desc = "A green apple lollipop dipped in caramel."
	icon_state = "carmapop"

/obj/item/reagent_containers/food/snacks/pumpkinlolli
	name = "pumpkin lollipop"
	desc = "An orange flavored lollipop decorated to look like a pumpkin."
	icon_state = "pumpkinlolli"

/obj/item/reagent_containers/food/snacks/tortilla
	name = "flour tortilla"
	desc = "A soft tortilla"
	icon_state = "tortilla"


// FOOD RECIPES

/singleton/cooking_recipe/tortilla
	appliance = COOKING_APPLIANCE_SKILLET | COOKING_APPLIANCE_STOVE
	required_items = list(
		/obj/item/reagent_containers/food/snacks/flatdough
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/tortilla

//singleton/cooking_recipe/dipchipbowl
	appliance = COOKING_APPLIANCE_FRYER
	required_items = list(
		/obj/item/reagent_containers/food/snacks/tortilla
	)
	required_reagents = list(
		/datum/reagent/sodiumchloride = 3
	)
	result_path = /obj/item/reagent_containers/food/snacks/platter/dipchipbowl

//singleton/cooking_recipe/dip
	required_items = list(
		/obj/item/reagent_containers/food/snacks/bacon
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	required_reagents = list(
		/datum/reagent/drink/milk/cream = 3
	)
	required_produce = list(
		"onion" = 1,
		"garlic" = 1
	)
	result_path = /obj/item/reagent_containers/food/snacks/dip

// FOOD OBJECT SNACKY THING

/obj/item/reagent_containers/food/snacks/tortilla
	name = "tortilla"
	desc = "A soft tortilla."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "tortilla"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 2
	nutriment_desc = list("warm and soft flatbread" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 2

//obj/item/reagent_containers/food/snacks/dipchip
	name = "tortilla chip"
	desc = "A small bowl of tortilla chips"
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "dipchip"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 2
	nutriment_desc = list("cruncy salty chip" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 1

//obj/item/reagent_containers/food/snacks/dip
	name = "dip"
	desc = "A bowl of savory dip for chips."
	icon = 'packs/halloween2026/icons.dmi'
	icon_state = "dip"
	center_of_mass = "x=17;y=18"
	nutriment_amt = 2
	nutriment_desc = list("savory and creamy dip" = 1)
	w_class = ITEM_SIZE_TINY
	bitesize = 1

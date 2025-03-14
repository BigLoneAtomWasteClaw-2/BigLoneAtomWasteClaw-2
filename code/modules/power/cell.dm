/obj/item/stock_parts/cell
	name = "power cell"
	desc = "A rechargeable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/charge = 0	// note %age converted to actual charge in New
	var/maxcharge = 1000
	custom_materials = list(/datum/material/iron=700, /datum/material/glass=50)
	var/start_charged = TRUE
	grind_results = list(/datum/reagent/lithium = 15, /datum/reagent/iron = 5, /datum/reagent/silicon = 5)
	var/rigged = FALSE	// true if rigged to explode
	var/chargerate = 100 //how much power is given every tick in a recharger
	var/cancharge = 1 //set to 0 if you do not want this battery to be able to charge
	var/self_recharge = 0 //does it self recharge, over time, or not?
	var/ratingdesc = TRUE
	var/grown_battery = FALSE // If it's a grown that acts as a battery, add a wire overlay to it.
	rad_flags = RAD_NO_CONTAMINATE // Prevent the same cheese as with the stock parts

/obj/item/stock_parts/cell/get_cell()
	return src

/obj/item/stock_parts/cell/Initialize(mapload, override_maxcharge)
	. = ..()
	START_PROCESSING(SSobj, src)
	create_reagents(5, INJECTABLE | DRAINABLE)
	if (override_maxcharge)
		maxcharge = override_maxcharge
	if(start_charged)
		charge = maxcharge
	if(ratingdesc)
		desc += " This one has a rating of [DisplayEnergy(maxcharge)], and you should not swallow it."
	update_icon()

/obj/item/stock_parts/cell/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/stock_parts/cell/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, self_recharge))
			if(var_value)
				START_PROCESSING(SSobj, src)
			else
				STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/stock_parts/cell/process()
	if(self_recharge)
		give(chargerate * 0.25)
	else
		return PROCESS_KILL

/obj/item/stock_parts/cell/update_icon()
	cut_overlays()
	if(grown_battery)
		add_overlay(image('icons/obj/power.dmi',"grown_wires"))
	if(charge < 0.01)
		return
	else if (maxcharge == 1000 || maxcharge == 2500 || maxcharge == 5000)
		if(charge/maxcharge >=0.995)
			add_overlay("cell-o2")
		else
			add_overlay("cell-o1")

/obj/item/stock_parts/cell/proc/percent()		// return % charge of cell
	return 100*charge/maxcharge

// use power from a cell
/obj/item/stock_parts/cell/use(amount, can_explode = TRUE)
	if(rigged && amount > 0 && can_explode)
		explode()
		return 0
	if(charge < amount)
		return 0
	charge = (charge - amount)
	if(!istype(loc, /obj/machinery/power/apc))
		SSblackbox.record_feedback("tally", "cell_used", 1, type)
	return 1

// recharge the cell
/obj/item/stock_parts/cell/proc/give(amount)
	if(rigged && amount > 0)
		explode()
		return 0
	if(maxcharge < amount)
		amount = maxcharge
	var/power_used = min(maxcharge-charge,amount)
	charge += power_used
	return power_used

/obj/item/stock_parts/cell/examine(mob/user)
	. = ..()
	if(rigged)
		to_chat(user, "<span class='danger'>This power cell seems to be faulty!</span>")
	else
		to_chat(user, "The charge meter reads [round(src.percent() )]%.")

/obj/item/stock_parts/cell/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is licking the electrodes of [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (FIRELOSS)

/obj/item/stock_parts/cell/on_reagent_change(changetype)
	..()
	rigged = reagents?.has_reagent(/datum/reagent/toxin/plasma, 5) ? TRUE : FALSE //has_reagent returns the reagent datum

/obj/item/stock_parts/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
	if (charge==0)
		return
	var/devastation_range = -1 //round(charge/11000)
	var/heavy_impact_range = round(sqrt(charge)/60)
	var/light_impact_range = round(sqrt(charge)/30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = FALSE
		corrupt()
		return
	//explosion(T, 0, 1, 2, 2)
	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	qdel(src)

/obj/item/stock_parts/cell/proc/corrupt()
	charge /= 2
	maxcharge = max(maxcharge/2, chargerate)
	if (prob(10))
		rigged = TRUE //broken batterys are dangerous

/obj/item/stock_parts/cell/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	charge -= 10 * severity
	if(charge < 0)
		charge = 0

/obj/item/stock_parts/cell/ex_act(severity, target)
	..()
	if(!QDELETED(src))
		switch(severity)
			if(2)
				if(prob(50))
					corrupt()
			if(3)
				if(prob(25))
					corrupt()

/obj/item/stock_parts/cell/attack_self(mob/user)
	if(isethereal(user))
		var/mob/living/carbon/human/H = user
		if(charge < 100)
			to_chat(H, "<span class='warning'>The [src] doesn't have enough power!</span>")
			return
		var/obj/item/organ/stomach/ethereal/stomach = H.getorganslot(ORGAN_SLOT_STOMACH)
		if(stomach.crystal_charge > 146)
			to_chat(H, "<span class='warning'>Your charge is full!</span>")
			return
		to_chat(H, "<span class='notice'>You clumsily channel power through the [src] and into your body, wasting some in the process.</span>")
		if(do_after(user, 5, target = src))
			if((charge < 100) || (stomach.crystal_charge > 146))
				return
			if(istype(stomach))
				to_chat(H, "<span class='notice'>You receive some charge from the [src].</span>")
				stomach.adjust_charge(3)
				charge -= 100 //you waste way more than you receive, so that ethereals cant just steal one cell and forget about hunger
			else
				to_chat(H, "<span class='warning'>You can't receive charge from the [src]!</span>")
		return

/obj/item/stock_parts/cell/blob_act(obj/structure/blob/B)
	ex_act(EXPLODE_DEVASTATE)

/obj/item/stock_parts/cell/proc/get_electrocute_damage()
	if(charge >= 1000)
		return clamp(round(charge/10000), 10, 90) + rand(-5,5)
	else
		return 0

/obj/item/stock_parts/cell/get_part_rating()
	return rating * maxcharge

// stuff so ipcs and synthlizards can eat power cells, taken from how moths can eat clothing
/obj/item/reagent_containers/food/snacks/cell
	name = "oops"
	desc = "If you're reading this it means I messed up. This is related to ipcs/synths eating cells and I didn't know a better way to do it than making a new food object."
	list_reagents = list(/datum/reagent/consumable/nutriment = 0.5)
	tastes = list("electricity" = 1, "metal" = 1)

/obj/item/stock_parts/cell/attack(mob/M, mob/user, def_zone)
	if(user.a_intent != INTENT_HARM && isrobotic(M))
		var/obj/item/reagent_containers/food/snacks/cell/cell_as_food = new
		cell_as_food.name = name
		if(cell_as_food.attack(M, user, def_zone))
			take_damage(40, sound_effect=FALSE)
		qdel(cell_as_food)
	else
		return ..()

/* Cell variants*/
/obj/item/stock_parts/cell/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/crap
	name = "\improper Nanotrasen brand rechargeable AA battery"
	desc = "You can't top the plasma top." //TOTALLY TRADEMARK INFRINGEMENT
	maxcharge = 500
	custom_materials = list(/datum/material/glass=40)

/obj/item/stock_parts/cell/crap/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/upgraded
	name = "upgraded power cell"
	desc = "A power cell with a slightly higher capacity than normal!"
	maxcharge = 2500
	custom_materials = list(/datum/material/glass=50)
	chargerate = 1000

/obj/item/stock_parts/cell/upgraded/plus
	name = "upgraded power cell+"
	desc = "A power cell with an even higher capacity than the base model!"
	maxcharge = 5000

/obj/item/stock_parts/cell/secborg
	name = "security borg rechargeable D battery"
	maxcharge = 1250	//25/12/6 disabler/laser/taser shots.
	custom_materials = list(/datum/material/glass=40)

/obj/item/stock_parts/cell/secborg/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/lascarbine
	name = "laser carbine power supply"
	maxcharge = 1500			//20 laser shots.

/obj/item/stock_parts/cell/pulse //200 pulse shots
	name = "pulse rifle power cell"
	maxcharge = 40000
	chargerate = 1500

/obj/item/stock_parts/cell/pulse/carbine //25 pulse shots
	name = "pulse carbine power cell"
	maxcharge = 5000

/obj/item/stock_parts/cell/pulse/pistol //10 pulse shots
	name = "pulse pistol power cell"
	maxcharge = 2000
	self_recharge = 1

/obj/item/stock_parts/cell/high
	name = "high-capacity power cell"
	icon_state = "hcell"
	maxcharge = 10000
	custom_materials = list(/datum/material/glass=60)
	chargerate = 1500

/obj/item/stock_parts/cell/high/plus
	name = "high-capacity power cell+"
	desc = "Where did these come from?"
	icon_state = "h+cell"
	maxcharge = 15000
	chargerate = 2250
	rating = 2

/obj/item/stock_parts/cell/high/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/super
	name = "super-capacity power cell"
	icon_state = "scell"
	maxcharge = 20000
	custom_materials = list(/datum/material/glass=300)
	chargerate = 2000
	rating = 3

/obj/item/stock_parts/cell/super/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/hyper
	name = "hyper-capacity power cell"
	icon_state = "hpcell"
	maxcharge = 30000
	custom_materials = list(/datum/material/glass=400)
	chargerate = 3000
	rating = 4

/obj/item/stock_parts/cell/hyper/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/bluespace
	name = "bluespace power cell"
	desc = "A rechargeable transdimensional power cell."
	icon_state = "bscell"
	maxcharge = 40000
	custom_materials = list(/datum/material/glass=600)
	chargerate = 4000
	rating = 5

/obj/item/stock_parts/cell/bluespace/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	maxcharge = 30000
	custom_materials = list(/datum/material/glass=1000)
	rating = 100
	chargerate = 30000

/obj/item/stock_parts/cell/infinite/use()
	return 1

/obj/item/stock_parts/cell/infinite/abductor
	name = "void core"
	desc = "An alien power cell that produces energy seemingly out of nowhere."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cell"
	maxcharge = 50000
	ratingdesc = FALSE

/obj/item/stock_parts/cell/infinite/abductor/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)


/obj/item/stock_parts/cell/potato
	name = "potato battery"
	desc = "A rechargeable starch based power cell."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "potato"
	charge = 100
	maxcharge = 300
	custom_materials = null
	grown_battery = TRUE //it has the overlays for wires

/obj/item/stock_parts/cell/high/slime
	name = "charged slime core"
	desc = "A yellow slime core infused with plasma, it crackles with power."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "yellow slime extract"
	custom_materials = null
	rating = 5 //self-recharge makes these desirable
	self_recharge = 1 // Infused slime cores self-recharge, over time

/obj/item/stock_parts/cell/emproof
	name = "\improper EMP-proof cell"
	desc = "An EMP-proof cell."
	maxcharge = 500
	rating = 3

/obj/item/stock_parts/cell/emproof/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)

/obj/item/stock_parts/cell/emproof/empty
	start_charged = FALSE

/obj/item/stock_parts/cell/emproof/corrupt()
	return

/obj/item/stock_parts/cell/beam_rifle
	name = "beam rifle capacitor"
	desc = "A high powered capacitor that can provide huge amounts of energy in an instant."
	maxcharge = 50000
	chargerate = 5000	//Extremely energy intensive

/obj/item/stock_parts/cell/beam_rifle/corrupt()
	return

/obj/item/stock_parts/cell/beam_rifle/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	charge = clamp((charge-(100*severity)),0,maxcharge)

/obj/item/stock_parts/cell/emergency_light
	name = "miniature power cell"
	desc = "A tiny power cell with a very low power capacity. Used in light fixtures to power them in the event of an outage."
	maxcharge = 120 //Emergency lights use 0.2 W per tick, meaning ~10 minutes of emergency power from a cell
	custom_materials = list(/datum/material/glass = 20)
	w_class = WEIGHT_CLASS_TINY

/obj/item/stock_parts/cell/emergency_light/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(!A.lightswitch || !A.light_power)
		charge = 0 //For naturally depowered areas, we start with no power

//found inside the inducers ordered from cargo.
/obj/item/stock_parts/cell/inducer_supply
	maxcharge = 5000

/obj/item/stock_parts/cell/magnetic
	name = "magrifle power supply"
	maxcharge = 12000
	chargerate = 600

/obj/item/stock_parts/cell/magnetic/pistol
	name = "magpistol power supply"
	maxcharge = 6000

/obj/item/stock_parts/cell/toymagburst
	name = "toy mag burst rifle power supply"
	maxcharge = 4000


////////////////////////
// FALLOUT POWERCELLS //
////////////////////////

// Ammo cell template
/obj/item/stock_parts/cell/ammo
	name = "ammo cell"
	desc = "You shouldn't be holding this."
	cancharge = 1
	w_class = WEIGHT_CLASS_TINY

/obj/item/stock_parts/cell/ammo/update_icon()
	if(charge > 1)
		name = "[initial(name)]"
	else
		name = "used [initial(name)]"
	. = ..()

/obj/item/stock_parts/cell/ammo/New()
	..()
	return

// Microfusion cell - large energy weapons
/obj/item/stock_parts/cell/ammo/mfc
	name = "microfusion cell"
	desc = "A microfusion cell, typically used as ammunition for large energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "mfc-full"
	maxcharge = 2000

/obj/item/stock_parts/cell/ammo/mfc/update_icon()
	if(charge)
		if (charge >= (maxcharge/2)+1)
			icon_state = "mfc-full"
		if (charge >= ((maxcharge/4)+1) && charge <= (maxcharge/2))
			icon_state = "mfc-half"
	else
		icon_state = "mfc-empty"
	. = ..()

/obj/item/stock_parts/cell/ammo/ultracite
	name = "ultracite cell"
	desc = "An advanced ultracite cell, used as ammunition for special energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "ultracite"
	maxcharge = 2000

// Energy cell - small energy weapons
/obj/item/stock_parts/cell/ammo/ec
	name = "energy cell"
	desc = "An energy cell, typically used as ammunition for small-arms energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "ec-full"
	maxcharge = 1600

// Microfusion breeder
/obj/item/stock_parts/cell/ammo/breeder
	name = "microfusion breeder"
	desc = "A miniature microfusion reactor connected to capacitor banks. This is not a removable part, you messed up."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "ec-full"
	maxcharge = 1800

/obj/item/stock_parts/cell/ammo/breeder/small
	desc = "An older first-generation miniature microfusion reactor connected to capacitor banks. This is not a removable part, you messed up."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "ec-full"
	maxcharge = 700

/obj/item/stock_parts/cell/ammo/ec/update_icon()
	switch(charge)
		if (1101 to 1600)
			icon_state = "ec-full"
		if (551 to 1100)
			icon_state = "ec-twothirds"
		if (51 to 550)
			icon_state = "ec-onethirds"
		if (0 to 50)
			icon_state = "ec-empty"
	. = ..()

// Electron charge pack - rapid fire energy
/obj/item/stock_parts/cell/ammo/ecp
	name = "electron charge pack"
	desc = "An electron charge pack, typically used as ammunition for rapidly-firing energy weapons."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "ecp-full"
	maxcharge = 2400

/obj/item/stock_parts/cell/ammo/ecp/update_icon()
	if(charge)
		if (charge >= ((maxcharge/2)+1))
			icon_state = "ecp-full"
		if (charge >= ((maxcharge/4)+1) && charge <= (maxcharge/2))
			icon_state = "ecp-half"
	else
		icon_state = "ecp-empty"
	. = ..()

// Alien power cell
/obj/item/stock_parts/cell/ammo/alien
	name = "alien weapon cell"
	desc = "A weapon cell that glows and thrums with unearthly energies. You're not sure you'd be able to recharge it, but it seems very powerful."
	icon = 'icons/fallout/objects/powercells.dmi'
	icon_state = "aliencell"
	ratingdesc = FALSE
	maxcharge = 4000
	cancharge = 0

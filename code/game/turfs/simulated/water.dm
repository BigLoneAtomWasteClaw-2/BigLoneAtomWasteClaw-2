/turf/open/water
	gender = PLURAL
	name = "water"
	desc = "Shallow water."
	icon = 'icons/turf/floors.dmi'
	icon_state = "riverwater_motion"
	baseturfs = /turf/open/indestructible/ground/inside/mountain
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE
	slowdown = 2
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.

	footstep = FOOTSTEP_WATER
	barefootstep = FOOTSTEP_WATER
	clawfootstep = FOOTSTEP_WATER
	gallopfootstep = FOOTSTEP_WATER
	heavyfootstep = FOOTSTEP_WATER
	var/can_cover_up = TRUE
	var/can_build_on = TRUE

	//fortuna edit
	depth = 1 // Higher numbers indicates deeper water.


// Fortuna edit. Below is Largely ported from citadels HRP branch

/turf/open/water/Initialize()
	. = ..()
	update_icon()

/turf/open/water/update_icon()
	. = ..()

/turf/open/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/open/water))
			to_chat(L, "<span class='warning'>You get drenched in water!</span>")
	AM.water_act(5)
	..()

/turf/open/water/Exited(atom/movable/AM)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(prob(5))
			to_chat(L, "<span class='warning'>You trudge through \the [src].</span>")
	..()

/mob/living/proc/check_submerged()
	if(buckled)
		return 0
	if(locate(/obj/structure/lattice/catwalk) in loc)
		return 0
	loc = get_turf(src)
	if(istype(loc, /turf/open/indestructible/ground/outside/water) || istype(loc, /turf/open/water))
		var/turf/open/T = loc
		return T.depth
	return 0

// Use this to have things react to having water applied to them.
/atom/movable/proc/water_act(amount)
	return

/mob/living/water_act(amount)
	if(ishuman(src))
		var/mob/living/carbon/human/drownee = src
		if(!drownee || drownee.stat == DEAD)
			return
		if(drownee.resting && !drownee.internal)
			if(drownee.stat != CONSCIOUS)
				drownee.adjustOxyLoss(1)
			else
				drownee.adjustOxyLoss(1)
				if(prob(35))
					to_chat(drownee, "<span class='danger'>You're drowning!</span>")
	adjust_fire_stacks(-amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)
/turf/open/water/proc/CanCoverUp()
	return can_cover_up

/turf/open/water/proc/CanBuildHere()
	return can_build_on

/turf/open/water/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return
	if(istype(C, /obj/item/stack/rods))
		var/support
		var/obj/item/stack/rods/R = C
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			to_chat(user, "<span class='warning'>There is already a catwalk here!</span>")
			return
		if(L)
			if(R.use(1))
				to_chat(user, "<span class='notice'>You construct a catwalk.</span>")
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				new/obj/structure/lattice/catwalk(src)
			else
				to_chat(user, "<span class='warning'>You need two rods to build a catwalk!</span>")
			return
		for(var/turf/T in range(2, SSmapping.get_turf_below(src)))
			if(istype(T, /turf/closed))
				support++
				break
		if(support)
			if(R.use(1))
				to_chat(user, "<span class='notice'>You construct a lattice.</span>")
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				ReplaceWithLattice()
			else
				to_chat(user, "<span class='warning'>You need one rod to build a lattice.</span>")
		else
			to_chat(user, "<span class='warning'>You need some support under this space to make a lattice.</span>")
		return
	if(istype(C, /obj/item/stack/tile/plasteel))
		if(!CanCoverUp())
			return
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = C
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
				to_chat(user, "<span class='notice'>You build a floor.</span>")
				PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			else
				to_chat(user, "<span class='warning'>You need one floor tile to build a floor!</span>")
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support! Place metal rods first.</span>")

/turf/open/water/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	if(!CanBuildHere())
		return FALSE

	switch(the_rcd.mode)
		if(RCD_FLOORWALL)
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
			if(L)
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 1)
			else
				return list("mode" = RCD_FLOORWALL, "delay" = 0, "cost" = 3)
	return FALSE

/turf/open/water/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, "<span class='notice'>You build a floor.</span>")
			PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return TRUE
	return FALSE

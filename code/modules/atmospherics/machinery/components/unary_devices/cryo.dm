/obj/machinery/atmospherics/components/unary/cryo_cell
	name = "cryo cell"
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "pod-off"
	density = TRUE
	max_integrity = 350
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 100, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 30, "acid" = 30)
	layer = ABOVE_WINDOW_LAYER
	plane = GAME_PLANE
	state_open = FALSE
	circuit = /obj/item/circuitboard/machine/cryo_tube
	pipe_flags = PIPING_ONE_PER_TURF | PIPING_DEFAULT_LAYER_ONLY
	occupant_typecache = list(/mob/living/carbon, /mob/living/simple_animal)

	var/autoeject = FALSE
	var/volume = 100

	var/efficiency = 1
	var/base_knockout = 30 SECONDS
	var/knockout_factor = 1
	var/heat_capacity = 20000
	var/conduction_coefficient = 0.3

	var/obj/item/reagent_containers/glass/beaker = null
	var/reagent_transfer = 0

	var/obj/item/radio/radio
	var/radio_key = /obj/item/encryptionkey/headset_med
	var/radio_channel = RADIO_CHANNEL_MEDICAL

	var/running_anim = FALSE

	var/escape_in_progress = FALSE
	var/message_cooldown
	var/breakout_time = 300
	///Cryo will continue to treat people with 0 damage but existing wounds, but will sound off when damage healing is done in case doctors want to directly treat the wounds instead
	var/treating_wounds = FALSE

	fair_market_price = 10
	payment_department = ACCOUNT_MED

/obj/machinery/atmospherics/components/unary/cryo_cell/Initialize()
	. = ..()
	initialize_directions = dir

	radio = new(src)
	radio.keyslot = new radio_key
	radio.subspace_transmission = TRUE
	radio.canhear_range = 0
	radio.recalculateChannels()

/obj/machinery/atmospherics/components/unary/cryo_cell/on_construction()
	..(dir, dir)

/obj/machinery/atmospherics/components/unary/cryo_cell/RefreshParts()
	var/C
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		C += M.rating
	// 2 bins total, so C ranges from 2 to 8.
	efficiency = initial(efficiency) * C
	knockout_factor = initial(knockout_factor) / max(1, (C * 0.33))
	heat_capacity = initial(heat_capacity) / C
	conduction_coefficient = initial(conduction_coefficient) * C

/obj/machinery/atmospherics/components/unary/cryo_cell/examine(mob/user) //this is leaving out everything but efficiency since they follow the same idea of "better matter bin, better results"
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Efficiency at <b>[efficiency*100]%</b>.</span>"

/obj/machinery/atmospherics/components/unary/cryo_cell/Destroy()
	QDEL_NULL(radio)
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/atmospherics/components/unary/cryo_cell/contents_explosion(severity, target)
	..()
	if(beaker)
		beaker.ex_act(severity, target)

/obj/machinery/atmospherics/components/unary/cryo_cell/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker = null
		updateUsrDialog()

/obj/machinery/atmospherics/components/unary/cryo_cell/on_deconstruction()
	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null

/obj/machinery/atmospherics/components/unary/cryo_cell/update_icon()
	cut_overlays()

	if(panel_open)
		add_overlay("pod-panel")

	if(state_open)
		icon_state = "pod-open"
		return

	if(occupant)
		var/image/occupant_overlay

		if(ismonkey(occupant)) // Monkey
			occupant_overlay = image(CRYOMOBS, "monkey")
		else if(isalienadult(occupant))
			if(isalienroyal(occupant)) // Queen and prae
				occupant_overlay = image(CRYOMOBS, "alienq")
			else if(isalienhunter(occupant)) // Hunter
				occupant_overlay = image(CRYOMOBS, "alienh")
			else if(isaliensentinel(occupant)) // Sentinel
				occupant_overlay = image(CRYOMOBS, "aliens")
			else // Drone or other
				occupant_overlay = image(CRYOMOBS, "aliend")

		else if(ishuman(occupant) || islarva(occupant) || (isanimal(occupant) && !ismegafauna(occupant))) // Mobs that are smaller than cryotube
			occupant_overlay = image(occupant.icon, occupant.icon_state)
			occupant_overlay.copy_overlays(occupant)

		else
			occupant_overlay = image(CRYOMOBS, "generic")

		occupant_overlay.dir = SOUTH
		occupant_overlay.pixel_y = 22

		if(on && !running_anim && is_operational())
			icon_state = "pod-on"
			running_anim = TRUE
			run_anim(TRUE, occupant_overlay)
		else
			icon_state = "pod-off"
			add_overlay(occupant_overlay)
			add_overlay("cover-off")

	else if(on && is_operational())
		icon_state = "pod-on"
		add_overlay("cover-on")
	else
		icon_state = "pod-off"
		add_overlay("cover-off")

/obj/machinery/atmospherics/components/unary/cryo_cell/proc/run_anim(anim_up, image/occupant_overlay)
	if(!on || !occupant || !is_operational())
		running_anim = FALSE
		return
	cut_overlays()
	if(occupant_overlay.pixel_y != 23) // Same effect as occupant_overlay.pixel_y == 22 || occupant_overlay.pixel_y == 24
		anim_up = occupant_overlay.pixel_y == 22 // Same effect as if(occupant_overlay.pixel_y == 22) anim_up = TRUE ; if(occupant_overlay.pixel_y == 24) anim_up = FALSE
	if(anim_up)
		occupant_overlay.pixel_y++
	else
		occupant_overlay.pixel_y--
	add_overlay(occupant_overlay)
	add_overlay("cover-on")
	addtimer(CALLBACK(src, PROC_REF(run_anim), anim_up, occupant_overlay), 7, TIMER_UNIQUE)

/obj/machinery/atmospherics/components/unary/cryo_cell/nap_violation(mob/violator)
	open_machine()

/obj/machinery/atmospherics/components/unary/cryo_cell/process()
	..()

	if(!on)
		return
	if(!is_operational())
		on = FALSE
		update_icon()
		return
	if(!occupant)
		return

	var/mob/living/mob_occupant = occupant
	if(!check_nap_violations())
		return
	if(mob_occupant.stat == DEAD) // We don't bother with dead people.
		return

	if(mob_occupant.health >= mob_occupant.getMaxHealth()) // Don't bother with fully healed people.
		if(iscarbon(mob_occupant))
			var/mob/living/carbon/C = mob_occupant
			if(C.all_wounds)
				if(!treating_wounds) // if we have wounds and haven't already alerted the doctors we're only dealing with the wounds, let them know
					treating_wounds = TRUE
					playsound(src, 'sound/machines/cryo_warning.ogg', volume) // Bug the doctors.
					var/msg = "Patient vitals fully recovered, continuing automated wound treatment."
					radio.talk_into(src, msg, radio_channel)
			else // otherwise if we were only treating wounds and now we don't have any, turn off treating_wounds so we can boot 'em out
				treating_wounds = FALSE

		if(!treating_wounds)
			on = FALSE
			update_icon()
			playsound(src, 'sound/machines/cryo_warning.ogg', volume) // Bug the doctors.
			var/msg = "Patient fully restored."
			if(autoeject) // Eject if configured.
				msg += " Auto ejecting patient now."
				open_machine()
			radio.talk_into(src, msg, radio_channel)
			return

	var/datum/gas_mixture/air1 = airs[1]

	if(air1.total_moles())
		if(mob_occupant.bodytemperature < T0C) // Sleepytime. Why? More cryo magic.
			// temperature factor goes from 1 to about 2.5
			var/amount = max(1, (4 * log(T0C - mob_occupant.bodytemperature)) - 20) * knockout_factor * base_knockout
			mob_occupant.Sleeping(amount)
			mob_occupant.Unconscious(amount)
		if(beaker)
			if(reagent_transfer == 0) // Magically transfer reagents. Because cryo magic.
				beaker.reagents.trans_to(occupant, 1, efficiency * 0.25) // Transfer reagents.
				beaker.reagents.reaction(occupant, VAPOR)
				air1.adjust_moles(GAS_O2, -max(0,air1.get_moles(GAS_O2) - 2 / efficiency)) //Let's use gas for this
			if(++reagent_transfer >= 10 * efficiency) // Throttle reagent transfer (higher efficiency will transfer the same amount but consume less from the beaker).
				reagent_transfer = 0

	return 1

/obj/machinery/atmospherics/components/unary/cryo_cell/process_atmos()
	..()

	if(!on)
		return

	var/datum/gas_mixture/air1 = airs[1]

	if(!nodes[1] || !airs[1] || air1.get_moles(GAS_O2) < 5) // Turn off if the machine won't work.
		on = FALSE
		update_icon()
		return

	if(occupant)
		var/mob/living/mob_occupant = occupant
		var/cold_protection = 0
		var/temperature_delta = air1.return_temperature() - mob_occupant.bodytemperature // The only semi-realistic thing here: share temperature between the cell and the occupant.

		if(ishuman(occupant))
			var/mob/living/carbon/human/H = occupant
			cold_protection = H.get_thermal_protection(air1.return_temperature(), TRUE)

		if(abs(temperature_delta) > 1)
			var/air_heat_capacity = air1.heat_capacity()

			var/heat = ((1 - cold_protection) * 0.1 + conduction_coefficient) * temperature_delta * (air_heat_capacity * heat_capacity / (air_heat_capacity + heat_capacity))

			air1.set_temperature(max(air1.return_temperature() - heat / air_heat_capacity, TCMB))
			mob_occupant.adjust_bodytemperature(heat / heat_capacity, TCMB)

		air1.set_temperature(max(air1.return_temperature() - 0.5 / efficiency)) // Magically consume gas? Why not, we run on cryo magic.

/obj/machinery/atmospherics/components/unary/cryo_cell/power_change()
	..()
	update_icon()

/obj/machinery/atmospherics/components/unary/cryo_cell/relaymove(mob/user)
	if(message_cooldown <= world.time)
		message_cooldown = world.time + 50
		to_chat(user, "<span class='warning'>[src]'s door won't budge!</span>")

/obj/machinery/atmospherics/components/unary/cryo_cell/open_machine(drop = 0)
	if(!state_open && !panel_open)
		on = FALSE
		..()
	for(var/mob/M in contents) //only drop mobs
		M.forceMove(get_turf(src))
		if(isliving(M))
			var/mob/living/L = M
			L.update_mobility()
	occupant = null
	update_icon()

/obj/machinery/atmospherics/components/unary/cryo_cell/close_machine(mob/living/carbon/user)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		reagent_transfer = 0
		return occupant

/obj/machinery/atmospherics/components/unary/cryo_cell/container_resist(mob/living/user)
	user.visible_message("<span class='notice'>You see [user] kicking against the glass of [src]!</span>", \
		"<span class='notice'>You struggle inside [src], kicking the release with your foot... (this will take about [DisplayTimeText(breakout_time)].)</span>", \
		"<span class='italics'>You hear a thump from [src].</span>")
	if(do_after(user, breakout_time, target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src )
			return
		user.visible_message("<span class='warning'>[user] successfully broke out of [src]!</span>", \
			"<span class='notice'>You successfully break out of [src]!</span>")
		open_machine()

/obj/machinery/atmospherics/components/unary/cryo_cell/examine(mob/user)
	. = ..()
	if(occupant)
		if(on)
			. += "Someone's inside [src]!"
		else
			. += "You can barely make out a form floating in [src]."
	else
		. += "[src] seems empty."

/obj/machinery/atmospherics/components/unary/cryo_cell/MouseDrop_T(mob/living/carbon/target, mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !user.Adjacent(target) || !istype(target) || !user.IsAdvancedToolUser())
		return
	if(!CHECK_MOBILITY(target, MOBILITY_MOVE))
		close_machine(target)
	else
		user.visible_message("<b>[user]</b> starts shoving [target] inside [src].", "<span class='notice'>You start shoving [target] inside [src].</span>")
		if (do_after(user, 25, target=target))
			close_machine(target)

/obj/machinery/atmospherics/components/unary/cryo_cell/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass))
		. = 1 //no afterattack
		if(beaker)
			to_chat(user, "<span class='warning'>A beaker is already loaded into [src]!</span>")
			return
		if(!user.transferItemToLoc(I, src))
			return
		beaker = I
		user.visible_message("[user] places [I] in [src].", \
							"<span class='notice'>You place [I] in [src].</span>")
		var/reagentlist = pretty_string_from_reagent_list(I.reagents.reagent_list)
		log_game("[key_name(user)] added an [I] to cryo containing [reagentlist]")
		return
	if(!on && !occupant && !state_open && (default_deconstruction_screwdriver(user, "pod-off", "pod-off", I)) \
		|| default_change_direction_wrench(user, I) \
		|| default_pry_open(I) \
		|| default_deconstruction_crowbar(I))
		update_icon()
		return
	else if(istype(I, /obj/item/screwdriver))
		to_chat(user, "<span class='notice'>You can't access the maintenance panel while the pod is " \
		+ (on ? "active" : (occupant ? "full" : "open")) + ".</span>")
		return
	return ..()

/obj/machinery/atmospherics/components/unary/cryo_cell/ui_state(mob/user)
	return GLOB.notcontained_state

/obj/machinery/atmospherics/components/unary/cryo_cell/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Cryo", name)
		ui.open()

/obj/machinery/atmospherics/components/unary/cryo_cell/ui_data()
	var/list/data = list()
	data["isOperating"] = on
	data["hasOccupant"] = occupant ? TRUE : FALSE
	data["isOpen"] = state_open
	data["autoEject"] = autoeject

	data["occupant"] = list()
	if(occupant)
		var/mob/living/mob_occupant = occupant
		data["occupant"]["name"] = mob_occupant.name
		switch(mob_occupant.stat)
			if(CONSCIOUS)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "good"
			if(SOFT_CRIT)
				data["occupant"]["stat"] = "Conscious"
				data["occupant"]["statstate"] = "average"
			if(UNCONSCIOUS)
				data["occupant"]["stat"] = "Unconscious"
				data["occupant"]["statstate"] = "average"
			if(DEAD)
				data["occupant"]["stat"] = "Dead"
				data["occupant"]["statstate"] = "bad"
		data["occupant"]["health"] = round(mob_occupant.health, 1)
		data["occupant"]["maxHealth"] = mob_occupant.maxHealth
		data["occupant"]["minHealth"] = HEALTH_THRESHOLD_DEAD
		data["occupant"]["bruteLoss"] = round(mob_occupant.getBruteLoss(), 1)
		data["occupant"]["oxyLoss"] = round(mob_occupant.getOxyLoss(), 1)
		data["occupant"]["toxLoss"] = round(mob_occupant.getToxLoss(), 1)
		data["occupant"]["fireLoss"] = round(mob_occupant.getFireLoss(), 1)
		data["occupant"]["bodyTemperature"] = round(mob_occupant.bodytemperature, 1)
		if(mob_occupant.bodytemperature < TCRYO)
			data["occupant"]["temperaturestatus"] = "good"
		else if(mob_occupant.bodytemperature < T0C)
			data["occupant"]["temperaturestatus"] = "average"
		else
			data["occupant"]["temperaturestatus"] = "bad"

	var/datum/gas_mixture/air1 = airs[1]
	data["cellTemperature"] = round(air1.return_temperature(), 1)

	data["isBeakerLoaded"] = beaker ? TRUE : FALSE
	var/beakerContents = list()
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents += list(list("name" = R.name, "volume" = R.volume))
	data["beakerContents"] = beakerContents
	return data

/obj/machinery/atmospherics/components/unary/cryo_cell/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			if(on)
				on = FALSE
			else if(!state_open)
				on = TRUE
			. = TRUE
		if("door")
			if(state_open)
				close_machine()
			else
				open_machine()
			. = TRUE
		if("autoeject")
			autoeject = !autoeject
			. = TRUE
		if("ejectbeaker")
			if(beaker)
				beaker.forceMove(drop_location())
				if(Adjacent(usr) && !issilicon(usr))
					usr.put_in_hands(beaker)
				beaker = null
				. = TRUE
	update_icon()

/obj/machinery/atmospherics/components/unary/cryo_cell/CtrlClick(mob/user)
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK) && !state_open)
		on = !on
		update_icon()
	return ..()

/obj/machinery/atmospherics/components/unary/cryo_cell/AltClick(mob/user)
	. = ..()
	if(user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		if(state_open)
			close_machine()
		else
			open_machine()
		update_icon()
		return TRUE

/obj/machinery/atmospherics/components/unary/cryo_cell/update_remote_sight(mob/living/user)
	return // we don't see the pipe network while inside cryo.

/obj/machinery/atmospherics/components/unary/cryo_cell/get_remote_view_fullscreens(mob/user)
	user.overlay_fullscreen("remote_view", /obj/screen/fullscreen/impaired, 1)

/obj/machinery/atmospherics/components/unary/cryo_cell/can_crawl_through()
	return // can't ventcrawl in or out of cryo.

/obj/machinery/atmospherics/components/unary/cryo_cell/can_see_pipes()
	return 0 // you can't see the pipe network when inside a cryo cell.

/obj/machinery/atmospherics/components/unary/cryo_cell/return_temperature()
	var/datum/gas_mixture/G = airs[1]

	if(G.total_moles() > 10)
		return G.return_temperature()
	return ..()

/obj/machinery/atmospherics/components/unary/cryo_cell/default_change_direction_wrench(mob/user, obj/item/wrench/W)
	. = ..()
	if(.)
		SetInitDirections()
		var/obj/machinery/atmospherics/node = nodes[1]
		if(node)
			node.disconnect(src)
			nodes[1] = null
		nullifyPipenet(parents[1])
		atmosinit()
		node = nodes[1]
		if(node)
			node.atmosinit()
			node.addMember(src)
		SSair.add_to_rebuild_queue(src)

#undef CRYOMOBS

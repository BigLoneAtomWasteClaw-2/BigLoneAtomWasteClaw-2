//Sigils: Rune-like markings on the ground with various effects.
/obj/effect/clockwork/sigil
	name = "sigil"
	desc = "A strange set of markings drawn on the ground."
	clockwork_desc = "A sigil of some purpose."
	icon_state = "sigil"
	layer = LOW_OBJ_LAYER
	plane = ABOVE_WALL_PLANE
	alpha = 50
	resistance_flags = NONE
	var/affects_servants = FALSE
	var/stat_affected = CONSCIOUS
	var/sigil_name = "Sigil"
	var/resist_string = "glows blinding white" //string for when a null rod blocks its effects, "glows [resist_string]"
	var/check_antimagic = TRUE
	var/check_holy = FALSE

/obj/effect/clockwork/sigil/Initialize()
	. = ..()

/obj/effect/clockwork/sigil/attackby(obj/item/I, mob/living/user, params)
	if(I.force)
		if(is_servant_of_ratvar(user) && user.a_intent != INTENT_HARM)
			return ..()
		user.visible_message("<span class='warning'>[user] scatters [src] with [I]!</span>", "<span class='danger'>You scatter [src] with [I]!</span>")
		qdel(src)
		return 1
	return ..()

/obj/effect/clockwork/sigil/attack_tk(mob/user)
	return //you can't tk stomp sigils, but you can hit them with something

/obj/effect/clockwork/sigil/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(iscarbon(user) && !user.stat)
		if(is_servant_of_ratvar(user) && user.a_intent != INTENT_HARM)
			return ..()
		user.visible_message("<span class='warning'>[user] stamps out [src]!</span>", "<span class='danger'>You stomp on [src], scattering it into thousands of particles.</span>")
		qdel(src)
		return TRUE
	. = ..()

/obj/effect/clockwork/sigil/ex_act(severity)
	visible_message("<span class='warning'>[src] scatters into thousands of particles.</span>")
	qdel(src)

/obj/effect/clockwork/sigil/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.stat <= stat_affected)
			if((!is_servant_of_ratvar(L) || (affects_servants && is_servant_of_ratvar(L))) && (L.mind || L.has_status_effect(STATUS_EFFECT_SIGILMARK)) && !isdrone(L))
				var/atom/I = L.anti_magic_check(check_antimagic, check_holy)
				if(I)
					if(isitem(I))
						L.visible_message("<span class='warning'>[L]'s [I.name] [resist_string], protecting [L.p_them()] from [src]'s effects!</span>", \
						"<span class='userdanger'>Your [I.name] [resist_string], protecting you!</span>")
					return
				INVOKE_ASYNC(src, PROC_REF(sigil_effects), L)

/obj/effect/clockwork/sigil/proc/sigil_effects(mob/living/L)


//Sigil of Transgression: Stuns the first non-servant to walk on it and flashes all nearby non_servants. Nar'Sian cultists are damaged and knocked down for a longer time
/obj/effect/clockwork/sigil/transgression
	name = "dull sigil"
	desc = "A dull, barely-visible golden sigil. It's as though light was carved into the ground."
	icon = 'icons/effects/clockwork_effects.dmi'
	clockwork_desc = "A sigil that will stun the next non-Servant to cross it."
	icon_state = "sigildull"
	layer = HIGH_SIGIL_LAYER
	alpha = 75
	color = "#FAE48C"
	light_range = 1.4
	light_power = 1
	light_color = "#FAE48C"
	sigil_name = "Sigil of Transgression"

/obj/effect/clockwork/sigil/transgression/sigil_effects(mob/living/L)
	var/target_flashed = L.flash_act()
	for(var/mob/living/M in viewers(5, src))
		if(!is_servant_of_ratvar(M) && M != L)
			M.flash_act()
	if(iscultist(L)) //No longer stuns cultists, instead sets them on fire and burns them
		to_chat(L, "<span class='heavy_brass'>\"Watch your step, wretch.\"</span>")
		L.adjustFireLoss(10)
		L.DefaultCombatKnockdown(20, FALSE)
		L.adjust_fire_stacks(5) //Burn!
		L.IgniteMob()
	else
		L.Stun(40)
	L.visible_message("<span class='warning'>[src] appears around [L] in a burst of light!</span>", \
	"<span class='userdanger'>[target_flashed ? "An unseen force":"The glowing sigil around you"] [iscultist(L) ? "painfully bursts into flames!" : "holds you in place!"]</span>")
	L.apply_status_effect(STATUS_EFFECT_BELLIGERENT)
	new /obj/effect/temp_visual/ratvar/sigil/transgression(get_turf(src))
	qdel(src)


//Sigil of Submission: After a short time, converts any non-servant standing on it. Knocks down and silences them for five seconds afterwards.
/obj/effect/clockwork/sigil/submission
	name = "ominous sigil"
	desc = "A luminous golden sigil. Something about it really bothers you."
	clockwork_desc = "A sigil that will enslave any non-Servant that remains on it for 8 seconds. Cannot penetrate mindshield implants."
	icon_state = "sigilsubmission"
	layer = LOW_SIGIL_LAYER
	alpha = 125
	color = "#FAE48C"
	light_range = 2 //soft light
	light_power = 0.9
	light_color = "#FAE48C"
	stat_affected = UNCONSCIOUS
	resist_string = "glows faintly yellow"
	var/convert_time = 80
	var/delete_on_finish = TRUE
	sigil_name = "Sigil of Submission"
	var/glow_type = /obj/effect/temp_visual/ratvar/sigil/submission

/obj/effect/clockwork/sigil/submission/sigil_effects(mob/living/L)
	var/turf/T = get_turf(src)
	var/has_sigil = FALSE
	var/has_servant = FALSE
	if(locate(/obj/effect/clockwork/sigil/transgression) in T)
		has_sigil = TRUE
	for(var/mob/living/M in range(3, src))
		if(is_servant_of_ratvar(M) && !M.stat)
			has_servant = TRUE
	if(!has_sigil && !has_servant)
		visible_message("<span class='danger'>[src] strains into a gentle violet color, but quietly fades...</span>")
		return
	L.visible_message("<span class='warning'>[src] begins to glow a piercing magenta!</span>", "<span class='sevtug'>You feel something start to invade your mind...</span>")
	var/oldcolor = color
	animate(src, color = "#AF0AAF", time = convert_time, flags = ANIMATION_END_NOW)
	var/obj/effect/temp_visual/ratvar/sigil/glow
	if(glow_type)
		glow = new glow_type(get_turf(src))
		animate(glow, alpha = 255, time = convert_time)
	var/end_time = world.time+convert_time
	while(world.time < end_time && get_turf(L) == get_turf(src))
		stoplag(1)
	if(get_turf(L) != get_turf(src))
		if(glow)
			qdel(glow)
		animate(src, color = oldcolor, time = 20, flags = ANIMATION_END_NOW)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 20)
		visible_message(span_warning("[src] slowly stops glowing!"))
		return
	if(is_eligible_servant(L))
		to_chat(L, "<span class='heavy_brass'>\"You belong to me now.\"</span>")
		if(!GLOB.application_scripture_unlocked)
			GLOB.application_scripture_unlocked = TRUE
			hierophant_message("<span class='large_brass bold'>With the conversion of a new servant the Ark's power grows. Application scriptures are now available.</span>")
	if(add_servant_of_ratvar(L))
		L.log_message("conversion was done with a [sigil_name]", LOG_ATTACK, color="BE8700")
		if(iscarbon(L))
			var/mob/living/carbon/M = L
			M.uncuff()
		var/brutedamage = L.getBruteLoss()
		var/burndamage = L.getFireLoss()
		if(brutedamage || burndamage)
			L.adjustBruteLoss(-(brutedamage * 0.25))
			L.adjustFireLoss(-(burndamage * 0.25))
	L.DefaultCombatKnockdown(50) //Completely defenseless for five seconds - mainly to give them time to read over the information they've just been presented with
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.silent += 5
	var/message = "[sigil_name] in [get_area(src)] <span class='sevtug'>[is_servant_of_ratvar(L) ? "successfully converted" : "failed to convert"]</span>"
	for(var/M in GLOB.mob_list)
		if(isobserver(M))
			var/link = FOLLOW_LINK(M, L)
			to_chat(M,  "[link] <span class='heavy_brass'>[message] [L.real_name]!</span>")
		else if(is_servant_of_ratvar(M))
			if(M == L)
				to_chat(M, "<span class='heavy_brass'>[message] you!</span>")
			else
				to_chat(M, "<span class='heavy_brass'>[message] [L.real_name]!</span>")
	animate(src, color = oldcolor, time = 20, flags = ANIMATION_END_NOW)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 20)
	visible_message(span_warning("[src] slowly stops glowing!"))


//Sigil of Transmission: Serves as an access point for powered structures.
/obj/effect/clockwork/sigil/transmission
	name = "suspicious sigil"
	desc = "A glowing orange sigil. The air around it feels staticky."
	clockwork_desc = "A sigil that serves as power generation and a battery for clockwork structures, linked to all other sigils of its type."
	icon_state = "sigiltransmission"
	alpha = 50
	color = "#EC8A2D"
	light_color = "#EC8A2D"
	resist_string = "glows faintly"
	sigil_name = "Sigil of Transmission"
	affects_servants = TRUE

/obj/effect/clockwork/sigil/transmission/Initialize()
	. = ..()
	update_icon()

/obj/effect/clockwork/sigil/transmission/ex_act(severity)
	if(severity == 3)
		adjust_clockwork_power(500) //Light explosions charge the network!
		visible_message("<span class='warning'>[src] flares a brilliant orange!</span>")
	else
		..()

/obj/effect/clockwork/sigil/transmission/examine(mob/user)
	. = ..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		var/structure_number = 0
		for(var/obj/structure/destructible/clockwork/powered/P in range(SIGIL_ACCESS_RANGE, src))
			structure_number++
		. += "<span class='[get_clockwork_power() ? "brass":"alloy"]'>It is storing <b>[DisplayPower(get_clockwork_power())]</b> of shared power, \
		and <b>[structure_number]</b> clockwork structure[structure_number == 1 ? " is":"s are"] in range.</span>"
		if(iscyborg(user))
			. += "<span class='brass'>You can recharge from the [sigil_name] by crossing it.</span>"

/obj/effect/clockwork/sigil/transmission/sigil_effects(mob/living/L)
	if(is_servant_of_ratvar(L))
		if(iscyborg(L))
			charge_cyborg(L)
	else if(get_clockwork_power())
		to_chat(L, "<span class='brass'>You feel a slight, static shock.</span>")

/obj/effect/clockwork/sigil/transmission/process()
	var/power_drained = 0
	var/power_mod = 0.005
	for(var/t in spiral_range_turfs(SIGIL_ACCESS_RANGE, src))
		var/turf/T = t
		for(var/M in T)
			var/atom/movable/A = M
			power_drained += A.power_drain(TRUE)

		CHECK_TICK

	adjust_clockwork_power(power_drained * power_mod * 15)
	new /obj/effect/temp_visual/ratvar/sigil/transmission(loc, 1 + (power_drained * 0.0035))

/obj/effect/clockwork/sigil/transmission/proc/charge_cyborg(mob/living/silicon/robot/cyborg)
	if(!cyborg_checks(cyborg))
		return
	to_chat(cyborg, span_brass("You start to charge from the [sigil_name]..."))
	if(!do_after(cyborg, 50, target = src, extra_checks = CALLBACK(src, PROC_REF(cyborg_checks), cyborg, TRUE)))
		return
	var/giving_power = min(FLOOR(cyborg.cell.maxcharge - cyborg.cell.charge, MIN_CLOCKCULT_POWER), get_clockwork_power()) //give the borg either all our power or their missing power floored to MIN_CLOCKCULT_POWER
	if(adjust_clockwork_power(-giving_power))
		cyborg.visible_message("<span class='warning'>[cyborg] glows a brilliant orange!</span>")
		var/previous_color = cyborg.color
		cyborg.color = list("#EC8A2D", "#EC8A2D", "#EC8A2D", rgb(0,0,0))
		cyborg.apply_status_effect(STATUS_EFFECT_POWERREGEN, giving_power * 0.1) //ten ticks, restoring 10% each
		animate(cyborg, color = previous_color, time = 100)
		addtimer(CALLBACK(cyborg, TYPE_PROC_REF(/atom, update_atom_colour)), 100)

/obj/effect/clockwork/sigil/transmission/proc/cyborg_checks(mob/living/silicon/robot/cyborg, silent)
	if(!cyborg.cell)
		if(!silent)
			to_chat(cyborg, "<span class='warning'>You have no cell!</span>")
		return FALSE
	if(!get_clockwork_power())
		if(!silent)
			to_chat(cyborg, "<span class='warning'>There is no power available across sigils!</span>")
		return FALSE
	if(cyborg.cell.charge > cyborg.cell.maxcharge - MIN_CLOCKCULT_POWER)
		if(!silent)
			to_chat(cyborg, "<span class='warning'>You are already at maximum charge!</span>")
		return FALSE
	if(cyborg.has_status_effect(STATUS_EFFECT_POWERREGEN))
		if(!silent)
			to_chat(cyborg, "<span class='warning'>You are already regenerating power!</span>")
		return FALSE
	return TRUE

/obj/effect/clockwork/sigil/transmission/update_icon()
	. = ..()
	var/power_charge = get_clockwork_power()
	if(GLOB.ratvar_awakens)
		alpha = 255
	else
		alpha = min(CEILING(initial(alpha) + power_charge * 0.02, 35), 255)
	var/r = alpha * 0.02
	var/p = max(alpha * 0.01, 0.1)
	if(!power_charge && light_range != 0)
		set_light(0)
	else if(r != light_range || p != light_power)
		set_light(r, p)

//Vitality Matrix: Drains health from non-servants to heal or even revive servants.
/obj/effect/clockwork/sigil/vitality
	name = "comforting sigil"
	desc = "A faint blue sigil. Looking at it makes you feel protected."
	clockwork_desc = "A sigil that will drain non-Servants that remain on it. Servants that remain on it will be healed if it has any vitality drained."
	icon_state = "sigilvitality"
	layer = SIGIL_LAYER
	alpha = 125
	color = "#123456"
	affects_servants = TRUE
	stat_affected = DEAD
	resist_string = "glows shimmering yellow"
	sigil_name = "Vitality Matrix"
	var/revive_cost = 150
	var/sigil_active = FALSE
	var/min_drain_health = -INFINITY
	var/can_dust = TRUE
	var/animation_number = 3 //each cycle increments this by 1, at 4 it produces an animation and resets
	var/static/list/damage_heal_order = list(CLONE, TOX, BURN, BRUTE, OXY) //we heal damage in this order

/obj/effect/clockwork/sigil/vitality/neutered
	min_drain_health = 20
	can_dust = FALSE

/obj/effect/clockwork/sigil/vitality/examine(mob/user)
	. = ..()
	if(is_servant_of_ratvar(user) || isobserver(user))
		. += "<span class='[GLOB.clockwork_vitality ? "inathneq_small":"alloy"]'>It has access to <b>[GLOB.ratvar_awakens ? "INFINITE":GLOB.clockwork_vitality]</b> units of vitality.</span>"
		if(GLOB.ratvar_awakens)
			. += "<span class='inathneq_small'>It can revive Servants at no cost!</span>"
		else
			. += "<span class='inathneq_small'>It can revive Servants at a cost of <b>[revive_cost]</b> vitality.</span>"

/obj/effect/clockwork/sigil/vitality/sigil_effects(mob/living/L)
	if((is_servant_of_ratvar(L) && L.suiciding) || sigil_active)
		return
	animate(src, alpha = 255, time = 10, flags = ANIMATION_END_NOW) //we may have a previous animation going. finish it first, then do this one without delay.
	sleep(10)
//as long as they're still on the sigil and are either not a servant or they're a servant AND it has remaining vitality
	var/consumed_vitality
	while(L && (!is_servant_of_ratvar(L) || (is_servant_of_ratvar(L) && (GLOB.ratvar_awakens || GLOB.clockwork_vitality))) && get_turf(L) == get_turf(src) && !L.buckled)
		sigil_active = TRUE
		if(animation_number >= 4)
			new /obj/effect/temp_visual/ratvar/sigil/vitality(get_turf(src))
			animation_number = 0
		animation_number++
		if(!is_servant_of_ratvar(L))
			var/vitality_drained = 0
			if(L.stat == DEAD && !consumed_vitality && can_dust)
				consumed_vitality = TRUE //Prevent the target from being consumed multiple times
				vitality_drained = L.maxHealth
				var/obj/effect/temp_visual/ratvar/sigil/vitality/V = new /obj/effect/temp_visual/ratvar/sigil/vitality(get_turf(src))
				animate(V, alpha = 0, transform = matrix()*2, time = 8)
				playsound(L, 'sound/magic/wandodeath.ogg', 50, 1)
				L.visible_message("<span class='warning'>[L] collapses in on [L.p_them()]self as [src] flares bright blue!</span>")
				to_chat(L, "<span class='inathneq_large'>\"[text2ratvar("Your life will not be wasted.")]\"</span>")
				for(var/obj/item/W in L)
					if(!L.dropItemToGround(W))
						qdel(W)
				L.dust()
			else if(L.health > min_drain_health)
				if(!GLOB.ratvar_awakens && L.stat == CONSCIOUS)
					vitality_drained = L.adjustToxLoss(1, forced = TRUE)
				else
					vitality_drained = L.adjustToxLoss(1.5, forced = TRUE)
			if(vitality_drained)
				GLOB.clockwork_vitality += vitality_drained
			else
				break
		else
			if(L.stat == DEAD)
				var/revival_cost = revive_cost
				if(GLOB.ratvar_awakens || L.suiciding) // No cost if Ratvar is summoned or if you're reviving a convert who suicided
					revival_cost = 0
				var/mob/dead/observer/ghost = L.get_ghost(TRUE)
				if(GLOB.clockwork_vitality >= revival_cost && (ghost || (L.mind && L.mind.active)))
					if(L.has_status_effect(STATUS_EFFECT_ICHORIAL_STAIN))
						visible_message("<span class='boldwarning'>[src] strains, but nothing happens...</span>")
						if(L.pulledby)
							to_chat(L.pulledby, "<span class='userdanger'>[L] was already revived recently by a vitality matrix! Wait a bit longer!</span>")
						break
					else
						if(ghost)
							ghost.reenter_corpse()
						L.revive(1, 1)
						var/obj/effect/temp_visual/ratvar/sigil/vitality/V = new /obj/effect/temp_visual/ratvar/sigil/vitality(get_turf(src))
						animate(V, alpha = 0, transform = matrix()*2, time = 8)
						playsound(L, 'sound/magic/staff_healing.ogg', 50, 1)
						to_chat(L, "<span class='inathneq'>\"[text2ratvar("You will be okay, child.")]\"</span>")
						L.apply_status_effect(STATUS_EFFECT_ICHORIAL_STAIN)
						GLOB.clockwork_vitality -= revival_cost
				break
			if(!L.client || L.client.is_afk())
				set waitfor = FALSE
				var/list/mob/candidates = pollCandidatesForMob("Do you want to play as a [L.name], an inactive clock cultist?", ROLE_SERVANT_OF_RATVAR, null, ROLE_SERVANT_OF_RATVAR, 50, L)
				if(LAZYLEN(candidates))
					var/mob/C = pick(candidates)
					to_chat(L, "<span class='userdanger'>Your physical form has been taken over by another soul due to your inactivity! Ahelp if you wish to regain your form!</span>")
					message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(L)]) to replace an inactive clock cultist.")
					L.ghostize(0)
					C.transfer_ckey(L, FALSE)
					var/obj/effect/temp_visual/ratvar/sigil/vitality/V = new /obj/effect/temp_visual/ratvar/sigil/vitality(get_turf(src))
					animate(V, alpha = 0, transform = matrix()*2, time = 8)
					playsound(L, 'sound/magic/staff_healing.ogg', 50, 1)
					L.visible_message("<span class='warning'>[L]'s eyes suddenly open wide, gleaming with renewed vigor for the cause!</span>", "<span class='inathneq'>\"[text2ratvar("Awaken!")]\"</span>")
					break
			var/vitality_for_cycle = 3
			if(!GLOB.ratvar_awakens)
				if(L.stat == CONSCIOUS)
					vitality_for_cycle = 2
				vitality_for_cycle = min(GLOB.clockwork_vitality, vitality_for_cycle)
			var/vitality_used = L.heal_ordered_damage(vitality_for_cycle, damage_heal_order)

			if(!vitality_used)
				break

			if(!GLOB.ratvar_awakens)
				if(GLOB.clockwork_vitality <= 0)
					break
				GLOB.clockwork_vitality -= vitality_used

		sleep(2)

	if(sigil_active)
		animation_number = initial(animation_number)
		sigil_active = FALSE
	animate(src, alpha = initial(alpha), time = 10, flags = ANIMATION_END_NOW)

/obj/effect/clockwork/sigil/rite
	name = "radiant sigil"
	desc = "A glowing sigil glowing with barely-contained power."
	clockwork_desc = "A sigil that will allow you to perform certain rites on it, provided you have access to sufficient power and materials."
	icon_state = "sigiltransmission" //am big lazy - recolored transmission sigil
	sigil_name = "Sigil of Rites"
	alpha = 255
	var/performing_rite = FALSE
	color = "#ffe63a"
	light_color = "#ffe63a"
	light_range = 1
	light_power = 2

/obj/effect/clockwork/sigil/rite/on_attack_hand(mob/living/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(.)
		return
	if(!is_servant_of_ratvar(user))
		return
	if(!GLOB.all_clockwork_rites.len) //Did we already generate the list?
		generate_all_rites()
	if(performing_rite)
		to_chat(user, "<span class='warning'>Someone is already performing a rite here!")
		return
	var/list/possible_rites = list()
	for(var/datum/clockwork_rite/R in GLOB.all_clockwork_rites)
		possible_rites[R] = R
	var/input_key = input(user, "Choose a rite", "Choosing a rite") as null|anything in possible_rites
	if(!input_key)
		return
	var/datum/clockwork_rite/CR = possible_rites[input_key]
	if(!CR)
		return
	var/choice = alert(user, "What to do with this rite?", "What to do?", "Cast", "Show Info", "Cancel")
	switch(choice)
		if("Cast")
			CR.try_cast(src, user)
		if("Show Info")
			var/infotext = CR.build_info()
			to_chat(user, infotext)

/obj/effect/clockwork/sigil/rite/proc/generate_all_rites() //The first time someone uses a sigil of rites, all the rites are actually generated. No need to have a bunch of random datums laying around all the time.
	for(var/V in subtypesof(/datum/clockwork_rite))
		var/datum/clockwork_rite/R = new V
		GLOB.all_clockwork_rites += R

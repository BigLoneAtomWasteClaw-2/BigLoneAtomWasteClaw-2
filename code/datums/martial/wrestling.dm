/mob/living/carbon/human/proc/wrestling_help()
	set name = "Recall Teachings"
	set desc = "Remember how to wrestle."
	set category = "Wrestling"

	to_chat(usr, "<b><i>You flex your muscles and have a revelation...</i></b>")
	to_chat(usr, "<span class='notice'>Clinch</span>: Grab. Passively gives you a chance to immediately aggressively grab someone. Not always successful.")
	to_chat(usr, "<span class='notice'>Suplex</span>: Disarm someone you are grabbing. Suplexes your target to the floor. Greatly injures them and leaves both you and your target on the floor.")
	to_chat(usr, "<span class='notice'>Advanced grab</span>: Grab. Passively causes stamina damage when grabbing someone.")

/datum/martial_art/wrestling
	name = "Wrestling"
	id = MARTIALART_WRESTLING
	var/datum/action/slam/slam = new/datum/action/slam()
	var/datum/action/throw_wrassle/throw_wrassle = new/datum/action/throw_wrassle()
	var/datum/action/kick/kick = new/datum/action/kick()
	var/datum/action/strike/strike = new/datum/action/strike()
	var/datum/action/drop/drop = new/datum/action/drop()

/datum/martial_art/wrestling/proc/check_streak(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!can_use(A, D))
		return FALSE
	switch(streak)
		if("drop")
			streak = ""
			drop(A,D)
			return TRUE
		if("strike")
			streak = ""
			strike(A,D)
			return TRUE
		if("kick")
			streak = ""
			kick(A,D)
			return TRUE
		if("throw")
			streak = ""
			throw_wrassle(A,D)
			return TRUE
		if("slam")
			streak = ""
			slam(A,D)
			return TRUE
	return FALSE

/datum/action/slam
	name = "Slam (Cinch) - Slam a grappled opponent into the floor."
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "blink"

/datum/action/slam/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't WRESTLE while you're OUT FOR THE COUNT.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "slam")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		if(HAS_TRAIT(H, TRAIT_PACIFISM))
			to_chat(H, "<span class='warning'>You are too HIPPIE to WRESTLE other living beings!</span>")
			return
		owner.visible_message("<span class='danger'>[owner] prepares to BODY SLAM!</span>", "<b><i>Your next attack will be a BODY SLAM.</i></b>")
		H.mind.martial_art.streak = "slam"

/datum/action/throw_wrassle
	name = "Throw (Cinch) - Spin a cinched opponent around and throw them."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sidekick"

/datum/action/throw_wrassle/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't WRESTLE while you're OUT FOR THE COUNT.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "throw")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		if(HAS_TRAIT(H, TRAIT_PACIFISM))
			to_chat(H, "<span class='warning'>You are too HIPPIE to WRESTLE other living beings!</span>")
			return
	owner.visible_message("<span class='danger'>[owner] prepares to THROW!</span>", "<b><i>Your next attack will be a THROW.</i></b>")
	H.mind.martial_art.streak = "throw"

/datum/action/kick
	name = "Kick - A powerful kick, sends people flying away from you. Also useful for escaping from bad situations."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "legsweep"

/datum/action/kick/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't WRESTLE while you're OUT FOR THE COUNT.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "kick")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		if(HAS_TRAIT(H, TRAIT_PACIFISM))
			to_chat(H, "<span class='warning'>You are too HIPPIE to WRESTLE other living beings!</span>")
			return
	owner.visible_message("<span class='danger'>[owner] prepares to KICK!</span>", "<b><i>Your next attack will be a KICK.</i></b>")
	H.mind.martial_art.streak = "kick"

/datum/action/strike
	name = "Strike - Hit a neaby opponent with a quick attack."
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "nuclearfist"

/datum/action/strike/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't WRESTLE while you're OUT FOR THE COUNT.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "strike")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		if(HAS_TRAIT(H, TRAIT_PACIFISM))
			to_chat(H, "<span class='warning'>You are too HIPPIE to WRESTLE other living beings!</span>")
			return
	owner.visible_message("<span class='danger'>[owner] prepares to STRIKE!</span>", "<b><i>Your next attack will be a STRIKE.</i></b>")
	H.mind.martial_art.streak = "strike"

/datum/action/drop
	name = "Drop - Smash down onto an opponent."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "jetboot"

/datum/action/drop/Trigger()
	if(owner.incapacitated())
		to_chat(owner, "<span class='warning'>You can't WRESTLE while you're OUT FOR THE COUNT.</span>")
		return
	var/mob/living/carbon/human/H = owner
	if (H.mind.martial_art.streak == "drop")
		owner.visible_message("<span class='danger'>[owner] assumes a neutral stance.</span>", "<b><i>Your next attack is cleared.</i></b>")
		H.mind.martial_art.streak = ""
	else
		if(HAS_TRAIT(H, TRAIT_PACIFISM))
			to_chat(H, "<span class='warning'>You are too HIPPIE to WRESTLE other living beings!</span>")
			return
	owner.visible_message("<span class='danger'>[owner] prepares to LEG DROP!</span>", "<b><i>Your next attack will be a LEG DROP.</i></b>")
	H.mind.martial_art.streak = "drop"

/datum/martial_art/wrestling/teach(mob/living/carbon/human/H,make_temporary=0)
	if(..())
		to_chat(H, "<span class = 'userdanger'>SNAP INTO A SLIM JIM!</span>")
		to_chat(H, "<span class = 'danger'>Place your cursor over a move at the top of the screen to see what it does.</span>")
		drop.Grant(H)
		kick.Grant(H)
		slam.Grant(H)
		throw_wrassle.Grant(H)
		strike.Grant(H)
		ADD_TRAIT(H, TRAIT_NOGUNS, WRESTLING_TRAIT)

/datum/martial_art/wrestling/on_remove(mob/living/carbon/human/H)
	to_chat(H, "<span class = 'userdanger'>You no longer feel that the tower of power is too sweet to be sour...</span>")
	drop.Remove(H)
	kick.Remove(H)
	slam.Remove(H)
	throw_wrassle.Remove(H)
	strike.Remove(H)

/datum/martial_art/wrestling/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "punched with wrestling")
	..()

/datum/martial_art/wrestling/proc/throw_wrassle(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	if(!A.pulling || A.pulling != D)
		to_chat(A, "You need to have [D] in a cinch!")
		return
	D.forceMove(A.loc)
	D.setDir(get_dir(D, A))

	D.Stun(80)
	A.visible_message("<span class = 'danger'><B>[A] starts spinning around with [D]!</B></span>")
	A.emote("scream")

	for (var/i = 0, i < 20, i++)
		var/delay = 5
		switch (i)
			if (17 to INFINITY)
				delay = 0.25
			if (14 to 16)
				delay = 0.5
			if (9 to 13)
				delay = 1
			if (5 to 8)
				delay = 2
			if (0 to 4)
				delay = 3

		if (A && D)

			if (get_dist(A, D) > 1)
				to_chat(A, "[D] is too far away!")
				return FALSE

			if (!isturf(A.loc) || !isturf(D.loc))
				to_chat(A, "You can't throw [D] from here!")
				return FALSE

			A.setDir(turn(A.dir, 90))
			var/turf/T = get_step(A, A.dir)
			var/turf/S = D.loc
			if ((S && isturf(S) && S.Exit(D)) && (T && isturf(T) && T.Enter(A)))
				D.forceMove(T)
				D.setDir(get_dir(D, A))
		else
			return FALSE

		sleep(delay)

	if (A && D)
		// These are necessary because of the sleep call.

		if (get_dist(A, D) > 1)
			to_chat(A, "[D] is too far away!")
			return FALSE

		if (!isturf(A.loc) || !isturf(D.loc))
			to_chat(A, "You can't throw [D] from here!")
			return FALSE

		D.forceMove(A.loc) // Maybe this will help with the wallthrowing bug.

		A.visible_message("<span class = 'danger'><B>[A] throws [D]!</B></span>")
		playsound(A.loc, "swing_hit", 50, 1)
		var/turf/T = get_edge_target_turf(A, A.dir)
		if (T && isturf(T))
			if (!D.stat)
				D.emote("scream")
			D.throw_at(T, 10, 4, A, TRUE, TRUE, callback = CALLBACK(D, TYPE_PROC_REF(/mob/living/carbon/human,DefaultCombatKnockdown), 20))
	log_combat(A, D, "has thrown with wrestling")
	return FALSE

/datum/martial_art/wrestling/proc/FlipAnimation(mob/living/carbon/human/D)
	set waitfor = FALSE
	var/transform_before
	var/laying_before
	if (D)
		transform_before = D.transform
		laying_before = D.lying
		animate(D, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	sleep(15)
	if (D)
		if(transform_before && laying_before == D.lying) //animate calls sleep so this should be fine and stop a bug with transforms
			D.transform = transform_before
			animate(D, transform = null, time = 1, loop = 0)

/datum/martial_art/wrestling/proc/slam(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	if(!A.pulling || A.pulling != D)
		to_chat(A, "You need to have [D] in a cinch!")
		return
	var/damage = damage_roll(A,D)
	D.forceMove(A.loc)
	A.setDir(get_dir(A, D))
	D.setDir(get_dir(D, A))

	A.visible_message("<span class = 'danger'><B>[A] lifts [D] up!</B></span>")

	FlipAnimation()

	for (var/i = 0, i < 3, i++)
		if (A && D)
			A.pixel_y += 3
			D.pixel_y += 3
			A.setDir(turn(A.dir, 90))
			D.setDir(turn(D.dir, 90))

			switch (A.dir)
				if (NORTH)
					D.pixel_x = A.pixel_x
				if (SOUTH)
					D.pixel_x = A.pixel_x
				if (EAST)
					D.pixel_x = A.pixel_x - 8
				if (WEST)
					D.pixel_x = A.pixel_x + 8

			if (get_dist(A, D) > 1)
				to_chat(A, "[D] is too far away!")
				A.pixel_x = 0
				A.pixel_y = 0
				D.pixel_x = 0
				D.pixel_y = 0
				return FALSE

			if (!isturf(A.loc) || !isturf(D.loc))
				to_chat(A, "You can't slam [D] here!")
				A.pixel_x = 0
				A.pixel_y = 0
				D.pixel_x = 0
				D.pixel_y = 0
				return FALSE
		else
			if (A)
				A.pixel_x = 0
				A.pixel_y = 0
			if (D)
				D.pixel_x = 0
				D.pixel_y = 0
			return FALSE

		sleep(1)

	if (A && D)
		A.pixel_x = 0
		A.pixel_y = 0
		D.pixel_x = 0
		D.pixel_y = 0

		if (get_dist(A, D) > 1)
			to_chat(A, "[D] is too far away!")
			return FALSE

		if (!isturf(A.loc) || !isturf(D.loc))
			to_chat(A, "You can't slam [D] here!")
			return FALSE

		D.forceMove(A.loc)

		var/fluff = "body-slam"
		switch(pick(2,3))
			if (2)
				fluff = "turbo [fluff]"
			if (3)
				fluff = "atomic [fluff]"

		A.visible_message("<span class = 'danger'><B>[A] [fluff] [D]!</B></span>")
		playsound(A.loc, "swing_hit", 50, 1)
		if (!D.stat)
			D.emote("scream")
			D.DefaultCombatKnockdown(40)

			switch(rand(1,3))
				if (2)
					D.apply_damage(damage + 25, BRUTE)
				if (3)
					D.ex_act(EXPLODE_LIGHT)
				else
					D.apply_damage(damage + 15, BRUTE)
		else
			D.ex_act(EXPLODE_LIGHT)

	else
		if (A)
			A.pixel_x = 0
			A.pixel_y = 0
		if (D)
			D.pixel_x = 0
			D.pixel_y = 0


	log_combat(A, D, "body-slammed")
	return FALSE

/datum/martial_art/wrestling/proc/CheckStrikeTurf(mob/living/carbon/human/A, turf/T)
	if (A && (T && isturf(T) && get_dist(A, T) <= 1))
		A.forceMove(T)

/datum/martial_art/wrestling/proc/strike(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	var/turf/T = get_turf(A)
	var/damage = damage_roll(A,D)
	if (T && isturf(T) && D && isturf(D.loc))
		for (var/i = 0, i < 4, i++)
			A.setDir(turn(A.dir, 90))

		A.forceMove(D.loc)
		addtimer(CALLBACK(src, PROC_REF(CheckStrikeTurf), A, T), 4)

		A.visible_message("<span class = 'danger'><b>[A] headbutts [D]!</b></span>")
		D.apply_damage(damage + 15, BRUTE)
		playsound(A.loc, "swing_hit", 50, 1)
		D.Unconscious(20)
		A.Unconscious(20)
	log_combat(A, D, "headbutted")

/datum/martial_art/wrestling/proc/kick(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	var/damage = damage_roll(A,D)
	A.emote("scream")
	A.setDir(turn(A.dir, 90))

	A.visible_message("<span class = 'danger'><B>[A] roundhouse-kicks [D]!</B></span>")
	playsound(A.loc, "swing_hit", 50, 1)
	D.apply_damage(damage + 15, STAMINA)

	var/turf/T = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
	if (T && isturf(T))
		D.DefaultCombatKnockdown(20)
		D.throw_at(T, 3, 2)
	log_combat(A, D, "roundhouse-kicked")

/datum/martial_art/wrestling/proc/drop(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!D)
		return
	var/obj/surface = null
	var/turf/ST = null
	var/falling = 0
	var/damage = damage_roll(A,D)

	for (var/obj/O in oview(1, A))
		if (O.density == 1)
			if (O == A)
				continue
			if (O == D)
				continue
			if (O.opacity)
				continue
			else
				surface = O
				ST = get_turf(O)
				break

	if (surface && (ST && isturf(ST)))
		A.forceMove(ST)
		A.visible_message("<span class = 'danger'><B>[A] climbs onto [surface]!</b></span>")
		A.pixel_y = 10
		falling = 1
		sleep(10)

	if (A && D)
		// These are necessary because of the sleep call.

		if ((falling == 0 && get_dist(A, D) > 1) || (falling == 1 && get_dist(A, D) > 2)) // We climbed onto stuff.
			A.pixel_y = 0
			if (falling == 1)
				A.visible_message("<span class = 'danger'><B>...and dives head-first into the ground, ouch!</b></span>")
				A.apply_damage(damage + 15, BRUTE)
				A.DefaultCombatKnockdown(60)
			to_chat(A, "[D] is too far away!")
			return FALSE

		if (!isturf(A.loc) || !isturf(D.loc))
			A.pixel_y = 0
			to_chat(A, "You can't drop onto [D] from here!")
			return FALSE

		var/transform_before
		var/laying_before
		if(A)
			transform_before = A.transform
			laying_before = A.lying
			animate(A, transform = matrix(90, MATRIX_ROTATE), time = 1, loop = 0)
		sleep(10)
		if(A)
			if(transform_before && laying_before == A.lying) //if they suddenly dropped to the floor between this period, don't revert their animation
				animate(A, transform = null, time = 1, loop = 0)
				A.transform = transform_before

		A.forceMove(D.loc)

		A.visible_message("<span class = 'danger'><B>[A] leg-drops [D]!</B></span>")
		playsound(A.loc, "swing_hit", 50, 1)
		A.emote("scream")

		if (falling == 1)
			if (prob(33) || D.stat)
				D.ex_act(EXPLODE_LIGHT)
			else
				D.apply_damage(damage + 25, BRUTE)
		else
			D.apply_damage(damage + 25, BRUTE)

		D.DefaultCombatKnockdown(40)

		A.pixel_y = 0

	else
		if (A)
			A.pixel_y = 0
	log_combat(A, D, "leg-dropped")
	return

/datum/martial_art/wrestling/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	damage_roll(A,D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "wrestling-disarmed")
	..()

/datum/martial_art/wrestling/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	damage_roll(A,D)
	if(check_streak(A,D))
		return TRUE
	if(!can_use(A,D))
		return ..()
	if(A.pulling == D || A == D) // don't stun grab yoursel
		return FALSE
	A.start_pulling(D)
	D.visible_message("<span class='danger'>[A] gets [D] in a cinch!</span>", \
								"<span class='userdanger'>[A] gets [D] in a cinch!</span>")
	D.Stun(rand(60,100))
	log_combat(A, D, "cinched")
	return TRUE

/obj/item/storage/belt/champion/wrestling
	name = "Wrestling Belt"
	var/datum/martial_art/wrestling/style = new

/obj/item/storage/belt/champion/wrestling/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && slot == SLOT_BELT)
		var/mob/living/carbon/human/H = user
		style.teach(H,1)

/obj/item/storage/belt/champion/wrestling/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.get_item_by_slot(SLOT_BELT) == src)
		style.remove(H)
/*
//Subtype of wrestling, reserved for the wrestling belts found in the holodeck
/datum/martial_art/wrestling/holodeck
	name = "Holodeck Wrestling"

/obj/item/storage/belt/champion/wrestling/holodeck
	name = "Holodeck Wrestling Belt"
	style = new /datum/martial_art/wrestling/holodeck

//Make sure that moves can only be used on people wearing the holodeck belt
/datum/martial_art/wrestling/holodeck/can_use(mob/living/carbon/human/A, mob/living/carbon/human/D)
	if(!(istype(D.mind?.martial_art, /datum/martial_art/wrestling/holodeck)))
		return FALSE
	else
		return ..()
*/

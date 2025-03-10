/obj/item/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	item_flags = NOBLUDGEON
	reagent_flags = OPENCONTAINER
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	var/stream_mode = 0 //whether we use the more focused mode
	var/current_range = 3 //the range of tiles the sprayer will reach.
	var/spray_range = 3 //the range of tiles the sprayer will reach when in spray mode.
	var/stream_range = 1 //the range of tiles the sprayer will reach when in stream mode.
	var/stream_amount = 10 //the amount of reagents transfered when in stream mode.
	var/spray_delay = 3 //The amount of sleep() delay between each chempuff step.
	/// Last world.time of spray
	var/last_spray = 0
	/// Spray cooldown
	var/spray_cooldown = CLICK_CD_MELEE
	var/can_fill_from_container = TRUE
	amount_per_transfer_from_this = 5
	volume = 250
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	container_flags = NONE //APTFT is alternated between the initial value and stream_amount and shouldn't be exploited.

/obj/item/reagent_containers/spray/afterattack(atom/A, mob/user)
	. = ..()
	if(istype(A, /obj/structure/sink) || istype(A, /obj/structure/janitorialcart) || istype(A, /obj/machinery/hydroponics))
		return

	if((A.is_drainable() && !A.is_refillable()) && get_dist(src,A) <= 1 && can_fill_from_container)
		if(!A.reagents.total_volume)
			to_chat(user, "<span class='warning'>[A] is empty.</span>")
			return

		if(reagents.holder_full())
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return

		var/trans = A.reagents.trans_to(src, 50) //transfer 50u , using the spray's transfer amount would take too long to refill
		to_chat(user, "<span class='notice'>You fill \the [src] with [trans] units of the contents of \the [A].</span>")
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, "<span class='warning'>[src] is empty!</span>")
		return

	if(!spray(A))
		return

	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
	user.last_action = world.time
	user.newtonian_move(get_dir(A, user))
	var/turf/T = get_turf(src)
	if(reagents.has_reagent(/datum/reagent/toxin/acid))
		log_game("[key_name(user)] fired sulphuric acid from \a [src] at [AREACOORD(T)].")
	if(reagents.has_reagent(/datum/reagent/toxin/acid/fluacid))
		log_game("[key_name(user)] fired Fluacid from \a [src] at [AREACOORD(T)].")
	if(reagents.has_reagent(/datum/reagent/lube))
		message_admins("[ADMIN_LOOKUPFLW(user)] fired Space lube from \a [src] at [ADMIN_VERBOSEJMP(T)].")
		log_game("[key_name(user)] fired Space lube from \a [src] at [AREACOORD(T)].")
	if(reagents.has_reagent(/datum/reagent/toxin/acid/fantiacid))
		message_admins("[ADMIN_LOOKUPFLW(user)] fired fluoroantimonic acid from \a [src] at [ADMIN_VERBOSEJMP(T)].")
		log_game("[key_name(user)] fired fluoroantimonic acid from \a [src] at [AREACOORD(T)].")
/obj/item/reagent_containers/spray/proc/spray(atom/A)
	if((last_spray + spray_cooldown) > world.time)
		return
	var/range = clamp(get_dist(src, A), 1, current_range)
	var/obj/effect/decal/chempuff/D = new /obj/effect/decal/chempuff(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this, NONE, NO_REAGENTS_VALUE)
	var/puff_reagent_left = range //how many turf, mob or dense objet we can react with before we consider the chem puff consumed
	if(stream_mode)
		reagents.trans_to(D, amount_per_transfer_from_this)
		puff_reagent_left = 1
	else
		reagents.trans_to(D, amount_per_transfer_from_this, 1/range)
	D.color = mix_color_from_reagents(D.reagents.reagent_list)
	var/turf/T = get_turf(src)
	if(!T)
		return
	log_reagent("SPRAY: [key_name(usr)] fired [src] ([REF(src)]) [COORD(T)] at [A] ([REF(A)]) [COORD(A)] (chempuff: [D.reagents.log_list()])")
	var/wait_step = max(round(2+ spray_delay * INVERSE(range)), 2)
	last_spray = world.time
	INVOKE_ASYNC(src, PROC_REF(do_spray), A, wait_step, D, range, puff_reagent_left)
	return TRUE

/obj/item/reagent_containers/spray/proc/do_spray(atom/A, wait_step, obj/effect/decal/chempuff/D, range, puff_reagent_left)
	var/range_left = range
	for(var/i=0, i<range, i++)
		range_left--
		step_towards(D,A)
		sleep(wait_step)

		for(var/atom/T in get_turf(D))
			if(T == D || T.invisibility) //we ignore the puff itself and stuff below the floor
				continue
			if(puff_reagent_left <= 0)
				break

			if(stream_mode)
				if(ismob(T))
					var/mob/M = T
					if(!M.lying || !range_left)
						D.reagents.reaction(M, VAPOR)
						puff_reagent_left -= 1
				else if(!range_left)
					D.reagents.reaction(T, VAPOR)
			else
				D.reagents.reaction(T, VAPOR)
				if(ismob(T))
					puff_reagent_left -= 1

		if(puff_reagent_left > 0 && (!stream_mode || !range_left))
			D.reagents.reaction(get_turf(D), VAPOR)
			puff_reagent_left -= 1

		if(puff_reagent_left <= 0) // we used all the puff so we delete it.
			qdel(D)
			return
	qdel(D)

/obj/item/reagent_containers/spray/attack_self(mob/user)
	stream_mode = !stream_mode
	if(stream_mode)
		amount_per_transfer_from_this = stream_amount
		current_range = stream_range
	else
		amount_per_transfer_from_this = initial(amount_per_transfer_from_this)
		current_range = spray_range
	to_chat(user, "<span class='notice'>You switch the nozzle setting to [stream_mode ? "\"stream\"":"\"spray\""]. You'll now use [amount_per_transfer_from_this] units per use.</span>")

/obj/item/reagent_containers/spray/attackby(obj/item/I, mob/user, params)
	var/hotness = I.get_temperature()
	if(hotness && reagents)
		reagents.expose_temperature(hotness)
		to_chat(user, "<span class='notice'>You heat [name] with [I]!</span>")
	return ..()

/obj/item/reagent_containers/spray/verb/empty()
	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return
	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc) && src.loc == usr)
		to_chat(usr, "<span class='notice'>You empty \the [src] onto the floor.</span>")
		reagents.reaction(usr.loc)
		src.reagents.clear_reagents()

//abraxo cleaner
/obj/item/reagent_containers/spray/cleaner
	name = "Abraxo cleaner"
	desc = "Abraxo-brand non-foaming cleaner!"
	volume = 100
	list_reagents = list(/datum/reagent/abraxo_cleaner = 100)
	amount_per_transfer_from_this = 2
	stream_amount = 5

/obj/item/reagent_containers/spray/cleaner/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the nozzle of \the [src] in [user.p_their()] mouth.  It looks like [user.p_theyre()] trying to commit suicide!</span>")
	if(do_mob(user,user,30))
		if(reagents.total_volume >= amount_per_transfer_from_this)//if not empty
			user.visible_message("<span class='suicide'>[user] pulls the trigger!</span>")
			src.spray(user)
			return BRUTELOSS
		else
			user.visible_message("<span class='suicide'>[user] pulls the trigger...but \the [src] is empty!</span>")
			return SHAME
	else
		user.visible_message("<span class='suicide'>[user] decided life was worth living.</span>")
		return

/obj/item/reagent_containers/spray/cleaner/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/crafting/abraxo))
		user.visible_message("[user] begins filling container of the [src].")
		volume = 100
		return
	return ..()

//Drying Agent
/obj/item/reagent_containers/spray/drying_agent
	name = "drying agent spray"
	desc = "A spray bottle for drying agent."
	icon_state = "cleaner_drying"
	volume = 100
	list_reagents = list(/datum/reagent/drying_agent = 100)
	amount_per_transfer_from_this = 2
	stream_amount = 5

//spray tan
/obj/item/reagent_containers/spray/spraytan
	name = "spray tan"
	volume = 50
	desc = "Gyaro brand spray tan. Do not spray near eyes or other orifices."
	list_reagents = list(/datum/reagent/spraytan = 50)


//pepperspray
/obj/item/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	volume = 40
	stream_range = 4
	spray_delay = 1
	amount_per_transfer_from_this = 5
	list_reagents = list(/datum/reagent/consumable/condensedcapsaicin = 40)

/obj/item/reagent_containers/spray/pepper/empty // for techfab printing
	list_reagents = null

/obj/item/reagent_containers/spray/pepper/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins huffing \the [src]! It looks like [user.p_theyre()] getting a dirty high!</span>")
	return OXYLOSS

// Fix pepperspraying yourself
/obj/item/reagent_containers/spray/pepper/afterattack(atom/A as mob|obj, mob/user)
	if (A.loc == user)
		return
	. = ..()

//water flower
/obj/item/reagent_containers/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	volume = 10
	list_reagents = list(/datum/reagent/water = 10)

/obj/item/reagent_containers/spray/waterflower/attack_self(mob/user) //Don't allow changing how much the flower sprays
	return

///Subtype used for the lavaland clown ruin.
/obj/item/reagent_containers/spray/waterflower/superlube
	name = "clown flower"
	desc = "A delightly devilish flower... you got a feeling where this is going."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "clownflower"
	volume = 30
	list_reagents = list(/datum/reagent/lube/superlube = 30)

/obj/item/reagent_containers/spray/waterflower/cyborg
	reagent_flags = NONE
	volume = 100
	list_reagents = list(/datum/reagent/water = 100)
	var/generate_amount = 5
	var/generate_type = /datum/reagent/water
	var/last_generate = 0
	var/generate_delay = 10	//deciseconds
	can_fill_from_container = FALSE

/obj/item/reagent_containers/spray/waterflower/cyborg/hacked
	name = "nova flower"
	desc = "This doesn't look safe at all..."
	list_reagents = list(/datum/reagent/clf3 = 3)
	volume = 3
	generate_type = /datum/reagent/clf3
	generate_amount = 1
	generate_delay = 40		//deciseconds

/obj/item/reagent_containers/spray/waterflower/cyborg/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/item/reagent_containers/spray/waterflower/cyborg/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/item/reagent_containers/spray/waterflower/cyborg/process()
	if(world.time < last_generate + generate_delay)
		return
	last_generate = world.time
	generate_reagents()

/obj/item/reagent_containers/spray/waterflower/cyborg/empty()
	to_chat(usr, "<span class='warning'>You can not empty this!</span>")
	return

/obj/item/reagent_containers/spray/waterflower/cyborg/proc/generate_reagents()
	reagents.add_reagent(generate_type, generate_amount)

//chemsprayer
/obj/item/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagents in a given area."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	throwforce = 0
	w_class = WEIGHT_CLASS_NORMAL
	stream_mode = 1
	current_range = 7
	spray_range = 4
	stream_range = 7
	amount_per_transfer_from_this = 10
	volume = 600

/obj/item/reagent_containers/spray/chemsprayer/afterattack(atom/A as mob|obj, mob/user)
	// Make it so the bioterror spray doesn't spray yourself when you click your inventory items
	if (A.loc == user)
		return
	. = ..()

/obj/item/reagent_containers/spray/chemsprayer/spray(atom/A)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)

	for(var/i=1, i<=3, i++) // intialize sprays
		if(reagents.total_volume < 1)
			return
		..(the_targets[i])

/obj/item/reagent_containers/spray/chemsprayer/bioterror
	list_reagents = list(/datum/reagent/toxin/sodium_thiopental = 100, /datum/reagent/toxin/coniine = 100, /datum/reagent/toxin/venom = 100, /datum/reagent/consumable/condensedcapsaicin = 100, /datum/reagent/toxin/initropidril = 100, /datum/reagent/toxin/polonium = 100)

// Plant-B-Gone
/obj/item/reagent_containers/spray/plantbgone // -- Skie
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	volume = 100
	list_reagents = list(/datum/reagent/toxin/plantbgone = 100)

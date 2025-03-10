/obj/item/gun/ballistic
	desc = "Now comes in flavors like GUN. Uses 10mm ammo, for some reason."
	name = "projectile gun"
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_NORMAL
	var/spawnwithmagazine = TRUE
	var/mag_type = /obj/item/ammo_box/magazine/m10mm_adv //Removes the need for max_ammo and caliber info
	var/init_mag_type = null
	var/obj/item/ammo_box/magazine/magazine
	var/casing_ejector = TRUE //whether the gun ejects the chambered casing
	var/magazine_wording = "magazine"
	var/en_bloc = 0

/obj/item/gun/ballistic/Initialize()
	. = ..()
	if(!spawnwithmagazine)
		update_icon()
		return
	if (!magazine)
		if(init_mag_type)
			magazine = new init_mag_type(src)
		else
			magazine = new mag_type(src)
	chamber_round()
	update_icon()

/obj/item/gun/ballistic/update_icon_state()
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][sawn_off ? "-sawn" : ""]"
	else
		icon_state = "[initial(icon_state)][sawn_off ? "-sawn" : ""]"

/obj/item/gun/ballistic/process_chamber(mob/living/user, empty_chamber = 1)
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(istype(AC)) //there's a chambered round
		if(casing_ejector)
			AC.forceMove(drop_location()) //Eject casing onto ground.
			AC.bounce_away(TRUE)
			chambered = null
		else if(empty_chamber)
			chambered = null
	chamber_round()


/obj/item/gun/ballistic/proc/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round()
		chambered.forceMove(src)

/obj/item/gun/ballistic/can_shoot()
	if(!magazine || !magazine.ammo_count(0))
		return 0
	return 1

/obj/item/gun/ballistic/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(src.magazine,/obj/item/ammo_box/magazine/internal))
		if(.)
			return
		var/num_loaded = magazine.attackby(A, user, params, 1)
		if(num_loaded)
			to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>")
			playsound(user, 'sound/weapons/shotguninsert.ogg', 60, 1)
			A.update_icon()
			update_icon()
			chamber_round(0)
	else if(istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			if(user.transferItemToLoc(AM, src))
				magazine = AM
				to_chat(user, "<span class='notice'>You load a new magazine into \the [src].</span>")
				if(magazine.ammo_count())
					playsound(src, "gun_insert_full_magazine", 70, 1)
					if(!chambered)
						chamber_round()
						addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, 'sound/weapons/gun_chamber_round.ogg', 100, 1), 3)
				else
					playsound(src, "gun_insert_empty_magazine", 70, 1)
				A.update_icon()
				update_icon()
				return 1
			else
				to_chat(user, "<span class='warning'>You cannot seem to get \the [src] out of your hands!</span>")
				return
		else if (magazine)
			to_chat(user, "<span class='notice'>There's already a magazine in \the [src].</span>")
	if(istype(A, /obj/item/suppressor))
		var/obj/item/suppressor/S = A
		if(!can_suppress)
			to_chat(user, "<span class='warning'>You can't seem to figure out how to fit [S] on [src]!</span>")
			return
		if(!user.is_holding(src))
			to_chat(user, "<span class='notice'>You need be holding [src] to fit [S] to it!</span>")
			return
		if(suppressed)
			to_chat(user, "<span class='warning'>[src] already has a suppressor!</span>")
			return
		if(user.transferItemToLoc(A, src))
			to_chat(user, "<span class='notice'>You screw [S] onto [src].</span>")
			install_suppressor(A)
			update_overlays()
			return
	return 0

/obj/item/gun/ballistic/proc/install_suppressor(obj/item/suppressor/S)
	// this proc assumes that the suppressor is already inside src
	suppressed = S
	S.oldsound = fire_sound
	fire_sound = 'sound/weapons/gunshot_silenced.ogg'
	update_icon()

/obj/item/gun/ballistic/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(loc == user)
		if(suppressed && can_unsuppress)
			var/obj/item/suppressor/S = suppressed
			if(!user.is_holding(src))
				return ..()
			to_chat(user, "<span class='notice'>You unscrew [suppressed] from [src].</span>")
			user.put_in_hands(suppressed)
			fire_sound = S.oldsound
			suppressed = null
			update_icon()
			return
	return ..()

/obj/item/gun/ballistic/attack_self(mob/living/user)
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(magazine)
		if(en_bloc)
			magazine.forceMove(drop_location())
			user.dropItemToGround(magazine)
			magazine.update_icon()
			playsound(src, "sound/f13weapons/garand_ping.ogg", 70, 1)
			magazine = null
			to_chat(user, "<span class='notice'>You eject the enbloc clip out of \the [src].</span>")
		else
			magazine.forceMove(drop_location())
			user.put_in_hands(magazine)
			magazine.update_icon()
			if(magazine.ammo_count())
				playsound(src, 'sound/weapons/gun_magazine_remove_full.ogg', 70, 1)
			else
				playsound(src, "gun_remove_empty_magazine", 70, 1)
			magazine = null
			to_chat(user, "<span class='notice'>You pull the magazine out of \the [src].</span>")
	else if(chambered)
		AC.forceMove(drop_location())
		AC.bounce_away()
		chambered = null
		to_chat(user, "<span class='notice'>You unload the round from \the [src]'s chamber.</span>")
		playsound(src, "gun_slide_lock", 70, 1)
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	update_icon()
	return


/obj/item/gun/ballistic/examine(mob/user)
	. = ..()
	. += "It has [get_ammo()] round\s remaining."

/obj/item/gun/ballistic/proc/get_ammo(countchambered = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets

#define BRAINS_BLOWN_THROW_RANGE 3
#define BRAINS_BLOWN_THROW_SPEED 1
/obj/item/gun/ballistic/suicide_act(mob/living/user)
	var/obj/item/organ/brain/B = user.getorganslot(ORGAN_SLOT_BRAIN)
	if (B && chambered && chambered.BB && can_trigger_gun(user) && !chambered.BB.nodamage)
		user.visible_message("<span class='suicide'>[user] is putting the barrel of [src] in [user.p_their()] mouth.  It looks like [user.p_theyre()] trying to commit suicide!</span>")
		sleep(25)
		if(user.is_holding(src))
			var/turf/T = get_turf(user)
			process_fire(user, user, FALSE, null, BODY_ZONE_HEAD)
			user.visible_message("<span class='suicide'>[user] blows [user.p_their()] brain[user.p_s()] out with [src]!</span>")
			playsound(src, 'sound/weapons/dink.ogg', 30, 1)
			var/turf/target = get_ranged_target_turf(user, turn(user.dir, 180), BRAINS_BLOWN_THROW_RANGE)
			B.Remove()
			B.forceMove(T)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				B.add_blood_DNA(C.dna, C.diseases)
			var/datum/callback/gibspawner = CALLBACK(user, TYPE_PROC_REF(/mob/living, spawn_gibs), FALSE, B)
			B.throw_at(target, BRAINS_BLOWN_THROW_RANGE, BRAINS_BLOWN_THROW_SPEED, callback=gibspawner)
			return(BRUTELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to blow [user.p_their()] brain[user.p_s()] out with [src]! It looks like [user.p_theyre()] trying to commit suicide!</b></span>")
		playsound(src, "gun_dry_fire", 30, 1)
		return (OXYLOSS)
#undef BRAINS_BLOWN_THROW_SPEED
#undef BRAINS_BLOWN_THROW_RANGE

/obj/item/gun/ballistic/proc/sawoff(mob/user)
	if(sawn_off)
		to_chat(user, "<span class='warning'>\The [src] is already shortened!</span>")
		return
	user.DelayNextAction(CLICK_CD_MELEE)
	user.visible_message("[user] begins to shorten \the [src].", "<span class='notice'>You begin to shorten \the [src]...</span>")

	//if there's any live ammo inside the gun, makes it go off
	if(blow_up(user))
		user.visible_message("<span class='danger'>\The [src] goes off!</span>", "<span class='danger'>\The [src] goes off in your face!</span>")
		return

	if(do_after(user, 30, target = src))
		if(sawn_off)
			return
		user.visible_message("[user] shortens \the [src]!", "<span class='notice'>You shorten \the [src].</span>")
		name = "sawn-off [src.name]"
		desc = sawn_desc
		w_class = WEIGHT_CLASS_NORMAL
		weapon_weight = WEAPON_MEDIUM // Nope. Not unless you want broken wrist.
		item_state = "gun"
		slot_flags &= ~ITEM_SLOT_BACK	//you can't sling it on your back
		slot_flags |= ITEM_SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
		recoil = 2
		spread = 10
		sawn_off = TRUE
		update_icon()
		return 1

// Sawing guns related proc
/obj/item/gun/ballistic/proc/blow_up(mob/user)
	. = 0
	for(var/obj/item/ammo_casing/AC in magazine.stored_ammo)
		if(AC.BB)
			process_fire(user, user, FALSE)
			. = 1


/obj/item/suppressor
	name = "suppressor"
	desc = "A syndicate small-arms suppressor for maximum espionage."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "suppressor"
	w_class = WEIGHT_CLASS_TINY
	var/oldsound = null


/obj/item/suppressor/specialoffer
	name = "cheap suppressor"
	desc = "A foreign knock-off suppressor, it feels flimsy, cheap, and brittle. Still fits some weapons."

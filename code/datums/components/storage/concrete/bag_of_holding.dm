/datum/component/storage/concrete/bluespace/bag_of_holding/handle_item_insertion(obj/item/W, prevent_warning = FALSE, mob/living/user)
	var/atom/A = parent
	if(A == W)		//don't put yourself into yourself.
		return
	var/list/obj/item/storage/backpack/holding/matching = typecache_filter_list(W.GetAllContents(), typecacheof(/obj/item/storage/backpack/holding))
	matching -= A
	if(istype(W, /obj/item/storage/backpack/holding) || matching.len)
		INVOKE_ASYNC(src, PROC_REF(do_disaster), W, user)
	. = ..()

/datum/component/storage/concrete/bluespace/bag_of_holding/proc/do_disaster(obj/item/W, mob/living/user)
	var/atom/A = parent
	var/safety = alert(user, "Doing this will have extremely dire consequences for the station and its crew. Be sure you know what you're doing.", "Put in [A.name]?", "Abort", "Proceed")
	if(safety != "Proceed" || QDELETED(A) || QDELETED(W) || QDELETED(user) || !user.canUseTopic(A, BE_CLOSE, iscarbon(user)))
		return
	var/turf/loccheck = get_turf(A)
	if(is_reebe(loccheck.z))
		user.visible_message(span_warning("An unseen force knocks [user] to the ground!"), span_big_brass("\"I think not!\""))
		user.DefaultCombatKnockdown(60)
		return
	if(istype(loccheck.loc, /area/fabric_of_reality))
		to_chat(user, span_danger("You can't do that here!"))
	to_chat(user, span_danger("The Bluespace interfaces of the two devices catastrophically malfunction!"))
	qdel(W)
	playsound(loccheck,'sound/effects/supermatter.ogg', 200, 1)
	user.gib(TRUE, TRUE, TRUE)
	for(var/turf/T in range(6,loccheck))
		if(istype(T, /turf/open/space/transit))
			continue
		for(var/mob/living/M in T)
			if(M.movement_type & FLYING)
				M.visible_message(span_danger("The bluespace collapse crushes the air towards it, pulling [M] towards the ground..."))
				M.DefaultCombatKnockdown(5, TRUE, TRUE)		//Overrides stun absorbs.
		T.TerraformTurf(/turf/open/chasm/magic, /turf/open/chasm/magic)
	for (var/obj/structure/ladder/unbreakable/binary/ladder in GLOB.ladders)
		ladder.ActivateAlmonds()
	message_admins("[ADMIN_LOOKUPFLW(user)] detonated a bag of holding at [ADMIN_VERBOSEJMP(loccheck)].")
	log_game("[key_name(user)] detonated a bag of holding at [loc_name(loccheck)].")
	qdel(A)
	return

/datum/component/storage/concrete/bluespace/bag_of_holding/can_be_inserted(obj/item/I, stop_messages = FALSE, mob/M)
	if(I.GetComponent(/datum/component/storage/concrete/bluespace/bag_of_holding))
		return TRUE
	return ..()

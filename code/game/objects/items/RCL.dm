/obj/item/rcl
	name = "rapid cable layer"
	desc = "A device used to rapidly deploy cables. It has screws on the side which can be removed to slide off the cables. Do not use without insulation!"
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcl"
	item_state = "rcl"
	var/obj/structure/cable/last
	var/obj/item/stack/cable_coil/loaded
	opacity = FALSE
	force = 5 //Plastic is soft
	throwforce = 5
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	var/max_amount = 90
	var/active = FALSE
	actions_types = list(/datum/action/item_action/rcl_col,/datum/action/item_action/rcl_gui)
	var/list/colors = list("red", "yellow", "green", "blue", "pink", "orange", "cyan", "white")
	var/current_color_index = 1
	var/ghetto = FALSE
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	var/datum/radial_menu/persistent/wiring_gui_menu
	var/mob/listeningTo

/obj/item/rcl/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, .proc/on_wield)
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, .proc/on_unwield)
	update_icon()

/obj/item/rcl/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/two_handed)

/// triggered on wield of two handed item
/obj/item/rcl/proc/on_wield(obj/item/source, mob/user)
	active = TRUE

/// triggered on unwield of two handed item
/obj/item/rcl/proc/on_unwield(obj/item/source, mob/user)
	active = FALSE

/obj/item/rcl/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W

		if(!loaded)
			if(!user.transferItemToLoc(W, src))
				to_chat(user, "<span class='warning'>[src] is stuck to your hand!</span>")
				return
			else
				loaded = W //W.loc is src at this point.
				loaded.max_amount = max_amount //We store a lot.
				return

		if(loaded.amount < max_amount)
			var/transfer_amount = min(max_amount - loaded.amount, C.amount)
			C.use(transfer_amount)
			loaded.amount += transfer_amount
		else
			return
		update_icon()
		to_chat(user, "<span class='notice'>You add the cables to [src]. It now contains [loaded.amount].</span>")
	else if(istype(W, /obj/item/screwdriver))
		if(!loaded)
			return
		if(ghetto && prob(10)) //Is it a ghetto RCL? If so, give it a 10% chance to fall apart
			to_chat(user, "<span class='warning'>You attempt to loosen the securing screws on the side, but it falls apart!</span>")
			while(loaded.amount > 30) //There are only two kinds of situations: "nodiff" (60,90), or "diff" (31-59, 61-89)
				var/diff = loaded.amount % 30
				if(diff)
					loaded.use(diff)
					new /obj/item/stack/cable_coil(get_turf(user), diff)
				else
					loaded.use(30)
					new /obj/item/stack/cable_coil(get_turf(user), 30)
			qdel(src)
			return

		to_chat(user, "<span class='notice'>You loosen the securing screws on the side, allowing you to lower the guiding edge and retrieve the wires.</span>")
		while(loaded.amount > 30) //There are only two kinds of situations: "nodiff" (60,90), or "diff" (31-59, 61-89)
			var/diff = loaded.amount % 30
			if(diff)
				loaded.use(diff)
				new /obj/item/stack/cable_coil(get_turf(user), diff)
			else
				loaded.use(30)
				new /obj/item/stack/cable_coil(get_turf(user), 30)
		loaded.max_amount = initial(loaded.max_amount)
		if(!user.put_in_hands(loaded))
			loaded.forceMove(get_turf(user))

		loaded = null
		update_icon()
	else
		..()

/obj/item/rcl/examine(mob/user)
	. = ..()
	if(loaded)
		. += "<span class='info'>It contains [loaded.amount]/[max_amount] cables.</span>"

/obj/item/rcl/Destroy()
	QDEL_NULL(loaded)
	last = null
	listeningTo = null
	QDEL_NULL(wiring_gui_menu)
	return ..()

/obj/item/rcl/update_icon_state()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
	if(!loaded || !loaded.amount)
		icon_state += "-empty"
		item_state += "-0"

/obj/item/rcl/update_overlays()
	. = ..()
	if(!loaded || !loaded.amount)
		return
	var/mutable_appearance/cable_overlay = mutable_appearance(icon, "[initial(icon_state)]-[CEILING(loaded.amount/(max_amount/3), 1)]")
	cable_overlay.color = GLOB.cable_colors[colors[current_color_index]]
	. += cable_overlay

/obj/item/rcl/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands || !(loaded?.amount))
		return
	var/mutable_appearance/cable_overlay = mutable_appearance(icon_file, "rcl-[CEILING(loaded.amount/(max_amount/3), 1)]")
	cable_overlay.color = GLOB.cable_colors[colors[current_color_index]]
	. += cable_overlay

/obj/item/rcl/proc/is_empty(mob/user, loud = 1)
	update_icon()
	if(!loaded || !loaded.amount)
		if(loud)
			to_chat(user, "<span class='notice'>The last of the cables unreel from [src].</span>")
		if(loaded)
			QDEL_NULL(loaded)
			loaded = null
		QDEL_NULL(wiring_gui_menu)
		return TRUE
	return FALSE

/obj/item/rcl/pickup(mob/user)
	..()
	getMobhook(user)



/obj/item/rcl/dropped(mob/wearer)
	..()
	UnregisterSignal(wearer, COMSIG_MOVABLE_MOVED)
	listeningTo = null
	last = null

/obj/item/rcl/attack_self(mob/user)
	..()
	if(!active)
		last = null
	else if(!last)
		for(var/obj/structure/cable/C in get_turf(user))
			if(C.d1 == FALSE || C.d2 == FALSE)
				last = C
				break

/obj/item/rcl/proc/getMobhook(mob/to_hook)
	if(listeningTo == to_hook)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(to_hook, COMSIG_MOVABLE_MOVED, PROC_REF(trigger))
	listeningTo = to_hook

/obj/item/rcl/proc/trigger(mob/user)
	if(active)
		layCable(user)
	if(wiring_gui_menu) //update the wire options as you move
		wiringGuiUpdate(user)


//previous contents of trigger(), lays cable each time the player moves
/obj/item/rcl/proc/layCable(mob/user)
	if(!isturf(user.loc))
		return
	if(is_empty(user, 0))
		to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		return

	if(prob(2) && ghetto) //Give ghetto RCLs a 2% chance to jam, requiring it to be reactviated manually.
		to_chat(user, "<span class='warning'>[src]'s wires jam!</span>")
		active = FALSE
		return
	else
		if(last)
			if(get_dist(last, user) == 1) //hacky, but it works
				var/turf/T = get_turf(user)
				if(T.intact || !T.can_have_cabling())
					last = null
					return
				if(get_dir(last, user) == last.d2)
					//Did we just walk backwards? Well, that's the one direction we CAN'T complete a stub.
					last = null
					return
				loaded.cable_join(last, user, FALSE)
				if(is_empty(user))
					return //If we've run out, display message and exit
			else
				last = null
		loaded.color	 = colors[current_color_index]
		last = loaded.place_turf(get_turf(src), user, turn(user.dir, 180))
		is_empty(user) //If we've run out, display message
	update_icon()

//searches the current tile for a stub cable of the same colour
/obj/item/rcl/proc/findLinkingCable(mob/user)
	var/turf/T
	if(!isturf(user.loc))
		return

	T = get_turf(user)
	if(T.intact || !T.can_have_cabling())
		return

	for(var/obj/structure/cable/C in T)
		if(!C)
			continue
		if(C.cable_color != GLOB.cable_colors[colors[current_color_index]])
			continue
		if(C.d1 == 0)
			return C

/obj/item/rcl/proc/wiringGuiGenerateChoices(mob/user)
	var/fromdir = 0
	var/obj/structure/cable/linkingCable = findLinkingCable(user)
	if(linkingCable)
		fromdir = linkingCable.d2

	var/list/wiredirs = list("1","5","4","6","2","10","8","9")
	for(var/icondir in wiredirs)
		var/dirnum = text2num(icondir)
		var/cablesuffix = "[min(fromdir,dirnum)]-[max(fromdir,dirnum)]"
		if(fromdir == dirnum) //cables can't loop back on themselves
			cablesuffix = "invalid"
		var/image/img = image(icon = 'icons/mob/radial.dmi', icon_state = "cable_[cablesuffix]")
		img.color = GLOB.cable_colors[colors[current_color_index]]
		wiredirs[icondir] = img
	return wiredirs

/obj/item/rcl/proc/showWiringGui(mob/user)
	var/list/choices = wiringGuiGenerateChoices(user)

	wiring_gui_menu = show_radial_menu_persistent(user, src , choices, select_proc = CALLBACK(src, PROC_REF(wiringGuiReact), user), radius = 42)

/obj/item/rcl/proc/wiringGuiUpdate(mob/user)
	if(!wiring_gui_menu)
		return

	wiring_gui_menu.entry_animation = FALSE //stop the open anim from playing each time we update
	var/list/choices = wiringGuiGenerateChoices(user)

	wiring_gui_menu.change_choices(choices,FALSE)


//Callback used to respond to interactions with the wiring menu
/obj/item/rcl/proc/wiringGuiReact(mob/living/user,choice)
	if(!choice) //close on a null choice (the center button)
		QDEL_NULL(wiring_gui_menu)
		return

	choice = text2num(choice)

	if(!isturf(user.loc))
		return
	if(is_empty(user, 0))
		to_chat(user, "<span class='warning'>\The [src] is empty!</span>")
		return

	var/turf/T = get_turf(user)
	if(T.intact || !T.can_have_cabling())
		return

	loaded.color	 = colors[current_color_index]

	var/obj/structure/cable/linkingCable = findLinkingCable(user)
	if(linkingCable)
		if(choice != linkingCable.d2)
			loaded.cable_join(linkingCable, user, FALSE, choice)
			last = null
	else
		last = loaded.place_turf(get_turf(src), user, choice)

	is_empty(user) //If we've run out, display message

	wiringGuiUpdate(user)

/obj/item/rcl/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/rcl_col))
		current_color_index++;
		if (current_color_index > colors.len)
			current_color_index = 1
		var/cwname = colors[current_color_index]
		to_chat(user, "Color changed to [cwname]!")
		if(loaded)
			loaded.color = colors[current_color_index]
			update_icon()
		if(wiring_gui_menu)
			wiringGuiUpdate(user)
	else if(istype(action, /datum/action/item_action/rcl_gui))
		if(wiring_gui_menu) //The menu is already open, close it
			QDEL_NULL(wiring_gui_menu)
		else //open the menu
			showWiringGui(user)

/obj/item/rcl/pre_loaded/Initialize() //Comes preloaded with cable, for testing stuff
	loaded = new()
	loaded.max_amount = max_amount
	loaded.amount = max_amount
	return ..()

/obj/item/rcl/ghetto
	actions_types = list()
	max_amount = 30
	name = "makeshift rapid cable layer"
	icon_state = "rclg"
	ghetto = TRUE

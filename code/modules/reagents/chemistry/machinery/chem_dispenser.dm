/proc/translate_legacy_chem_id(id)
	switch (id)
		if ("sacid")
			return "sulphuricacid"
		if ("facid")
			return "fluorosulfuricacid"
		if ("co2")
			return "carbondioxide"
		if ("mine_salve")
			return "minerssalve"
		else
			return ckey(id)

/obj/machinery/chem_dispenser
	name = "chem dispenser"
	desc = "Creates and dispenses chemicals."
	density = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	interaction_flags_machine = INTERACT_MACHINE_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OFFLINE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_dispenser
	var/obj/item/stock_parts/cell/cell
	var/powerefficiency = 0.0666666
	var/amount = 30
	var/recharge_amount = 10
	var/recharge_counter = 0
	var/mutable_appearance/beaker_overlay
	var/working_state = "dispenser_working"
	var/nopower_state = "dispenser_nopower"
	var/cell_type = /obj/item/stock_parts/cell/high
	var/has_panel_overlay = TRUE
	var/obj/item/reagent_containers/beaker = null
	var/list/dispensable_reagents = list(
		/datum/reagent/hydrogen,
		/datum/reagent/lithium,
		/datum/reagent/carbon,
		/datum/reagent/nitrogen,
		/datum/reagent/oxygen,
		/datum/reagent/fluorine,
		/datum/reagent/sodium,
		/datum/reagent/aluminium,
		/datum/reagent/silicon,
		/datum/reagent/phosphorus,
		/datum/reagent/sulfur,
		/datum/reagent/chlorine,
		/datum/reagent/potassium,
		/datum/reagent/iron,
		/datum/reagent/copper,
		/datum/reagent/mercury,
		/datum/reagent/radium,
		/datum/reagent/water,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/sugar,
		/datum/reagent/toxin/acid,
		/datum/reagent/fuel,
		/datum/reagent/silver,
		/datum/reagent/iodine,
		/datum/reagent/bromine,
		/datum/reagent/stable_plasma
	)
	//These become available once upgraded.
	var/list/upgrade_reagents = list(
		/datum/reagent/oil,
		/datum/reagent/ammonia,
		/datum/reagent/ash
	)

	var/list/upgrade_reagents2 = list(
		/datum/reagent/acetone,
		/datum/reagent/phenol,
		/datum/reagent/diethylamine
	)

	var/list/upgrade_reagents3 = list(
		/datum/reagent/medicine/mine_salve,
		/datum/reagent/toxin
	)

	var/list/emagged_reagents = list(
		/datum/reagent/drug/space_drugs,
		/datum/reagent/toxin/plasma,
		/datum/reagent/consumable/frostoil,
		/datum/reagent/toxin/carpotoxin,
		/datum/reagent/toxin/histamine,
		/datum/reagent/medicine/morphine
	)
	var/list/recording_recipe

	var/list/saved_recipes = list()

/obj/machinery/chem_dispenser/Initialize()
	. = ..()
	dispensable_reagents = sortList(dispensable_reagents, GLOBAL_PROC_REF(cmp_reagents_asc))
	if(emagged_reagents)
		emagged_reagents = sortList(emagged_reagents, GLOBAL_PROC_REF(cmp_reagents_asc))
	if(upgrade_reagents)
		upgrade_reagents = sortList(upgrade_reagents, GLOBAL_PROC_REF(cmp_reagents_asc))
	if(upgrade_reagents2)
		upgrade_reagents2 = sortList(upgrade_reagents2, GLOBAL_PROC_REF(cmp_reagents_asc))
	if(upgrade_reagents3)
		upgrade_reagents3 = sortList(upgrade_reagents3, GLOBAL_PROC_REF(cmp_reagents_asc))
	dispensable_reagents = sortList(dispensable_reagents, GLOBAL_PROC_REF(cmp_reagents_asc))
	update_icon()

/obj/machinery/chem_dispenser/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(cell)
	return ..()

/obj/machinery/chem_dispenser/examine(mob/user)
	. = ..()
	if(panel_open)
		. += "<span class='notice'>[src]'s maintenance hatch is open!</span>"
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads:\n\
		Recharging <b>[recharge_amount]</b> power units per interval.\n\
		Power efficiency increased by <b>[round((powerefficiency*1000)-100, 1)]%</b>.</span>"

/obj/machinery/chem_dispenser/process()
	if (recharge_counter >= 4)
		if(!is_operational())
			return
		var/usedpower = cell.give(recharge_amount)
		if(usedpower)
			use_power(250*recharge_amount)
		recharge_counter = 0
		return
	recharge_counter++

/obj/machinery/chem_dispenser/proc/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	b_o.pixel_y = -4
	b_o.pixel_x = -7
	return b_o

/obj/machinery/chem_dispenser/proc/work_animation()
	if(working_state)
		flick(working_state,src)

/obj/machinery/chem_dispenser/low_power
	cell_type = /obj/item/stock_parts/cell/upgraded

/obj/machinery/chem_dispenser/power_change()
	..()
	icon_state = "[(nopower_state && !powered()) ? nopower_state : initial(icon_state)]"

/obj/machinery/chem_dispenser/update_overlays()
	. = ..()
	if(has_panel_overlay && panel_open)
		. += mutable_appearance(icon, "[initial(icon_state)]_panel-o")

	if(beaker)
		beaker_overlay = display_beaker()
		. += beaker_overlay

/obj/machinery/chem_dispenser/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		to_chat(user, "<span class='warning'>[src] has no functional safeties to emag.</span>")
		return
	to_chat(user, "<span class='notice'>You short out [src]'s safeties.</span>")
	dispensable_reagents |= emagged_reagents//add the emagged reagents to the dispensable ones
	obj_flags |= EMAGGED
	return TRUE

/obj/machinery/chem_dispenser/ex_act(severity, target)
	if(severity < 3)
		..()

/obj/machinery/chem_dispenser/contents_explosion(severity, target)
	..()
	if(beaker)
		beaker.ex_act(severity, target)

/obj/machinery/chem_dispenser/Exited(atom/movable/A, atom/newloc)
	. = ..()
	if(A == beaker)
		beaker = null
		update_icon()

/obj/machinery/chem_dispenser/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(istype(user, /mob/dead/observer))
		if(!ui)
			ui = new(user, src, "ChemDispenser", name)
			ui.open()
	else
		if(!user.IsAdvancedToolUser() && !istype(src, /obj/machinery/chem_dispenser/drinks))
			to_chat(user, "<span class='warning'>The legion has no use for drugs! Better to destroy it.</span>")
			return
		if(!HAS_TRAIT(user, TRAIT_CHEMWHIZ) && !istype(src, /obj/machinery/chem_dispenser/drinks))
			to_chat(user, "<span class='warning'>Try as you might, you have no clue how to work this thing.</span>")
			return
		if(!ui)
			ui = new(user, src, "ChemDispenser", name)
			if(user.hallucinating())
				ui.set_autoupdate(FALSE) //to not ruin the immersion by constantly changing the fake chemicals
			ui.open()

/obj/machinery/chem_dispenser/ui_data(mob/user)
	var/data = list()
	data["amount"] = amount
	data["energy"] = cell.charge ? cell.charge * powerefficiency : "0" //To prevent NaN in the UI.
	data["maxEnergy"] = cell.maxcharge * powerefficiency
	data["isBeakerLoaded"] = beaker ? 1 : 0

	var/beakerContents[0]
	var/beakerCurrentVolume = 0
	if(beaker && beaker.reagents && beaker.reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker.volume
		data["beakerTransferAmounts"] = beaker.possible_transfer_amounts
		data["beakerCurrentpH"] = beaker.reagents.pH
		//pH accuracy
		for(var/obj/item/stock_parts/capacitor/C in component_parts)
			data["partRating"]= 10**(C.rating-1)

	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null
		data["beakerTransferAmounts"] = null
		data["beakerCurrentpH"] = null

	var/chemicals[0]
	var/is_hallucinating = FALSE
	if(user.hallucinating())
		is_hallucinating = TRUE
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOB.chemical_reagents_list[re]
		if(temp)
			var/chemname = temp.name
			if(is_hallucinating && prob(5))
				chemname = "[pick_list_replacements("hallucination.json", "chemicals")]"
			chemicals.Add(list(list("title" = chemname, "id" = ckey(temp.name))))
	data["chemicals"] = chemicals
	data["recipes"] = saved_recipes

	data["recordingRecipe"] = recording_recipe
	return data

/obj/machinery/chem_dispenser/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("amount")
			if(!is_operational() || QDELETED(beaker))
				return
			var/target = text2num(params["target"])
			if(target in beaker.possible_transfer_amounts)
				amount = target
				work_animation()
				. = TRUE
		if("dispense")
			if(!is_operational() || QDELETED(cell))
				return
			var/reagent_name = params["reagent"]
			if(!recording_recipe)
				var/reagent = GLOB.name2reagent[reagent_name]
				if(beaker && dispensable_reagents.Find(reagent))
					var/datum/reagents/R = beaker.reagents
					var/free = R.maximum_volume - R.total_volume
					var/actual = min(amount, (cell.charge * powerefficiency)*10, free)

					if(!cell.use(actual / powerefficiency))
						say("Not enough energy to complete operation!")
						return
					R.add_reagent(reagent, actual)
					log_reagent("DISPENSER: ([COORD(src)]) ([REF(src)]) [key_name(usr)] dispensed [actual] of [reagent] to [beaker] ([REF(beaker)]).")

					work_animation()
			else
				recording_recipe[reagent_name] += amount
			. = TRUE
		if("remove")
			if(!is_operational() || recording_recipe)
				return
			var/amount = text2num(params["amount"])
			if(beaker && (amount in beaker.possible_transfer_amounts))
				beaker.reagents.remove_all(amount)
				work_animation()
				. = TRUE
		if("eject")
			replace_beaker(usr)
			. = TRUE
		if("dispense_recipe")
			if(!is_operational() || QDELETED(cell))
				return
			var/list/chemicals_to_dispense = saved_recipes[params["recipe"]]
			if(!LAZYLEN(chemicals_to_dispense))
				return
			var/list/logstring = list()
			var/earlyabort = TRUE
			for(var/key in chemicals_to_dispense)
				var/reagent = GLOB.name2reagent[translate_legacy_chem_id(key)]
				var/dispense_amount = chemicals_to_dispense[key]
				logstring += "[reagent] = [dispense_amount]"
				if(!dispensable_reagents.Find(reagent))
					break
				if(!recording_recipe)
					if(!beaker)
						return
					var/datum/reagents/R = beaker.reagents
					var/free = R.maximum_volume - R.total_volume
					var/actual = min(dispense_amount, (cell.charge * powerefficiency)*10, free)
					if(actual)
						if(!cell.use(actual / powerefficiency))
							say("Not enough energy to complete operation!")
							earlyabort = TRUE
							break
						R.add_reagent(reagent, actual)
						work_animation()
				else
					recording_recipe[key] += dispense_amount
			logstring = logstring.Join(", ")
			if(!recording_recipe)
				log_reagent("DISPENSER: [key_name(usr)] dispensed recipe [params["recipe"]] with chemicals [logstring] to [beaker] ([REF(beaker)])[earlyabort? " (aborted early)":""]")
			. = TRUE
		if("clear_recipes")
			if(!is_operational())
				return
			var/yesno = alert("Clear all recipes?",, "Yes","No")
			if(yesno == "Yes")
				saved_recipes = list()
			. = TRUE
		if("record_recipe")
			if(!is_operational())
				return
			recording_recipe = list()
			. = TRUE
		if("save_recording")
			if(!is_operational())
				return
			var/name = stripped_input(usr,"Name","What do you want to name this recipe?", "Recipe", MAX_NAME_LEN)
			if(!usr.canUseTopic(src, !hasSiliconAccessInArea(usr)))
				return
			if(saved_recipes[name] && alert("\"[name]\" already exists, do you want to overwrite it?",, "Yes", "No") == "No")
				return
			if(name && recording_recipe)
				var/list/logstring = list()
				for(var/reagent in recording_recipe)
					var/reagent_id = GLOB.name2reagent[translate_legacy_chem_id(reagent)]
					logstring += "[reagent_id] = [recording_recipe[reagent]]"
					if(!dispensable_reagents.Find(reagent_id))
						visible_message("<span class='warning'>[src] buzzes.</span>", "<span class='hear'>You hear a faint buzz.</span>")
						to_chat(usr, "<span class ='danger'>[src] cannot find <b>[reagent]</b>!</span>")
						playsound(src, 'sound/machines/buzz-two.ogg', 50, TRUE)
						return
				saved_recipes[name] = recording_recipe
				logstring = logstring.Join(", ")
				recording_recipe = null
				log_reagent("DISPENSER: [key_name(usr)] recorded recipe [name] with chemicals [logstring]")
				. = TRUE
		if("cancel_recording")
			if(!is_operational())
				return
			recording_recipe = null
			. = TRUE

/obj/machinery/chem_dispenser/attackby(obj/item/I, mob/user, params)
	if(default_unfasten_wrench(user, I))
		return
	if(default_deconstruction_screwdriver(user, icon_state, icon_state, I))
		update_icon()
		return
	if(default_deconstruction_crowbar(I))
		return
	if(istype(I, /obj/item/reagent_containers) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		var/obj/item/reagent_containers/B = I
		. = TRUE //no afterattack
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, "<span class='notice'>You add [B] to [src].</span>")
		updateUsrDialog()
	else if(user.a_intent != INTENT_HARM && !istype(I, /obj/item/card/emag))
		to_chat(user, "<span class='warning'>You can't load [I] into [src]!</span>")
		return ..()
	else
		return ..()

/obj/machinery/chem_dispenser/get_cell()
	return cell

/obj/machinery/chem_dispenser/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/list/datum/reagents/R = list()
	var/total = min(rand(7,15), FLOOR(cell.charge*powerefficiency, 1))
	var/datum/reagents/Q = new(total*10)
	if(beaker && beaker.reagents)
		R += beaker.reagents
	for(var/i in 1 to total)
		Q.add_reagent(pick(dispensable_reagents), 10)
	R += Q
	chem_splash(get_turf(src), 3, R)
	if(beaker && beaker.reagents)
		beaker.reagents.remove_all()
	cell.use(total/powerefficiency)
	cell.emp_act(severity)
	work_animation()
	visible_message("<span class='danger'>[src] malfunctions, spraying chemicals everywhere!</span>")

/obj/machinery/chem_dispenser/RefreshParts()
	recharge_amount = initial(recharge_amount)
	var/newpowereff = initial(powerefficiency)
	for(var/obj/item/stock_parts/cell/P in component_parts)
		cell = P
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		newpowereff += 0.0166666666*M.rating
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		recharge_amount *= C.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		if(M.rating > 1)
			dispensable_reagents |= upgrade_reagents
		if(M.rating > 2)
			dispensable_reagents |= upgrade_reagents2
		if(M.rating > 3)
			dispensable_reagents |= upgrade_reagents3
	powerefficiency = round(newpowereff, 0.01)

/obj/machinery/chem_dispenser/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		var/obj/item/reagent_containers/B = beaker
		B.forceMove(drop_location())
		if(user && Adjacent(user) && user.can_hold_items())
			user.put_in_hands(B)
	if(new_beaker)
		beaker = new_beaker
	else
		beaker = null
	update_icon()
	return TRUE

/obj/machinery/chem_dispenser/on_deconstruction()
	cell = null
	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null
	return ..()

/obj/machinery/chem_dispenser/AltClick(mob/living/user)
	. = ..()
	if(istype(user) && user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		replace_beaker(user)
		return TRUE

/obj/machinery/chem_dispenser/drinks/Initialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE)

/obj/machinery/chem_dispenser/drinks/setDir()
	var/old = dir
	. = ..()
	if(dir != old)
		update_icon()  // the beaker needs to be re-positioned if we rotate

/obj/machinery/chem_dispenser/drinks/display_beaker()
	var/mutable_appearance/b_o = beaker_overlay || mutable_appearance(icon, "disp_beaker")
	switch(dir)
		if(NORTH)
			b_o.pixel_y = 7
			b_o.pixel_x = rand(-9, 9)
		if(EAST)
			b_o.pixel_x = 4
			b_o.pixel_y = rand(-5, 7)
		if(WEST)
			b_o.pixel_x = -5
			b_o.pixel_y = rand(-5, 7)
		else//SOUTH
			b_o.pixel_y = -7
			b_o.pixel_x = rand(-9, 9)
	return b_o

/obj/machinery/chem_dispenser/drinks
	name = "soda dispenser"
	desc = "Contains a large reservoir of soft drinks."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "soda_dispenser"
	has_panel_overlay = FALSE
	amount = 10
	pixel_y = 6
	layer = WALL_OBJ_LAYER
	circuit = /obj/item/circuitboard/machine/chem_dispenser/drinks
	working_state = null
	nopower_state = null
	pass_flags = PASSTABLE
	dispensable_reagents = list(
		/datum/reagent/water,
		/datum/reagent/consumable/ice,
		/datum/reagent/consumable/coffee,
		/datum/reagent/consumable/cream,
		/datum/reagent/consumable/tea,
		/datum/reagent/consumable/icetea,
		/datum/reagent/consumable/space_cola,
		/datum/reagent/consumable/spacemountainwind,
		/datum/reagent/consumable/dr_gibb,
		/datum/reagent/consumable/space_up,
		/datum/reagent/consumable/tonic,
		/datum/reagent/consumable/sodawater,
		/datum/reagent/consumable/lemon_lime,
		/datum/reagent/consumable/pwr_game,
		/datum/reagent/consumable/shamblers,
		/datum/reagent/consumable/sugar,
		/datum/reagent/consumable/pineapplejuice,
		/datum/reagent/consumable/orangejuice,
		/datum/reagent/consumable/grenadine,
		/datum/reagent/consumable/limejuice,
		/datum/reagent/consumable/tomatojuice,
		/datum/reagent/consumable/lemonjuice,
		/datum/reagent/consumable/menthol,
		/datum/reagent/consumable/sunset,
		/datum/reagent/consumable/bawls,
		/datum/reagent/consumable/vim,
		/datum/reagent/consumable/nuka_cola,
		/datum/reagent/consumable/grapejuice,
		/datum/reagent/consumable/tea/forest,
		/datum/reagent/consumable/tea/red,
		/datum/reagent/consumable/tea/green,
		/datum/reagent/consumable/grey_bull,
		/datum/reagent/consumable/sol_dry,
		/datum/reagent/consumable/cream_soda
	)
	upgrade_reagents = list(
		/datum/reagent/consumable/banana,
		/datum/reagent/consumable/berryjuice,
		/datum/reagent/consumable/strawberryjuice,
		/datum/reagent/consumable/applejuice,
		/datum/reagent/consumable/carrotjuice,
		/datum/reagent/consumable/pumpkinjuice,
		/datum/reagent/consumable/watermelonjuice,
		/datum/reagent/consumable/parsnipjuice,
		/datum/reagent/consumable/bungojuice,
		/datum/reagent/consumable/aloejuice,
		/datum/reagent/consumable/peachjuice,
		/datum/reagent/consumable/blumpkinjuice
	)
	upgrade_reagents2 = list(
		/datum/reagent/consumable/vanilla,
		/datum/reagent/consumable/coco,
		/datum/reagent/consumable/lemonade,
		/datum/reagent/consumable/buzz_fuzz,
		/datum/reagent/consumable/menthol
	)
	upgrade_reagents3 = list(
		/datum/reagent/drug/mushroomhallucinogen,
		/datum/reagent/consumable/laughter,
		/datum/reagent/consumable/monkey_energy
	)
	emagged_reagents = list(
		/datum/reagent/medicine/cryoxadone,
		/datum/reagent/iron,
		/datum/reagent/consumable/superlaughter
	)

/obj/machinery/chem_dispenser/drinks/fullupgrade //fully ugpraded stock parts, emagged
	desc = "Contains a large reservoir of soft drinks. This model has had its safeties shorted out."
	obj_flags = CAN_BE_HIT | EMAGGED
	flags_1 = NODECONSTRUCT_1

/obj/machinery/chem_dispenser/drinks/fullupgrade/Initialize()
	. = ..()
	dispensable_reagents |= emagged_reagents //adds emagged reagents
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/chem_dispenser/drinks(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stock_parts/cell/bluespace(null)
	RefreshParts()

/obj/machinery/chem_dispenser/drinks/beer
	name = "booze dispenser"
	desc = "Contains a large reservoir of the good stuff."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "booze_dispenser"
	circuit = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	dispensable_reagents = list(
		/datum/reagent/consumable/ethanol/kahlua,
		/datum/reagent/consumable/ethanol/beer,
		/datum/reagent/consumable/ethanol/beer/light,
		/datum/reagent/consumable/ethanol/whiskey,
		/datum/reagent/consumable/ethanol/wine,
		/datum/reagent/consumable/ethanol/vodka,
		/datum/reagent/consumable/ethanol/gin,
		/datum/reagent/consumable/ethanol/rum,
		/datum/reagent/consumable/ethanol/tequila,
		/datum/reagent/consumable/ethanol/vermouth,
		/datum/reagent/consumable/ethanol/cognac,
		/datum/reagent/consumable/ethanol/ale,
		/datum/reagent/consumable/ethanol/absinthe,
		/datum/reagent/consumable/ethanol/hcider,
		/datum/reagent/consumable/ethanol/creme_de_menthe,
		/datum/reagent/consumable/ethanol/creme_de_cacao,
		/datum/reagent/consumable/ethanol/creme_de_coconut,
		/datum/reagent/consumable/ethanol/triple_sec,
		/datum/reagent/consumable/ethanol/sake,
		/datum/reagent/consumable/ethanol/applejack,
		/datum/reagent/consumable/ethanol/champagne,
		/datum/reagent/consumable/ethanol/fernet
	)
	upgrade_reagents = list(
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/ethanol/atomicbomb,
		/datum/reagent/consumable/ethanol/thirteenloko,
		/datum/reagent/consumable/ethanol/changelingsting,
		/datum/reagent/consumable/ethanol/alexander,
		/datum/reagent/consumable/ethanol/beer/green,
		/datum/reagent/consumable/ethanol/trappist
	)
	upgrade_reagents2 = list(
		/datum/reagent/consumable/ethanol/hooch,
		/datum/reagent/consumable/ethanol/mead
	)
	upgrade_reagents3 = list(
		/datum/reagent/medicine/antihol
	)
	emagged_reagents = list(
	/datum/reagent/consumable/ethanol/rotgut
	)

/obj/machinery/chem_dispenser/drinks/beer/fullupgrade //fully ugpraded stock parts, emagged
	desc = "Contains a large reservoir of the good stuff. This model has had its safeties shorted out."
	obj_flags = CAN_BE_HIT | EMAGGED
	flags_1 = NODECONSTRUCT_1

/obj/machinery/chem_dispenser/drinks/beer/fullupgrade/Initialize()
	. = ..()
	dispensable_reagents |= emagged_reagents //adds emagged reagents
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/chem_dispenser/drinks/beer(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stock_parts/cell/bluespace(null)
	RefreshParts()

/obj/machinery/chem_dispenser/mutagen
	name = "mutagen dispenser"
	desc = "Creates and dispenses mutagen."
	dispensable_reagents = list(/datum/reagent/toxin/mutagen)
	upgrade_reagents = null
	emagged_reagents = list(/datum/reagent/toxin/plasma)


/obj/machinery/chem_dispenser/mutagensaltpeter
	name = "botanical chemical dispenser"
	desc = "Creates and dispenses chemicals useful for botany."
	flags_1 = NODECONSTRUCT_1

	dispensable_reagents = list(
		/datum/reagent/toxin/mutagen,
		/datum/reagent/saltpetre,
		/datum/reagent/plantnutriment/eznutriment,
		/datum/reagent/plantnutriment/left4zednutriment,
		/datum/reagent/plantnutriment/robustharvestnutriment,
		/datum/reagent/water,
		/datum/reagent/toxin/plantbgone,
		/datum/reagent/toxin/plantbgone/weedkiller,
		/datum/reagent/toxin/pestkiller,
		/datum/reagent/medicine/cryoxadone,
		/datum/reagent/ammonia,
		/datum/reagent/ash,
		/datum/reagent/diethylamine)
		//same as above.
	upgrade_reagents = null
	upgrade_reagents2 = null
	upgrade_reagents3 = null

/obj/machinery/chem_dispenser/mutagensaltpeter/Initialize()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/chem_dispenser(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stock_parts/cell/bluespace(null)
	RefreshParts()

/obj/machinery/chem_dispenser/fullupgrade //fully ugpraded stock parts, emagged
	desc = "Creates and dispenses chemicals. This model has had its safeties shorted out."
	obj_flags = CAN_BE_HIT | EMAGGED
	flags_1 = NODECONSTRUCT_1

/obj/machinery/chem_dispenser/fullupgrade/Initialize()
	. = ..()
	dispensable_reagents |= emagged_reagents //adds emagged reagents
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/chem_dispenser(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stock_parts/cell/bluespace(null)
	RefreshParts()

/obj/machinery/chem_dispenser/abductor
	name = "reagent synthesizer"
	desc = "Synthesizes a variety of reagents using proto-matter."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "chem_dispenser"
	has_panel_overlay = FALSE
	circuit = /obj/item/circuitboard/machine/chem_dispenser/abductor
	working_state = null
	nopower_state = null
	dispensable_reagents = list(
		/datum/reagent/hydrogen,
		/datum/reagent/lithium,
		/datum/reagent/carbon,
		/datum/reagent/nitrogen,
		/datum/reagent/oxygen,
		/datum/reagent/fluorine,
		/datum/reagent/sodium,
		/datum/reagent/aluminium,
		/datum/reagent/silicon,
		/datum/reagent/phosphorus,
		/datum/reagent/sulfur,
		/datum/reagent/chlorine,
		/datum/reagent/potassium,
		/datum/reagent/iron,
		/datum/reagent/copper,
		/datum/reagent/mercury,
		/datum/reagent/radium,
		/datum/reagent/water,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/sugar,
		/datum/reagent/toxin/acid,
		/datum/reagent/fuel,
		/datum/reagent/silver,
		/datum/reagent/iodine,
		/datum/reagent/bromine,
		/datum/reagent/stable_plasma,
		/datum/reagent/oil,
		/datum/reagent/ammonia,
		/datum/reagent/ash,
		/datum/reagent/acetone,
		/datum/reagent/phenol,
		/datum/reagent/diethylamine,
		/datum/reagent/medicine/mine_salve,
		/datum/reagent/toxin,
		/datum/reagent/drug/space_drugs,
		/datum/reagent/toxin/plasma,
		/datum/reagent/consumable/frostoil,
		/datum/reagent/uranium,
		/datum/reagent/toxin/histamine,
		/datum/reagent/medicine/morphine
	)

/obj/machinery/chem_dispenser/abductor/Initialize()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/chem_dispenser(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/matter_bin/bluespace(null)
	component_parts += new /obj/item/stock_parts/capacitor/quadratic(null)
	component_parts += new /obj/item/stock_parts/manipulator/femto(null)
	component_parts += new /obj/item/stack/sheet/glass(null)
	component_parts += new /obj/item/stock_parts/cell/bluespace(null)
	RefreshParts()

///An unique, less efficient model found in the medbay apothecary room.
/obj/machinery/chem_dispenser/apothecary
	name = "apothecary chem dispenser"
	desc = "A cheaper chem dispenser meant for small scale medicine production."
	icon_state = "minidispenser"
	working_state = "minidispenser_working"
	nopower_state = "minidispenser_nopower"
	circuit = /obj/item/circuitboard/machine/chem_dispenser/apothecary
	powerefficiency = 0.0833333
	dispensable_reagents = list( //radium and stable plasma moved to upgrade tier 1 and 2, they've little to do with most medicines anyway.
		/datum/reagent/hydrogen,
		/datum/reagent/lithium,
		/datum/reagent/carbon,
		/datum/reagent/nitrogen,
		/datum/reagent/oxygen,
		/datum/reagent/fluorine,
		/datum/reagent/sodium,
		/datum/reagent/aluminium,
		/datum/reagent/silicon,
		/datum/reagent/phosphorus,
		/datum/reagent/sulfur,
		/datum/reagent/chlorine,
		/datum/reagent/potassium,
		/datum/reagent/iron,
		/datum/reagent/copper,
		/datum/reagent/mercury,
		/datum/reagent/water,
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/sugar,
		/datum/reagent/toxin/acid,
		/datum/reagent/fuel,
		/datum/reagent/silver,
		/datum/reagent/iodine,
		/datum/reagent/bromine
	)
	upgrade_reagents = list(
		/datum/reagent/oil,
		/datum/reagent/ammonia,
		/datum/reagent/radium
	)
	upgrade_reagents2 = list(
		/datum/reagent/acetone,
		/datum/reagent/phenol,
		/datum/reagent/stable_plasma
	)
	upgrade_reagents3 = list(
		/datum/reagent/medicine/mine_salve
	)

	emagged_reagents = list(
		/datum/reagent/drug/space_drugs,
		/datum/reagent/toxin/carpotoxin,
		/datum/reagent/medicine/morphine
	)

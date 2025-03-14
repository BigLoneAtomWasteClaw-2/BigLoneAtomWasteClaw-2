/datum/job/wasteland
	department_flag = WASTELAND

////////////////
// 	   DEN 	  //
////////////////

/datum/job/wasteland/f13enforcer
	title = "Den Mob Enforcer"
	flag = F13ENFORCER
	faction = FACTION_WASTELAND
	social_faction = FACTION_RAIDERS
	total_positions = 4
	spawn_positions = 4
	description = "The mob rules in Yuma. A hitman for the Den's Boss, you are a highly loyal enforcer charged with keeping order among the outlaw groups inhabiting the Den."
	supervisors = "The Boss."
	selection_color = "#ff4747"
	exp_requirements = 600
	exp_type = EXP_TYPE_WASTELAND

	outfit = /datum/outfit/job/wasteland/f13enforcer

	access = list(ACCESS_DEN)
	minimal_access = list(ACCESS_DEN)

	loadout_options = list(
		/datum/outfit/loadout/hitman,
		/datum/outfit/loadout/bodyguard,
		)

/datum/outfit/job/wasteland/f13enforcer
	name = "Den Mob Enforcer"
	jobtype = /datum/job/wasteland/f13enforcer

	id = /obj/item/card/id/denid
	belt = /obj/item/storage/belt/military/assault
	shoes = /obj/item/clothing/shoes/laceup
	ears = /obj/item/radio/headset/headset_den
	l_pocket = /obj/item/melee/onehanded/knife/switchblade
	r_pocket = /obj/item/flashlight/seclite
	uniform = /obj/item/clothing/under/f13/densuit
	backpack =	/obj/item/storage/backpack/satchel
	satchel =  /obj/item/storage/backpack/satchel
	gloves =  /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/beret/durathread
	mask =  /obj/item/clothing/mask/bandana/durathread
	backpack_contents = list(
		/obj/item/reagent_containers/hypospray/medipen/stimpak = 1,
		/obj/item/restraints/handcuffs = 1,
		/obj/item/storage/bag/money/small/wastelander
		)

/datum/outfit/job/wasteland/f13enforcer/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/book/granter/trait/selection

/datum/outfit/loadout/hitman
	name = "Hitman"
	r_hand = /obj/item/gun/ballistic/automatic/smg/mini_uzi
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(
						/obj/item/ammo_box/magazine/uzim9mm = 3,
						/obj/item/suppressor = 1
						)

/datum/outfit/loadout/bodyguard
	name = "Bodyguard"
	r_hand = /obj/item/gun/ballistic/shotgun/police
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(
		/obj/item/ammo_box/shotgun/buck = 2,
		/obj/item/melee/onehanded/knife/hunting = 1
		)




/datum/job/wasteland/f13mobboss
	title = "Den Mob Boss"
	flag = F13MOBBOSS
	faction = FACTION_WASTELAND
	social_faction = FACTION_RAIDERS
	total_positions = 1
	spawn_positions = 1
	description = "The mob rules in Yuma, and you're on top. Keeping the loose association of Khans, outlaws, and other no-goods together you maintain order in The Den by force. Ensure that all inhabitants of the Den obey their rules, and spread your influence over the wasteland. Be careful though - even your own men can't be trusted."
	supervisors = "The Overboss, God."
	selection_color = "#ff4747"
	exp_requirements = 1000
	exp_type = EXP_TYPE_OUTLAW

	outfit = /datum/outfit/job/wasteland/f13mobboss

	access = list(ACCESS_DEN)
	minimal_access = list(ACCESS_DEN)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/rival = list(
			/datum/job/oasis/f13sheriff,
			/datum/job/oasis/f13mayor,
			/datum/job/oasis/f13deputy,
		),
		/datum/matchmaking_pref/patron = list(
			/datum/job/wasteland/f13wastelander,
		),
	)

	loadout_options = list(
		/datum/outfit/loadout/ncrrdenboss,
		/datum/outfit/loadout/truedenmob
		)

/datum/outfit/job/wasteland/f13mobboss
	name = "Den Mob Boss"
	jobtype = /datum/job/wasteland/f13mobboss

	id = /obj/item/card/id/denid
	belt = /obj/item/storage/belt/military/assault
	ears = /obj/item/radio/headset/headset_den
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/melee/onehanded/knife/switchblade
	r_pocket = /obj/item/flashlight/seclite
	uniform = /obj/item/clothing/under/f13/densuit
	suit = /obj/item/clothing/suit/armor/f13/combat/mk2/raider
	backpack =	/obj/item/storage/backpack/satchel
	satchel = 	/obj/item/storage/backpack/satchel
	gloves = /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/caphat/beret/white
	mask = /obj/item/clothing/mask/bandana/durathread
	backpack_contents = list(
		/obj/item/reagent_containers/hypospray/medipen/stimpak = 1,
		/obj/item/restraints/handcuffs = 1,
		/obj/item/storage/bag/money/small/raider/mobboss,
		)


/datum/outfit/loadout/ncrrdenboss
	name = "Central Cali Den Boss"
	backpack_contents = list(
							/obj/item/ammo_box/tube/a357 = 4,
							/obj/item/book/granter/trait/trekking = 1,
							/obj/item/gun/ballistic/revolver/colt357/brassgun = 2,
							/obj/item/book/granter/trait/gunslinger = 1
							)

/datum/outfit/loadout/truedenmob
	name = "True Den Boss"
	r_hand = /obj/item/gun/ballistic/automatic/smg/tommygun
	backpack_contents = list(
							/obj/item/ammo_box/magazine/tommygunm45/stick = 3
							)

/datum/job/wasteland/f13dendoctor
	title = "Den Doctor"
	flag = F13DENDOCTOR
	faction = FACTION_WASTELAND
	social_faction = FACTION_RAIDERS
	total_positions = 4
	spawn_positions = 4
	description = "While you prioritize providing medical treatment in emergency situations, you are still trained in combat and have the additional role as a loyal combanteer to the Den."
	supervisors = "The Boss."
	selection_color = "#ff4747"
	exp_requirements = 1000
	exp_type = EXP_TYPE_OUTLAW

	outfit = /datum/outfit/job/wasteland/f13dendoctor

	access = list(ACCESS_DEN)
	minimal_access = list(ACCESS_DEN)

	loadout_options = list(
		/datum/outfit/loadout/dencombatmedic,
		/datum/outfit/loadout/denchemist,
		)

/datum/outfit/job/wasteland/f13dendoctor
	name = "Den Doctor"
	jobtype = /datum/job/wasteland/f13dendoctor

	id = /obj/item/card/id/denid
	belt = /obj/item/storage/belt/medical
	shoes = /obj/item/clothing/shoes/laceup
	ears = /obj/item/radio/headset/headset_den
	r_pocket = /obj/item/flashlight/seclite
	uniform = /obj/item/clothing/under/f13/densuit
	backpack =	/obj/item/storage/backpack/medic
	gloves =  /obj/item/clothing/gloves/color/white
	head = /obj/item/clothing/head/beret/durathread
	mask =  /obj/item/clothing/mask/bandana/durathread
	backpack_contents = list(
		/obj/item/reagent_containers/hypospray/medipen/stimpak=2, \
		/obj/item/healthanalyzer=1, \
		/obj/item/storage/bag/money/small/wastelander)

/datum/outfit/job/wasteland/f13dendoctor/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_TECHNOPHREAK, src)
	ADD_TRAIT(H, TRAIT_CHEMWHIZ, src)
	ADD_TRAIT(H, TRAIT_MEDICALEXPERT, src)
	ADD_TRAIT(H, TRAIT_SURGERY_MID, src)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/jet)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/turbo)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/psycho)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/medx)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/buffout)


/datum/outfit/loadout/dencombatmedic
	name = "Combat medic"
	r_hand = /obj/item/gun/ballistic/automatic/smg/tommygun
	suit = /obj/item/clothing/suit/toggle/labcoat/chemist
	backpack_contents = list(
							/obj/item/clothing/glasses/hud/health/f13 = 1,
							/obj/item/ammo_box/magazine/tommygunm45/stick = 2
							)

/datum/outfit/loadout/denchemist
	name = "Chemist"
	r_hand = /obj/item/gun/ballistic/automatic/pistol/type17
	suit = /obj/item/clothing/suit/toggle/labcoat/chemist
	backpack_contents = list(
						/obj/item/ammo_box/magazine/m10mm_adv/simple = 1,
						/obj/item/grenade/chem_grenade = 1,
						/obj/item/clothing/mask/gas = 1,
						/obj/item/reagent_containers/glass/beaker/large = 2
						)


/*
Raider
*/

/datum/job/wasteland/f13raider
	title = "Outlaw"
	flag = F13RAIDER
	department_head = list("Captain")
	head_announce = list("Security")
	faction = FACTION_WASTELAND
	social_faction = FACTION_RAIDERS
	total_positions = 24
	spawn_positions = 24
	description = "You are an undesirable figure of some kind- perhaps a corrupt official, or a cannibalistic bartender, or a devious conman, to name a few examples. You have more freedom than anyone else in the wastes, and are not bound by the same moral code as others, but though you may only be interested in self-gain, you still have a responsibility to make your time here interesting, fun, and engaging for others- this means that whatever path you pursue should be more nuanced and flavorful than simple highway robbery or slavery. (Adminhelp if you require help setting up your character for the round.)"
	supervisors = "Your desire to make things interesting and fun. Don't play this as wastelander+."
	selection_color = "#ff4747"
	exp_requirements = 0
	exp_type = EXP_TYPE_FALLOUT

	outfit = /datum/outfit/job/wasteland/f13raider

	access = list(ACCESS_RAIDER, ACCESS_PUBLIC)
	minimal_access = list(ACCESS_RAIDER, ACCESS_PUBLIC)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wasteland/f13dendoctor,
			/datum/job/wasteland/f13enforcer,
			/datum/job/wasteland/f13mobboss,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wasteland/f13dendoctor,
			/datum/job/wasteland/f13enforcer,
			/datum/job/wasteland/f13mobboss,
		),
		/datum/matchmaking_pref/patron = list(
			/datum/job/wasteland/f13raider,
		),
		/datum/matchmaking_pref/protegee = list(
			/datum/job/wasteland/f13raider,
		),
		/datum/matchmaking_pref/outlaw = list(
			/datum/job/wasteland/f13raider,
		),
		/datum/matchmaking_pref/bounty_hunter = list(
			/datum/job/wasteland/f13raider,
		),
	)
	loadout_options = list(
	/datum/outfit/loadout/raider_supafly,
	/datum/outfit/loadout/raider_yankee,
	/datum/outfit/loadout/raider_blast,
	/datum/outfit/loadout/raider_sadist,
	/datum/outfit/loadout/raider_painspike,
	/datum/outfit/loadout/raider_badlands,
	/datum/outfit/loadout/raider_sheriff,
	/datum/outfit/loadout/raider_smith,
	/datum/outfit/loadout/raider_vault,
	/datum/outfit/loadout/raider_ncr,
	/datum/outfit/loadout/raider_legion,
	/datum/outfit/loadout/raider_bos,
	/datum/outfit/loadout/quack_doctor,
	/datum/outfit/loadout/raider_powder,
	/datum/outfit/loadout/raider_tribal,
	/datum/outfit/loadout/greatkhan
	)


/datum/outfit/job/wasteland/f13raider
	name = "Outlaw"
	jobtype = /datum/job/wasteland/f13raider
	id = null
	ears = null
	belt = null
	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	gloves = /obj/item/clothing/gloves/f13/handwraps
	r_pocket = /obj/item/flashlight/flare
	backpack_contents = list(
		/obj/item/restraints/handcuffs = 2,
		/obj/item/melee/onehanded/club = 1,
		/obj/item/reagent_containers/hypospray/medipen/stimpak = 1,
		/obj/item/storage/bag/money/small/raider = 1
		)


/datum/outfit/job/wasteland/f13raider/pre_equip(mob/living/carbon/human/H)
	. = ..()
	uniform = pick(
		/obj/item/clothing/under/f13/raider_leather, \
		/obj/item/clothing/under/f13/raiderrags, \
		/obj/item/clothing/under/pants/f13/ghoul, \
		/obj/item/clothing/under/jabroni \
		)
	if(prob(80))
		mask = pick(
			/obj/item/clothing/mask/bandana/red,\
			/obj/item/clothing/mask/bandana/blue,\
			/obj/item/clothing/mask/bandana/green,\
			/obj/item/clothing/mask/bandana/gold,\
			/obj/item/clothing/mask/bandana/black,\
			/obj/item/clothing/mask/bandana/skull)
	if(prob(50))
		neck = pick(
			/obj/item/clothing/neck/mantle/peltfur,\
			/obj/item/clothing/neck/mantle/peltmountain,\
			/obj/item/clothing/neck/mantle/poncho,\
			/obj/item/clothing/neck/mantle/ragged,\
			/obj/item/clothing/neck/mantle/brown,\
			/obj/item/clothing/neck/mantle/gecko)

	shoes = (/obj/item/clothing/shoes/f13/raidertreads)

/datum/outfit/job/wasteland/f13raider/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_LONGPORKLOVER, src)

	H.social_faction = FACTION_RAIDERS
	add_verb(H, /mob/living/proc/creategang)

/datum/outfit/loadout/raider_supafly
	name = "Supa-fly"
	suit = /obj/item/clothing/suit/armor/f13/raider/supafly
	head = /obj/item/clothing/head/helmet/f13/raider/supafly
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/varmint = 1,
		/obj/item/ammo_box/magazine/m556/rifle/assault = 1,
		/obj/item/gun/ballistic/revolver/hobo/knucklegun = 1,
		/obj/item/ammo_box/c45rev = 2,
		/obj/item/attachments/scope = 1,
		/obj/item/reagent_containers/food/drinks/bottle/f13nukacola/radioactive = 1,
		/obj/item/grenade/smokebomb = 2,
		/obj/item/book/granter/trait/trekking = 1
		)

/datum/outfit/loadout/raider_yankee
	name = "Yankee"
	suit = /obj/item/clothing/suit/armor/f13/raider/yankee
	head = /obj/item/clothing/head/helmet/f13/raider/yankee
	backpack_contents = list(
		/obj/item/melee/onehanded/knife/cosmicdirty = 1,
		/obj/item/storage/fancy/cigarettes/cigpack_cannabis = 1,
		/obj/item/megaphone = 1,
		/obj/item/radio/headset = 1,
		/obj/item/book/granter/trait/bigleagues = 1,
		/obj/item/storage/pill_bottle/chem_tin/buffout = 1
		)

/datum/outfit/loadout/raider_blast
	name = "Blastmaster"
	suit = /obj/item/clothing/suit/armor/f13/raider/blastmaster
	head = /obj/item/clothing/head/helmet/f13/raider/blastmaster
	backpack_contents = list(
		/obj/item/kitchen/knife/butcher = 1,
		/obj/item/book/granter/crafting_recipe/blueprint/trapper = 1,
		/obj/item/radio/headset = 1,
		/obj/item/book/granter/trait/explosives = 1
		)

/datum/outfit/loadout/raider_sadist
	name = "Sadist"
	suit = /obj/item/clothing/suit/armor/f13/raider/sadist
	head = /obj/item/clothing/head/helmet/f13/raider/arclight
	backpack_contents = list(
		/obj/item/melee/onehanded/knife/throwing = 5,
		/obj/item/clothing/mask/gas/explorer/folded = 1,
		/obj/item/storage/belt = 1,
		/obj/item/restraints/legcuffs/beartrap = 2,
		/obj/item/reverse_bear_trap = 1,
		/obj/item/melee/unarmed/lacerator = 1,
		/obj/item/radio/headset = 1,
		/obj/item/book/granter/trait/trekking = 1
		)

/datum/outfit/loadout/raider_badlands
	name = "Fiend"
	suit = /obj/item/clothing/suit/armor/f13/raider/badlands
	head = /obj/item/clothing/head/helmet/f13/fiend
	backpack_contents = list(
		/obj/item/gun/energy/laser/wattz/magneto = 2,
		/obj/item/stock_parts/cell/ammo/ec = 2,
		/obj/item/reagent_containers/hypospray/medipen/psycho = 3,
		/obj/item/reagent_containers/pill/patch/turbo = 2,
		/obj/item/reagent_containers/hypospray/medipen/medx = 1,
		/obj/item/book/granter/trait/trekking = 1,
		/obj/item/radio/headset = 1
		)


/datum/outfit/loadout/raider_painspike
	name = "Painspike"
	suit = /obj/item/clothing/suit/armor/f13/raider/painspike
	head = /obj/item/clothing/head/helmet/f13/raider/psychotic
	backpack_contents = list(
		/obj/item/gun/ballistic/shotgun/hunting = 1,
		/obj/item/ammo_box/shotgun/buck = 1,
		/obj/item/ammo_box/shotgun/bean = 1,
		/obj/item/melee/onehanded/club/fryingpan = 1,
		/obj/item/radio/headset = 1,
		/obj/item/book/granter/trait/bigleagues = 1,
		/obj/item/grenade/chem_grenade/cleaner = 2
		)

/datum/outfit/loadout/quack_doctor
	name = "Quack Doctor"
	suit = /obj/item/clothing/suit/toggle/labcoat/f13/followers
	l_hand = /obj/item/storage/backpack/duffelbag/med/surgery
	r_hand = /obj/item/book/granter/trait/lowsurgery
	suit_store = /obj/item/gun/energy/laser/wattz
	backpack_contents = list(
		/obj/item/stock_parts/cell/ammo/ec = 1,
		/obj/item/reagent_containers/pill/patch/jet = 3,
		/obj/item/storage/firstaid/ancient = 1,
		/obj/item/storage/pill_bottle/aranesp = 1,
		/obj/item/storage/pill_bottle/happy = 1,
		/obj/item/stack/sheet/mineral/silver = 2,
		/obj/item/defibrillator/primitive = 1
		)

/datum/outfit/loadout/raider_ncr
	name = "NCR Deserter"
	suit = /obj/item/clothing/suit/armor/f13/exile/ncrexile
	uniform = /obj/item/clothing/under/f13/exile
	id = /obj/item/card/id/rusted
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/service = 1,
		/obj/item/ammo_box/magazine/m556/rifle = 2,
		/obj/item/melee/onehanded/knife/bayonet = 1,
		/obj/item/storage/box/ration/ranger_breakfast = 1,
		/obj/item/radio/headset = 1,
		/obj/item/reagent_containers/hypospray/medipen/stimpak = 2
		)

/datum/outfit/loadout/raider_legion
	name = "Disgraced Legionary"
	suit = /obj/item/clothing/suit/armor/f13/exile/legexile
	uniform = /obj/item/clothing/under/f13/exile/legion
	id = /obj/item/card/id/rusted/rustedmedallion
	backpack_contents = list(
		/obj/item/melee/onehanded/machete/gladius = 1,
		/obj/item/storage/backpack/spearquiver = 1,
		/obj/item/gun/ballistic/automatic/smg/greasegun = 1,
		/obj/item/ammo_box/magazine/greasegun = 1,
		/obj/item/book/granter/trait/bigleagues = 1
		)

/datum/outfit/loadout/raider_bos
	name = "Brotherhood Exile"
	suit = /obj/item/clothing/suit/armor/f13/exile/bosexile
	id = /obj/item/card/id/rusted/brokenholodog
	backpack_contents = list(
		/obj/item/gun/energy/laser/pistol = 1,
		/obj/item/stock_parts/cell/ammo/ec = 2,
		/obj/item/book/granter/crafting_recipe/blueprint/aep7 = 1,
		/obj/item/storage/belt/holster/legholster = 1,
		/obj/item/pda = 1,
		/obj/item/radio/headset = 1,
		/obj/item/grenade/empgrenade = 2
		)

/datum/outfit/loadout/raider_sheriff
	name = "Desperado"
	suit = /obj/item/clothing/suit/armored/light/duster/desperado
	uniform = /obj/item/clothing/under/syndicate/tacticool
	head = /obj/item/clothing/head/f13/town/big
	backpack_contents = list(
		/obj/item/gun/ballistic/revolver/m29/snub = 2,
		/obj/item/storage/belt/holster = 1,
		/obj/item/ammo_box/m44 = 3,
		/obj/item/radio/headset = 1,
		/obj/item/book/granter/trait/gunslinger = 1
		)

/datum/outfit/loadout/raider_smith
	name = "Raider Smith"
	suit = /obj/item/clothing/suit/armored/heavy/raidermetal
	uniform = /obj/item/clothing/under/f13/raider_leather
	head = /obj/item/clothing/head/helmet/f13/raider/arclight
	gloves = /obj/item/clothing/gloves/f13/blacksmith
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/pistol/m1911/custom = 1,
		/obj/item/ammo_box/magazine/m45 = 1,
		/obj/item/twohanded/steelsaw = 1,
		/obj/item/melee/smith/hammer = 1,
		/obj/item/stack/sheet/mineral/sandstone = 50,
		/obj/item/book/granter/trait/techno = 1,
		/obj/item/radio/headset = 1,
		/obj/item/book/granter/crafting_recipe/scav_one = 1
		)

/datum/outfit/loadout/raider_vault
	name = "Vault Renegade"
	suit = /obj/item/clothing/suit/armor/vest/big
	uniform = /obj/item/clothing/under/f13/exile/vault
	id = /obj/item/card/id/rusted/fadedvaultid
	backpack_contents = list(
		/obj/item/gun/ballistic/automatic/pistol/n99 = 1,
		/obj/item/ammo_box/magazine/m10mm_adv/simple = 3,
		/obj/item/reagent_containers/hypospray/medipen/stimpak/super = 2,
		/obj/item/radio/headset = 1
		)

/datum/outfit/loadout/raider_tribal
	name = "Tribal Outcast"
	uniform = /obj/item/clothing/under/f13/exile/tribal
	suit = /obj/item/clothing/suit/hooded/tribaloutcast
	suit_store = /obj/item/twohanded/spear/bonespear
	shoes = /obj/item/clothing/shoes/sandal
	belt = /obj/item/storage/backpack/spearquiver
	box = /obj/item/storage/survivalkit_tribal
	back = /obj/item/storage/backpack/satchel/explorer
	backpack_contents = list(
		/obj/item/clothing/mask/cigarette/pipe = 1,
		/obj/item/melee/onehanded/knife/bone = 1,
		/obj/item/radio/tribal = 1,
		/obj/item/book/granter/trait/trekking = 1
		)

/datum/outfit/loadout/raider_powder
	name = "Powder Ganger"
	belt = /obj/item/storage/belt/bandolier
	uniform = /obj/item/clothing/under/f13/ncrcf
	suit = /obj/item/clothing/suit/armor/vest/big
	backpack_contents = list(
		/obj/item/melee/onehanded/knife/hunting = 1,
		/obj/item/gun/ballistic/automatic/smg/greasegun = 1,
		/obj/item/ammo_box/magazine/greasegun = 2,
		/obj/item/grenade/f13/dynamite = 2,
		/obj/item/book/granter/trait/explosives = 1
		)

/datum/outfit/loadout/greatkhan
	name = "Great Khan"
	suit = /obj/item/clothing/suit/toggle/labcoat/f13/khan_jacket
	id = /obj/item/card/id/khantattoo
	ears = /obj/item/radio/headset
	head = /obj/item/clothing/head/helmet/f13/khan
	shoes = /obj/item/clothing/shoes/f13/military/khan
	uniform = /obj/item/clothing/under/f13/khan
	r_hand = /obj/item/book/granter/trait/selection
	r_pocket = /obj/item/flashlight/flare
	l_pocket = /obj/item/storage/survivalkit_khan
	gloves = /obj/item/melee/unarmed/brass/spiked
	backpack_contents = list(
		/obj/item/reagent_containers/pill/patch/jet = 2,
		/obj/item/storage/bag/money/small/khan = 1,
		)

/datum/job/wasteland/f13wastelander
	title = "Wastelander"
	flag = F13WASTELANDER
	faction = FACTION_WASTELAND
	total_positions = -1
	spawn_positions = -1
	description = "You arrive in Yuma Valley, hoping to escape your past, the war, or perhaps something worse. But you’ve seen the torchlight and heard the bark of the military officers. You haven’t escaped anything. Try to survive, establish your own settlement, make your own legend. Suffer well and die gladly."
	supervisors = "God"
	selection_color = "#dddddd"

	outfit = /datum/outfit/job/wasteland/f13wastelander

	access = list(ACCESS_WASTER, ACCESS_PUBLIC)
	minimal_access = list(ACCESS_WASTER, ACCESS_PUBLIC)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wasteland/f13wastelander,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wasteland/f13wastelander,
		),
		/datum/matchmaking_pref/mentor = list(
			/datum/job/wasteland/f13wastelander,
		),
		/datum/matchmaking_pref/disciple = list(
			/datum/job/wasteland/f13wastelander,
		),
		/datum/matchmaking_pref/patron = list(
			/datum/job/wasteland/f13wastelander,
		),
		/datum/matchmaking_pref/protegee = list(
			/datum/job/wasteland/f13wastelander,
		),
	)
	loadout_options = list(
	/datum/outfit/loadout/vault_refugee,
	/datum/outfit/loadout/salvager,
	/datum/outfit/loadout/medic,
	/datum/outfit/loadout/merchant,
	/datum/outfit/loadout/scavenger,
	/datum/outfit/loadout/settler,
	/datum/outfit/loadout/warrior,
	/datum/outfit/loadout/ncrcitizen,
	/datum/outfit/loadout/legioncivilian,
	/datum/outfit/loadout/wastelander_desert_ranger
	)

/datum/outfit/job/wasteland/f13wastelander
	name = "Wastelander"
	jobtype = /datum/job/wasteland/f13wastelander

	id = null
	ears = null
	belt = null
	r_hand = /obj/item/book/granter/trait/selection
	l_pocket = /obj/item/storage/bag/money/small/wastelander
	r_pocket = /obj/item/flashlight/flare
	belt = /obj/item/melee/onehanded/knife/survival
	backpack = /obj/item/storage/backpack/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	backpack_contents = list(
		/obj/item/reagent_containers/hypospray/medipen/stimpak,
		/obj/item/reagent_containers/hypospray/medipen/stimpak,
		/obj/item/reagent_containers/pill/radx,
		)

/datum/outfit/job/wasteland/f13wastelander/pre_equip(mob/living/carbon/human/H)
	..()
	suit = pick(
		/obj/item/clothing/suit/armor/f13/kit, \
		/obj/item/clothing/suit/f13/veteran, \
		/obj/item/clothing/suit/toggle/labcoat/f13/wanderer \
		)

/datum/outfit/loadout/salvager
	name = "Salvager"
	uniform = /obj/item/clothing/under/f13/machinist
	shoes = /obj/item/clothing/shoes/f13/explorer
	gloves = /obj/item/clothing/gloves/f13/blacksmith
	head = /obj/item/clothing/head/welding
	r_hand = /obj/item/weldingtool/largetank
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/m1911 = 1
							)

/datum/outfit/loadout/scavenger
	name = "Scavenger"
	uniform = /obj/item/clothing/under/f13/lumberjack
	shoes = /obj/item/clothing/shoes/f13/explorer
	r_hand = /obj/item/storage/backpack/duffelbag/scavengers
	l_hand = /obj/item/pickaxe/drill
	belt = /obj/item/storage/belt
	backpack_contents = list(/obj/item/mining_scanner = 1,
							/obj/item/metaldetector = 1,
							/obj/item/shovel = 1,
							/obj/item/gun/ballistic/automatic/pistol/m1911 = 1
							)

/datum/outfit/loadout/settler
	name = "Settler"
	uniform = /obj/item/clothing/under/f13/settler
	shoes = /obj/item/clothing/shoes/f13/explorer
	r_hand = /obj/item/hatchet
	l_hand = /obj/item/gun/ballistic/automatic/pistol/n99
	belt = /obj/item/storage/belt
	backpack_contents = list(
		/obj/item/stack/sheet/metal/fifty = 1,
		/obj/item/stack/sheet/mineral/wood/fifty = 1,
		/obj/item/pickaxe/mini = 1,
		/obj/item/toy/crayon/spraycan = 1,
		/obj/item/cultivator = 1,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/storage/bag/plants/portaseeder = 1
		)

/datum/outfit/loadout/medic
	name = "Wasteland Doctor"
	uniform = /obj/item/clothing/under/f13/follower
	suit = /obj/item/clothing/suit/toggle/labcoat/f13/followers
	shoes = /obj/item/clothing/shoes/f13/explorer
	gloves = /obj/item/clothing/gloves/color/latex
	neck = /obj/item/clothing/neck/stethoscope
	belt = /obj/item/storage/belt/medical
	backpack_contents =  list(/obj/item/reagent_containers/medspray/synthflesh = 2,
							/obj/item/smelling_salts = 1,
							/obj/item/healthanalyzer = 1,
							/obj/item/gun/energy/laser/rechargerrifle = 1,
							/obj/item/reagent_containers/glass/bottle/epinephrine = 2,
							/obj/item/storage/backpack/duffelbag/med/surgery = 1,
							/obj/item/paper_bin = 1,
							/obj/item/folder = 1,
							/obj/item/pen/fountain = 1,
							/obj/item/storage/firstaid/ancient = 1
							)

/datum/outfit/loadout/merchant
	name = "Roving Trader"
	uniform = /obj/item/clothing/under/f13/merchant
	neck = /obj/item/clothing/neck/mantle/brown
	shoes = /obj/item/clothing/shoes/f13/brownie
	head = /obj/item/clothing/head/f13/stormchaser
	gloves = /obj/item/clothing/gloves/color/brown
	glasses = /obj/item/clothing/glasses/f13/biker
	l_hand = /obj/item/gun/ballistic/revolver/caravan_shotgun
	backpack_contents =  list(/obj/item/storage/box/vendingmachine = 1,
							/obj/item/gun/ballistic/automatic/pistol/m1911 = 1
							)

//end new

/datum/outfit/loadout/vault_refugee
	name = "Vaultie"
	uniform = /obj/item/clothing/under/f13/vault
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/fingerless
	suit = /obj/item/clothing/suit/suspenders
	ears = /obj/item/radio/headset
	backpack_contents = list(
		/obj/item/card/id/selfassign = 1,
		/obj/item/gun/ballistic/automatic/pistol/n99 = 1,
		/obj/item/ammo_box/magazine/m10mm_adv/simple = 2,
		/obj/item/pda = 1
		)

/datum/outfit/loadout/warrior
	name = "Wasteland Warrior"
	uniform = /obj/item/clothing/under/f13/settler
	shoes = /obj/item/clothing/shoes/f13/raidertreads
	suit = /obj/item/clothing/suit/armor/light/wastewar
	head = /obj/item/clothing/head/helmet/f13/wastewarhat
	glasses = /obj/item/clothing/glasses/welding
	l_hand = /obj/item/shield/riot/buckler/stop
	backpack_contents = list(
		/obj/item/melee/onehanded/machete/scrapsabre = 1
		)

/datum/outfit/loadout/legioncivilian
	name = "Legion Civilian"
	uniform = /obj/item/clothing/under/f13/doctor
	shoes = /obj/item/clothing/shoes/f13/fancy
	suit = /obj/item/clothing/suit/curator
	head = /obj/item/clothing/head/scarecrow_hat
	gloves = /obj/item/clothing/gloves/color/black
	glasses = /obj/item/clothing/glasses/welding
	id = /obj/item/card/id/dogtag/town/legion
	l_hand = /obj/item/shield/riot/buckler
	backpack_contents = list(
		/obj/item/melee/onehanded/machete = 1
		)

/datum/outfit/loadout/ncrcitizen
	name = "NCR Citizen"
	uniform = /obj/item/clothing/under/f13/ncrcaravan
	shoes = /obj/item/clothing/shoes/f13/tan
	head = /obj/item/clothing/head/f13/cowboy
	gloves = /obj/item/clothing/gloves/color/brown
	id = /obj/item/card/id/dogtag/town/ncr
	l_hand = /obj/item/gun/ballistic/automatic/varmint
	backpack_contents = list(
		/obj/item/ammo_box/magazine/m556/rifle = 2
		)

/datum/outfit/loadout/wastelander_desert_ranger
	name = "Desert Ranger Scout"
	uniform = /obj/item/clothing/under/f13/desert_ranger_scout
	shoes = /obj/item/clothing/shoes/f13/cowboy
	head = /obj/item/clothing/head/f13/cowboy
	gloves = /obj/item/clothing/gloves/color/brown
	l_hand = /obj/item/gun/ballistic/revolver/colt357
	backpack_contents = list(
		/obj/item/ammo_box/a357 = 2,
		/obj/item/binoculars = 1,
		/obj/item/radio = 1
		)


//New tribal role. Replaces old tribe stuff.
/datum/job/wasteland/f13tribal
	title = "Tribal"
	flag = F13TRIBAL
	display_order = JOB_DISPLAY_ORDER_TRIBAL
	faction = FACTION_WASTELAND
	total_positions = -1
	spawn_positions = -1
	description = "You are a member of a tribe, far away from your homeland. Well, relatively far away. Whatever your reasons for coming here, you've found yourself pinned between the ongoing war of the NCR and Caesar's Legion. Try not to get shot."
	supervisors = "the stars above"
	selection_color = "#dddddd"
	mapexclude = list("tribal")

	outfit = /datum/outfit/job/wasteland/f13tribal

	access = list(ACCESS_TRIBE, ACCESS_PUBLIC)
	minimal_access = list(ACCESS_TRIBE, ACCESS_PUBLIC)

	loadout_options = list(
	/datum/outfit/loadout/brawler,
	/datum/outfit/loadout/spearman,
	/datum/outfit/loadout/wayfarermelee,
	/datum/outfit/loadout/whitelegsranged,
	/datum/outfit/loadout/deadhorsesranged,
	/datum/outfit/loadout/sorrowshunter,
	/datum/outfit/loadout/eightiesranged,
	/datum/outfit/loadout/rustwalkersscrapper,
	/datum/outfit/loadout/bonedancerexile
	)

/datum/outfit/job/wasteland/f13tribal/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_TRIBAL, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)
	ADD_TRAIT(H, TRAIT_TRAPPER, src)
	ADD_TRAIT(H, TRAIT_MACHINE_SPIRITS, src)
	ADD_TRAIT(H, TRAIT_AUTO_DRAW, src)
	H.grant_language(/datum/language/tribal)
	var/list/recipes = list(
		/datum/crafting_recipe/tribal_pa,
		/datum/crafting_recipe/tribal_pa_helmet,
		/datum/crafting_recipe/tribal_combat_armor,
		/datum/crafting_recipe/tribal_combat_armor_helmet,
		/datum/crafting_recipe/tribal_r_combat_armor,
		/datum/crafting_recipe/tribal_r_combat_armor_helmet,
		/datum/crafting_recipe/tribalwar/chitinarmor,
		/datum/crafting_recipe/tribalwar/deathclawspear,
		/datum/crafting_recipe/tribalwar/lightcloak,
		/datum/crafting_recipe/tribalwar/legendaryclawcloak,
		/datum/crafting_recipe/warpaint,
		/datum/crafting_recipe/tribalradio,
		/datum/crafting_recipe/tribalwar/goliathcloak,
		/datum/crafting_recipe/tribalwar/bonebow,
		/datum/crafting_recipe/tribalwar/tribe_bow,
		/datum/crafting_recipe/tribalwar/sturdybow,
		/datum/crafting_recipe/tribalwar/warclub,
		/datum/crafting_recipe/tribalwar/silverbow,
		/datum/crafting_recipe/tribalwar/arrowbone,
		/datum/crafting_recipe/tribalwar/bonespear,
		/datum/crafting_recipe/tribalwar/bonecodpiece,
		/datum/crafting_recipe/tribalwar/bracers,
		/datum/crafting_recipe/tribal/bonetalisman,
		/datum/crafting_recipe/tribal/bonebag,
		/datum/crafting_recipe/tribalwar/spearquiver,
		/datum/crafting_recipe/tribalwar/riottribal_helmet,
		/datum/crafting_recipe/tribalwar/riottribal_armor,
		/datum/crafting_recipe/tribalwar/reinforcedtribalpelt
	)
	for(var/datum/crafting_recipe/recipe as() in recipes)
		H.mind.teach_crafting_recipe(recipe)
	H.grant_language(/datum/language/tribal)
	H.social_faction = FACTION_WASTELAND
	add_verb(H, /mob/living/proc/create_tribe)


/datum/outfit/job/wasteland/f13tribal
	name = "Tribal"
	jobtype = /datum/job/wasteland/f13tribal

	id = null
	ears = null
	belt = /obj/item/melee/onehanded/knife/bone
	uniform =     /obj/item/clothing/under/f13/settler
	box =         /obj/item/storage/survivalkit_tribal
	shoes =     /obj/item/clothing/shoes/sandal
	gloves =    /obj/item/clothing/gloves/f13/handwraps
	r_hand = /obj/item/book/granter/trait/selection/tribal
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	backpack_contents = list(
		/obj/item/reagent_containers/pill/patch/healingpowder = 2,
		/obj/item/flashlight/lantern = 1
		)

//Generic Tribals
/datum/outfit/loadout/brawler
	name = "Classic Tribal"
	suit = /obj/item/clothing/suit/armor/f13/tribal
	head = /obj/item/clothing/head/helmet/f13/deathskull
	backpack_contents = list(
		/obj/item/melee/transforming/cleaving_saw/old_rusty = 1,
		/obj/item/restraints/legcuffs/bola = 2,
		/obj/item/reagent_containers/pill/patch/healpoultice = 2,
		/obj/item/stack/medical/gauze = 1
		)

/datum/outfit/loadout/spearman
	name = "Raider Tribal"
	suit = /obj/item/clothing/suit/armored/light/tribalraider
	head = /obj/item/clothing/head/helmet/f13/fiend
	mask = /obj/item/clothing/mask/facewrap
	neck = /obj/item/clothing/neck/mantle/gray
	backpack_contents = list(
		/obj/item/twohanded/spear = 1,
		/obj/item/reagent_containers/pill/patch/bitterdrink = 2
		)
//White Legs
/datum/outfit/loadout/whitelegsranged
	name = "White Legs Tribal"
	suit = /obj/item/clothing/suit/f13/tribal/whitelegs
	backpack_contents = list(
		/obj/item/clothing/under/f13/whitelegs = 1,
		/obj/item/clothing/under/f13/female/whitelegs = 1,
		/obj/item/gun/ballistic/automatic/smg/tommygun/whitelegs = 1,
		/obj/item/gun/ballistic/automatic/pistol/ninemil = 1,
		/obj/item/reagent_containers/pill/patch/healpoultice = 1,
		/obj/item/ammo_box/magazine/tommygunm45/stick = 2,
		/obj/item/book/granter/crafting_recipe/tribal/whitelegs = 1
	)

//Dead Horses
/datum/outfit/loadout/deadhorsesranged
	name = "Dead Horses Tribal"
	suit = /obj/item/clothing/suit/f13/tribal/heavy/deadhorses
	backpack_contents = list(
		/obj/item/clothing/under/f13/deadhorses = 1,
		/obj/item/clothing/under/f13/female/deadhorses = 1,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/ammo_box/magazine/m45 = 2,
		/obj/item/reagent_containers/pill/patch/healpoultice = 2,
		/obj/item/book/granter/crafting_recipe/tribal/deadhorses = 1
	)
//Sorrows
/datum/outfit/loadout/sorrowshunter
	name = "Sorrows Tribal"
	suit = /obj/item/clothing/suit/f13/tribal/light/sorrows
	backpack_contents = list(
		/obj/item/clothing/under/f13/sorrows = 1,
		/obj/item/clothing/under/f13/female/sorrows = 1,
		/obj/item/melee/onehanded/knife/survival = 1,
		/obj/item/melee/unarmed/yaoguaigauntlet = 1,
		/obj/item/reagent_containers/pill/patch/healpoultice = 2,
		/obj/item/gun/ballistic/bow = 1,
		/obj/item/storage/belt/tribe_quiver = 1,
		/obj/item/book/granter/crafting_recipe/tribal/sorrows = 1
	)

//Eighties
/datum/outfit/loadout/eightiesranged
	name = "Eighties Tribal"
	suit = /obj/item/clothing/suit/f13/tribal/heavy/eighties
	backpack_contents = list(
		/obj/item/clothing/under/f13/eighties = 1,
		/obj/item/clothing/under/f13/female/eighties = 1,
		/obj/item/gun/ballistic/revolver/single_shotgun = 1,
		/obj/item/ammo_box/shotgun/buck = 1,
		/obj/item/gun/ballistic/automatic/smg/greasegun/worn = 1,
		/obj/item/ammo_box/magazine/greasegun = 2,
		/obj/item/reagent_containers/pill/patch/healingpowder = 2,
		/obj/item/book/granter/crafting_recipe/tribal/eighties = 1
	)

//Wayfarers
/datum/outfit/loadout/wayfarermelee
	name = "Wayfarer Tribal"
	suit = /obj/item/clothing/suit/armor/f13/lightcloak
	backpack_contents = list(
		/obj/item/clothing/under/f13/wayfarer = 1,
		/obj/item/clothing/head/helmet/f13/wayfarer/hunter = 1,
		/obj/item/twohanded/spear/bonespear = 1,
		/obj/item/reagent_containers/pill/patch/bitterdrink = 1,
		/obj/item/book/granter/crafting_recipe/tribal/wayfarer = 1
	)
//Rustwalkers
/datum/outfit/loadout/rustwalkersscrapper
	name = "Rustwalkers Tribal"
	suit = /obj/item/clothing/suit/f13/tribal/light/rustwalkers
	backpack_contents = list(
		/obj/item/clothing/under/f13/rustwalkers = 1,
		/obj/item/clothing/under/f13/female/rustwalkers = 1,
		/obj/item/gun/ballistic/revolver/hobo/pepperbox = 1,
		/obj/item/ammo_box/c10mm = 1,
		/obj/item/circular_saw = 1,
		/obj/item/storage/belt/utility/full = 1,
		/obj/item/reagent_containers/pill/patch/healpoultice = 1,
		/obj/item/book/granter/crafting_recipe/tribal/rustwalkers = 1
	)
//Bone Dancer
/datum/outfit/loadout/bonedancerexile
	name = "Bone Dancer Tribal"
	backpack_contents = list(
		/obj/item/clothing/under/f13/bone = 1,
		/obj/item/clothing/head/helmet/skull/bone = 1,
		/obj/item/book/granter/crafting_recipe/tribal/bone = 1,
		/obj/item/twohanded/spear/bonespear = 1,
		/obj/item/warpaint_bowl = 1,
		/obj/item/reagent_containers/pill/patch/healpoultice = 2,
		/obj/item/book/granter/crafting_recipe/tribal/bone = 1
	)

/* /datum/job/wasteland/f13bwsettler
	title = "Blackwater Settler"
	flag = F13BWSETTLER
	total_positions = 8
	spawn_positions = -1
	faction = FACTION_WASTELAND
	description = "You are a settler of the frontier, that came to south kebab after the loss of your settlement. You are a normal Kebab citizen too."
	supervisors = "The Sheriff and his deputies, the militia commander, the merchant. "
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/wasteland/f13bwsettler
	exp_requirements = 0
	exp_type = EXP_TYPE_FALLOUT
	
	loadout_options = list(
	/datum/outfit/loadout/settlermerchant,
	/datum/outfit/loadout/settlerdoc,
	/datum/outfit/loadout/settlerbartender,
	/datum/outfit/loadout/settlerfarmer,
	/datum/outfit/loadout/settlerprospector,
	/datum/outfit/loadout/settlerpoacher,
	/datum/outfit/loadout/settlergambler,
	)
	
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wasteland/f13bwsettler,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wasteland/f13bwsettler,
		),
		/datum/matchmaking_pref/mentor = list(
			/datum/job/wasteland/f13bwsettler,
		),
		/datum/matchmaking_pref/disciple = list(
			/datum/job/wasteland/f13bwsettler,
		),
		/datum/matchmaking_pref/patron = list(
			/datum/job/wasteland/f13bwsettler,
		),
		/datum/matchmaking_pref/protegee = list(
			/datum/job/wasteland/f13bwsettler,
		),
	)

/datum/outfit/job/wasteland/f13bwsettler
	name = "Blackwater Settler"
	jobtype = /datum/job/wasteland/f13bwsettler
	ears = /obj/item/radio/headset/headset_town
	belt = null
	id = /obj/item/card/id/dogtag/town
	backpack = /obj/item/storage/backpack/satchel/explorer
	r_pocket = /obj/item/flashlight/lantern
	l_pocket = /obj/item/radio/headset/headset_bw
	backpack_contents = list(
		/obj/item/storage/bag/money/small/raider = 1,
		)
		

/datum/outfit/job/wasteland/f13bwsettler/pre_equip(mob/living/carbon/human/H)
	. = ..()
	uniform = pick(
		/obj/item/clothing/under/f13/merca,
		/obj/item/clothing/under/f13/cowboyb,
		/obj/item/clothing/under/f13/cowboyg,
		/obj/item/clothing/under/f13/cowboyt,
		/obj/item/clothing/under/f13/doctor,
		/obj/item/clothing/under/f13/settler,
		/obj/item/clothing/under/f13/relaxedwear,
		/obj/item/clothing/under/f13/spring,
		/obj/item/clothing/under/f13/rustic,
		/obj/item/clothing/under/f13/brahmin,
		/obj/item/clothing/under/pants/jeans,
		/obj/item/clothing/under/f13/fashion/cowboy_angeleyes,
		/obj/item/clothing/under/f13/fashion/cowboy_blondie)

	head = pick(
		/obj/item/clothing/head/f13/ranger_hat/tan,
		/obj/item/clothing/head/f13/ranger_hat,
		/obj/item/clothing/head/cowboyhat/white,
		/obj/item/clothing/head/cowboyhat/black,
		/obj/item/clothing/head/cowboyhat,
		/obj/item/clothing/head/helmet/f13/rustedcowboyhat,
		/obj/item/clothing/head/helmet/f13/brahmincowboyhat,
		/obj/item/clothing/head/f13/cowboy,
		/obj/item/clothing/head/helmet/f13/brahmincowboyhat/fashion/cowboy/blondie,
		/obj/item/clothing/head/helmet/f13/brahmincowboyhat/fashion/cowboy,
		/obj/item/clothing/head/helmet/f13/brahmincowboyhat/fashion/scarecrow,
		/obj/item/clothing/head/helmet/f13/vaquerohat,
		/obj/item/clothing/head/helmet/f13/marlowhat,
		/obj/item/clothing/head/fluff/gambler,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/head/f13/stormchaser,
		/obj/item/clothing/head/welding)

	suit = pick(
		/obj/item/clothing/suit/f13/cowboygvest,
		/obj/item/clothing/suit/f13/cowboybvest,
		/obj/item/clothing/neck/mantle/poncho,
		/obj/item/clothing/suit/armor/f13/brahmin_leather_duster/cowboy/blondie,
		/obj/item/clothing/suit/armor/f13/brahmin_leather_duster/cowboy,
		/obj/item/clothing/suit/jacket/leather,
		/obj/item/clothing/suit/f13/duster,
		/obj/item/clothing/suit/toggle/labcoat/f13/wanderer,
		/obj/item/clothing/suit/tailcoat,
		/obj/item/clothing/suit/toggle/lawyer/black,
		/obj/item/clothing/suit/armored/light/tanvest,
		/obj/item/clothing/suit/suspenders,
		/obj/item/clothing/suit/overalls/farmer,
		/obj/item/clothing/suit/armored/light/kit/shoulder,
		/obj/item/clothing/suit/armored/light/kit/punk,
		/obj/item/clothing/suit/armored/light/kit,
		/obj/item/clothing/suit/hooded/cloak/desert)

	shoes = pick(
		/obj/item/clothing/shoes/f13/cowboy,
		/obj/item/clothing/shoes/f13/explorer,
		/obj/item/clothing/shoes/f13/military/fashion/cowboy_boots)


	r_hand = pick(
		/obj/item/gun/ballistic/revolver/hobo/knifegun,
		/obj/item/gun/ballistic/automatic/hobo/zipgun,
		/obj/item/kitchen/knife/butcher,
		/obj/item/gun/ballistic/revolver/police,
		/obj/item/gun/ballistic/revolver/detective,
		/obj/item/shovel,
		/obj/item/shovel/trench,
		/obj/item/hatchet,
		/obj/item/twohanded/fireaxe,
		/obj/item/pickaxe,
		/obj/item/pickaxe/mini)

/datum/outfit/loadout/settlermerchant
	name = "General Trader"
	uniform = /obj/item/clothing/under/f13/merchant
	head = /obj/item/clothing/head/f13/stormchaser
	glasses = /obj/item/clothing/glasses/f13/biker
	r_hand = /obj/item/gun/ballistic/revolver/detective
	l_hand = /obj/item/crowbar/smithedunitool
	backpack_contents =  list(/obj/item/storage/box/vendingmachine = 1,
							/obj/item/storage/bag/money/small/settler = 1,
							/obj/item/ammo_box/c38box = 2,
							/obj/item/storage/keys_set = 1,
							/obj/item/reagent_containers/food/snacks/f13/caravanlunch = 1
							)

/datum/outfit/loadout/settlerdoc
	name = "Barber-Doctor"
	uniform = /obj/item/clothing/under/f13/westender
	gloves = /obj/item/clothing/gloves/color/latex
	neck = /obj/item/clothing/neck/apron/chef
	r_hand = /obj/item/melee/onehanded/straight_razor
	l_hand = /obj/item/cosmetics/haircomb
	backpack_contents =  list(/obj/item/reagent_containers/medspray/synthflesh = 2,
							/obj/item/healthanalyzer = 1,
							/obj/item/reagent_containers/glass/bottle/epinephrine = 2,
							/obj/item/cosmetics/mirror_makeup = 1,
							/obj/item/storage/firstaid/ancient = 1,
							/obj/item/clothing/neck/stethoscope = 1,
							/obj/item/book/granter/trait/midsurgery = 1,
							/obj/item/storage/backpack/duffelbag/med/surgery/primitive = 1
							)

/datum/outfit/loadout/settlerbartender
	name = "Saloon Bartender"
	uniform = /obj/item/clothing/under/f13/bartenderalt
	neck = /obj/item/clothing/neck/apron/bartender 
	suit_store = /obj/item/gun/ballistic/revolver/widowmaker
	r_hand = /obj/item/reagent_containers/food/drinks/shaker 
	l_hand = /obj/item/storage/box/drinkingglasses
	backpack_contents =  list(/obj/item/storage/bag/money/small/wastelander = 1,
							/obj/item/ammo_box/shotgun/improvised = 1,
							/obj/item/ammo_box/shotgun/bean = 1,
							/obj/item/storage/keys_set = 1,
							/obj/item/reagent_containers/food/drinks/flask = 3
							)

/datum/outfit/loadout/settlerfarmer
	name = "Frontier Farmer"
	suit = /obj/item/clothing/suit/overalls/farmer
	head = /obj/item/clothing/head/f13/ranger_hat/tan
	suit_store = /obj/item/gun/ballistic/revolver/caravan_shotgun
	r_hand = /obj/item/hatchet
	l_hand = /obj/item/cultivator/rake
	backpack_contents =  list(/obj/item/pickaxe/mini = 1,
		/obj/item/reagent_containers/glass/bucket/wood = 1,
		/obj/item/reagent_containers/glass/bottle/nutrient/ez = 3,
		/obj/item/storage/bag/plants = 1,
		/obj/item/reagent_containers/spray/pestspray = 1,
		/obj/item/storage/bag/money/small/raider = 1,
		/obj/item/ammo_box/shotgun/improvised = 1,
		/obj/item/brahminbridle = 1,
		/obj/item/brahminsaddle = 1,
		/obj/item/brahminbags = 1,
		/obj/item/seeds/tato = 1,
		/obj/item/seeds/xander = 1,
		/obj/item/seeds/poppy/broc = 1,
		/obj/item/seeds/mutfruit = 1,
		/obj/item/seeds/ambrosia = 1
		)

/datum/outfit/loadout/settlerprospector
	name = "Wasteland Prospector"
	uniform = /obj/item/clothing/under/f13/rustic
	belt = /obj/item/storage/belt/utility/waster 
	glasses = /obj/item/clothing/glasses/welding
	neck = /obj/item/storage/belt/holster/rugged
	r_hand = /obj/item/storage/bag/salvage 
	l_hand = /obj/item/gun/ballistic/revolver/colt357
	backpack_contents =  list(/obj/item/ammo_box/a357 = 1,
		/obj/item/ammo_box/a357box/improvised = 1,
		/obj/item/book/granter/trait/trekking = 1
		)
		
/datum/outfit/loadout/settlerpoacher
	name = "Wasteland Poacher"
	suit = /obj/item/clothing/suit/armored/light/leathersuit
	suit_store = /obj/item/gun/ballistic/automatic/varmint
	r_hand = /obj/item/ammo_box/magazine/m556/rifle/small
	l_hand = /obj/item/melee/onehanded/knife/bowie
	backpack_contents =  list(/obj/item/ammo_box/a556/sport/improvised = 1,
		/obj/item/ammo_box/a357box/improvised = 1,
		/obj/item/book/granter/trait/trekking = 1,
		/obj/item/reagent_containers/food/snacks/meatsalted = 2
		)
		
/datum/outfit/loadout/settlergambler
	name = "Frontier Gambler"
	uniform = /obj/item/clothing/under/f13/densuit
	suit = /obj/item/clothing/suit/armor/f13/brahmin_leather_duster/cowboy 
	head = /obj/item/clothing/head/f13/gambler
	r_hand = /obj/item/gun/ballistic/revolver/detective
	l_hand = /obj/item/storage/bag/money/small/wastelander
	backpack_contents =  list(/obj/item/storage/fancy/cigarettes/cigpack_bigboss  = 1,
		/obj/item/ammo_box/c38box/improvised = 1,
		/obj/item/reagent_containers/food/drinks/flask = 1,
		/obj/item/toy/cards/deck = 1,
		/obj/item/dice = 1
		)


//datum/job/wasteland/f13bwdeputy
	title = "Blackwater Deputy"
	flag = F13BWDEPUTY
	faction = F13CITIZEN
	total_positions = 3
	spawn_positions = 3
	description = "You are a lawman watching over the town of Kebab and Blackwater since the towns fusions. The last Sheriff just retired too, if you feel you can lead, go ahead and takes his place, but you are still under the militia commander."
	supervisors = "the Sherif, but the Militia Commander orders takes priority"
	selection_color = "#dddddd"
	exp_requirements = 0
	exp_type = EXP_TYPE_FALLOUT

	access = list(ACCESS_TOWN_SEC, ACCESS_PUBLIC)
	minimal_access = list(ACCESS_TOWN_SEC, ACCESS_PUBLIC)
	
	outfit = /datum/outfit/job/wasteland/f13bwdeputy

	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wasteland/f13bwdeputy,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wasteland/f13bwdeputy,
		),
	)

/datum/outfit/job/wasteland/f13bwdeputy
	name = "Blackwater Deputy"
	jobtype = /datum/job/wasteland/f13bwdeputy
	head = /obj/item/clothing/head/f13/town/deputy
	id = /obj/item/card/id/dogtag/deputy/kebab
	ears = /obj/item/radio/headset/headset_town
	backpack = /obj/item/storage/backpack/satchel/explorer
	satchel = /obj/item/storage/backpack/satchel/explorer
	belt = /obj/item/storage/belt
	suit = /obj/item/clothing/suit/armor/f13/town/deputy
	neck = /obj/item/storage/belt/holster/rugged/revolver_357
	l_pocket = /obj/item/storage/bag/money/small/settler
	r_pocket = /obj/item/flashlight/lantern
	shoes = /obj/item/clothing/shoes/f13/military/fashion/cowboy_boots
	uniform = /obj/item/clothing/under/f13/cowboyg
	backpack_contents = list(
		/obj/item/restraints/handcuffs = 2,
		/obj/item/ammo_box/a357 = 3,
		/obj/item/melee/onehanded/knife/bowie = 1,
		/obj/item/melee/classic_baton = 1,
		/obj/item/radio/headset/headset_bw = 1,
		)

/datum/outfit/job/wasteland/f13bwdeputy/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_HARD_YARDS, src)

*/


/datum/emote/living/blush
	key = "blush"
	key_third_person = "blushes"
	message = "blushes."

/datum/emote/living/blush/run_emote(mob/user, params)
	. = ..()
	if(. && isipcperson(user))
		do_fake_sparks(5,FALSE,user)

/datum/emote/living/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows to %t."
	restraint_check = TRUE

/datum/emote/living/burp
	key = "burp"
	key_third_person = "burps"
	message = "burps."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cross
	key = "cross"
	key_third_person = "crosses"
	message = "crosses their arms."
	restraint_check = TRUE

/datum/emote/living/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "collapses!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Unconscious(40)

/datum/emote/living/cough
	key = "cough"
	key_third_person = "coughs"
	message = "coughs!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/cough/can_run_emote(mob/user, status_check = TRUE , intentional)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SOOTHED_THROAT))
		return FALSE

/datum/emote/living/dance
	key = "dance"
	key_third_person = "dances"
	message = "dances around happily."
	restraint_check = TRUE

/datum/emote/living/deathgasp
	key = "deathgasp"
	key_third_person = "deathgasps"
	message = "seizes up and falls limp, their eyes dead and lifeless..."
	message_robot = "shudders violently for a moment before falling still, its eyes slowly darkening."
	message_AI = "lets out a flurry of sparks, its screen flickering as its systems slowly halt."
	message_alien = "lets out a waning guttural screech, green blood bubbling from its maw..."
	message_larva = "lets out a sickly hiss of air and falls limply to the floor..."
	message_monkey = "lets out a faint chimper as it collapses and stops moving..."
	message_simple =  "stops moving..."
	stat_allowed = UNCONSCIOUS

/datum/emote/living/deathgasp/run_emote(mob/user, params)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.deathmessage)
		message_simple = S.deathmessage
	. = ..()
	message_simple = initial(message_simple)
	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)
	if(. && isalienadult(user))
		playsound(user.loc, 'sound/voice/hiss6.ogg', 80, 1, 1)

/datum/emote/living/drool
	key = "drool"
	key_third_person = "drools"
	message = "drools."

/datum/emote/living/faint
	key = "faint"
	key_third_person = "faints"
	message = "faints."

/datum/emote/living/faint/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.SetSleeping(200)


/* Fortuna edit: flapping your wings disabled
/datum/emote/living/flap
	key = "flap"
	key_third_person = "flaps"
	message = "flaps their wings."
	restraint_check = TRUE
	var/wing_time = 20

/datum/emote/living/flap/run_emote(mob/user, params)
	. = ..()
	if(. && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/open = FALSE
		if(H.dna.features["wings"] != "None")
			if(H.dna.species.mutant_bodyparts["wingsopen"])
				open = TRUE
				H.CloseWings()
			else
				H.OpenWings()
			addtimer(CALLBACK(H, open ? TYPE_PROC_REF(/mob/living/carbon/human.proc/OpenWings : /mob/living/carbon/human,CloseWings)), wing_time)

/datum/emote/living/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "flaps their wings ANGRILY!"
	restraint_check = TRUE
	wing_time = 10
*/

/datum/emote/living/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."

/datum/emote/living/gag
	key = "gag"
	key_third_person = "gags"
	message = "gags."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "gasps!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "giggles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/glare
	key = "glare"
	key_third_person = "glares"
	message = "glares."
	message_param = "glares at %t."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/grin
	key = "grin"
	key_third_person = "grins"
	message = "grins."

/datum/emote/living/groan
	key = "groan"
	key_third_person = "groans"
	message = "groans!"

/datum/emote/living/grimace
	key = "grimace"
	key_third_person = "grimaces"
	message = "grimaces."

/datum/emote/living/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"
	restraint_check = TRUE

/datum/emote/living/kiss
	key = "kiss"
	key_third_person = "kisses"
	message = "blows a kiss."
	message_param = "blows a kiss to %t."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/audible
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/audible/can_run_emote(mob/living/user, status_check = TRUE)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent && (!C.mind || !C.mind.miming)

/datum/emote/living/audible/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "laughs."

/datum/emote/living/audible/laugh/get_sound(mob/living/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		//power armor laugh track.... spooky
		if(istype(human_user.get_item_by_slot(ITEM_SLOT_OCLOTHING), /obj/item/clothing/suit/armor/f13/power_armor))
			return 'sound/voice/robolaugh.ogg'
		return human_user.dna.species.get_laugh_sound(user)

/datum/emote/living/audible/chitter
	key = "chitter"
	key_third_person = "chitters"
	message = "chitters."

/datum/emote/living/audible/chitter/get_sound(mob/living/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(isinsect(human_user))
			return 'sound/voice/moth/mothchitter.ogg'

/datum/emote/living/look
	key = "look"
	key_third_person = "looks"
	message = "looks."
	message_param = "looks at %t."

/datum/emote/living/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."
	message_param = "nods at %t."

/datum/emote/living/point
	key = "point"
	key_third_person = "points"
	message = "points."
	message_param = "points at %t."
	restraint_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_num_arms() == 0)
			if(H.get_num_legs() != 0)
				message_param = "tries to point at %t with a leg, <span class='userdanger'>falling down</span> in the process!"
				H.DefaultCombatKnockdown(20)
			else
				message_param = "<span class='userdanger'>bumps [user.p_their()] head on the ground</span> trying to motion towards %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	..()

/datum/emote/living/pout
	key = "pout"
	key_third_person = "pouts"
	message = "pouts."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/scowl
	key = "scowl"
	key_third_person = "scowls"
	message = "scowls."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shake
	key = "shake"
	key_third_person = "shakes"
	message = "shakes their head."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shiver
	key = "shiver"
	key_third_person = "shiver"
	message = "shivers."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "sighs."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/sit
	key = "sit"
	key_third_person = "sits"
	message = "sits down."

/datum/emote/living/smile
	key = "smile"
	key_third_person = "smiles"
	message = "smiles."

/datum/emote/living/smirk
	key = "smirk"
	key_third_person = "smirks"
	message = "smirks."

/datum/emote/living/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "grins smugly."

/datum/emote/living/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "sniffs."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/snore
	key = "snore"
	key_third_person = "snores"
	message = "snores."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/stare
	key = "stare"
	key_third_person = "stares"
	message = "stares."
	message_param = "stares at %t."

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "stretches"
	message = "stretches their arms."

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "sulks"
	message = "sulks down sadly."

/datum/emote/living/surrender
	key = "surrender"
	key_third_person = "surrenders"
	message = "puts their hands on their head and falls to the ground, they surrender!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	restraint_check = FALSE
	sound_volume = 80
	sound_vary = FALSE

/datum/emote/living/surrender/get_sound(mob/living/user)
	return 'sound/f13effects/surrender1.ogg'

/datum/emote/living/surrender/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Knockdown(200)
		L.Paralyze(200)

/datum/emote/living/sway
	key = "sway"
	key_third_person = "sways"
	message = "sways around dizzily."

/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "trembles"
	message = "trembles in fear!"

/datum/emote/living/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches violently."

/datum/emote/living/twitch_s
	key = "twitch_s"
	message = "twitches."

/datum/emote/living/wave
	key = "wave"
	key_third_person = "waves"
	message = "waves."

/datum/emote/living/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."

/datum/emote/living/wsmile
	key = "wsmile"
	key_third_person = "wsmiles"
	message = "smiles weakly."

/datum/emote/living/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "yawns."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	message = null

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	if(stop_bad_mime.Find(input, 1, 1))
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
		return TRUE
	return FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null)
	if(jobban_isbanned(user, "emote"))
		to_chat(user, "You cannot send custom emotes (banned).")
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE
	else if(!params)
		var/custom_emote = stripped_multiline_input_or_reflect(user, "Choose an emote to display.", "Custom Emote", null, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable")
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					return
			message = custom_emote
	else
		message = params
		if(type_override)
			emote_type = type_override
	message = user.say_emphasis(message)
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params)
	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	var/datum/emote/E
	var/list/emote_list = E.emote_list
	for(var/e in emote_list)
		if(e in keys)
			continue
		E = emote_list[e]
		if(E.can_run_emote(user, status_check = FALSE))
			keys += E.key

	keys = sortList(keys)

	for(var/emote in keys)
		if(LAZYLEN(message) > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)

/* Fortuna edit: beep disabled
/datum/emote/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/machines/twobeep.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon, /mob/living/carbon/human)
*/

/datum/emote/living/circle
	key = "circle"
	key_third_person = "circles"
	restraint_check = TRUE

/datum/emote/living/circle/run_emote(mob/user, params)
	. = ..()
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>You make a circle with your hand.</span>")
	else
		qdel(N)
		to_chat(user, "<span class='warning'>You don't have any free hands to make a circle with.</span>")

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	restraint_check = TRUE

/datum/emote/living/slap/run_emote(mob/user, params)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>You ready your slapping hand.</span>")
	else
		to_chat(user, "<span class='warning'>You're incapable of slapping in your current state.</span>")

/datum/emote/living/audible/blorble
	key = "blorble"
	key_third_person = "blorbles"
	message = "blorbles."
	message_param = "blorbles at %t."

/datum/emote/living/audible/blorble/run_emote(mob/user, params)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(isjellyperson(C))
			pick(playsound(C, 'sound/effects/attackblob.ogg', 50, 1),playsound(C, 'sound/effects/blobattack.ogg', 50, 1))

/datum/emote/living/audible/blurp
	key = "blurp"
	key_third_person = "blurps"
	message = "blurps."
	message_param = "blurps at %t."

/datum/emote/living/audible/blurp/run_emote(mob/user, params)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(isjellyperson(C))
			pick(playsound(C, 'sound/effects/meatslap.ogg', 50, 1),playsound(C, 'sound/effects/gib_step.ogg', 50, 1))

/datum/emote/living/surrender
	key = "surrender"
	key_third_person = "surrenders"
	message = "puts their hands on their head and falls to the ground, they surrender!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/surrender/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Knockdown(200)

#define EMOTE_SPECIAL_STR "Strength"
#define EMOTE_SPECIAL_PER "Perception"
#define EMOTE_SPECIAL_END "Endurance"
#define EMOTE_SPECIAL_CHA "Charisma"
#define EMOTE_SPECIAL_INT "Intelligence"
#define EMOTE_SPECIAL_AGI "Agility"
#define EMOTE_SPECIAL_LCK "Luck"
#define EMOTE_SPECIAL_GEN "???"
#define EMOTE_SPECIAL_SUF "Crit"

GLOBAL_LIST_INIT(special_skill_list, list(
	EMOTE_SPECIAL_STR,
	EMOTE_SPECIAL_PER,
	EMOTE_SPECIAL_END,
	EMOTE_SPECIAL_CHA,
	EMOTE_SPECIAL_INT,
	EMOTE_SPECIAL_AGI,
	EMOTE_SPECIAL_LCK,
	EMOTE_SPECIAL_GEN))

GLOBAL_LIST_INIT(special_triggers, list(
	EMOTE_SPECIAL_STR = list(
		"s",
		"str",
		"strength",
		"strangth",
		"strong",
		"strongth",
		"might",
		"power"),
	EMOTE_SPECIAL_PER = list(
		"p",
		"per",
		"perception",
		"preception",
		"look",
		"see",
		"peep"),
	EMOTE_SPECIAL_END = list(
		"e",
		"end",
		"endurance",
		"endurence",
		"toughness",
		"tough",
		"grit",
		"beef",
		"beefiness"),
	EMOTE_SPECIAL_CHA = list(
		"c",
		"cha",
		"charisma",
		"charesma",
		"charm",
		"moxie",
		"smarm",
		"wink",
		"char"),
	EMOTE_SPECIAL_INT = list(
		"int",
		"i",
		"intelligence",
		"inteligence",
		"intelligance",
		"inteligance",
		"intel",
		"intell",
		"intelect",
		"intellect",
		"smart",
		"smartness",
		"nerd",
		"nerdiness",
		"dork",
		"dorkiness",
		"dweeb",
		"dweebishness"),
	EMOTE_SPECIAL_AGI = list(
		"agi",
		"a",
		"agility",
		"agillity",
		"quick",
		"quickness",
		"fast",
		"fastness",
		"dex",
		"speed",
		"speediness",
		"athleticism",
		"acrobatics",
		"escape",
		"dodge",
		"evade",
		"evasion",
		"cat"),
	EMOTE_SPECIAL_LCK = list(
		"l",
		"lck",
		"luck",
		"lick",
		"lock",
		"lunk",
		"link",
		"chance",
		"fortune",
		"dice",
		"luk",
		"luc"),
	EMOTE_SPECIAL_GEN = list(
		"x",
		"non",
		"none",
		"generic",
		"something",
		"else",
		"smth",
		"?",
		"rand",
		"huh",
		"stuff",
		"roll")))

GLOBAL_LIST_INIT(special_phrases, list(
	EMOTE_SPECIAL_STR = list(
		"initial" = list(
			"tests their strength...",
			"flexes their arm(s)...",
			"prepares to lift...",
			"puts their back into it..."),
		"success" = list(
			"is strong!",
			"is beefy!",
			"has some serious guns!",
			"had some strength behind it!"),
		"failure" = list(
			"was too weak.",
			"was a little wet noodle.",
			"would loose an arm wrestling match with a mouse.",
			"has some serious atrophy. it's a wonder they can move at all.")),
	EMOTE_SPECIAL_PER = list(
		"initial" = list(
			"takes a good, long look...",
			"squints...",
			"looks around...",
			"focuses in..."),
		"success" = list(
			"was perceptive!",
			"noticed things!",
			"has eyes like a hawk!",
			"could find Doc Mitchell's keys!",
			"noticed whatever they were trying to see!"),
		"failure" = list(
			"was totally oblivious.",
			"forgot their glasses.",
			"didn't see anything.")),
	EMOTE_SPECIAL_END = list(
		"initial" = list(
			"tests their toughness...",
			"braces themself..."),
		"success" = list(
			"was tough!",
			"was one tough cookie!",
			"doesn't even flinch!",
			"is solid as an oak!",
			"endured!"),
		"failure" = list(
			"is a floppy lil' noodle.",
			"is made of paper.",
			"would be torn to shreds by a light breeze.",
			"crumpled up and blew away.")),
	EMOTE_SPECIAL_CHA = list(
		"initial" = list(
			"starts to be charismatic...",
			"puts on the charm..."),
		"success" = list(
			"was charismatic!",
			"is an absolute charmer!",
			"was good and charming!"),
		"failure" = list(
			"was totally uncharismatic.",
			"isn't fooling anyone.",
			"put their foot in their mouth.",
			"could hear a pin drop.",
			"miiiiight have some frontal lobe damage.",
			"had their charms fall flat.")),
	EMOTE_SPECIAL_INT = list(
		"initial" = list(
			"thinks hard...",
			"ponders hard...",
			"takes a moment to think...",
			"furrows their brow..."),
		"success" = list(
			"was clever!",
			"is a genius!",
			"has a mind sharp as a whip!",
			"had a thought!"),
		"failure" = list(
			"was dumb as a doornail.",
			"burned their last braincell years ago.",
			"is running low on braincells.",
			"was dense as a brick.")),
	EMOTE_SPECIAL_AGI = list(
		"initial" = list(
			"tries to get agile...",
			"prepares their moves...",
			"starts to get limber..."),
		"success" = list(
			"was very flexible!",
			"had some excellent footwork!",
			"was in perfect control!",
			"was agile as a cat!",
			"was agile as a fox!"),
		"failure" = list(
			"fell flat on their face.",
			"fell flat on their back.",
			"triped over themself.",
			"has two left feet.",
			"was clumsy as a cat.",
			"was clumsy as a fox.")),
	EMOTE_SPECIAL_LCK = list(
		"initial" = list(
			"tries their luck...",
			"takes a chance...",
			"puts it all on red..."),
		"success" = list(
			"lucked out!",
			"was the luckiest son-of-a-gun in the wasteland!",
			"could make a bullet turn right around and climb back into the gun!",
			"got lucky!"),
		"failure" = list(
			"was unlucky.",
			"realized their game was rigged from the start.",
			"showed that the house always wins.")),
	EMOTE_SPECIAL_GEN = list(
		"initial" = list(
			"tests their skills...",
			"tries their skills...",
			"attempts to do a thing...",
			"puts their skills to the test..."),
		"success" = list(
			"succeeded!",
			"did it!"),
		"failure" = list(
			"was really bad at whatever they did.",
			"just really sucked.",
			"messed up real bad.")),
	EMOTE_SPECIAL_SUF = list(
		"initial" = list(
			"shouldnt see this lol"),
		"success" = list(
			"Ring-a-ding baby!",
			"Wow!"),
		"failure" = list(
			"How could someone mess up so badly?",
			"The game was rigged from the start."))))


/datum/emote/living/special
	key = "special"
	message = null
	cooldown = 2.5 SECONDS // longer than it takes for the emote to run
	stat_allowed = UNCONSCIOUS
	/// Delay between doing the emote and getting the results
	var/special_delay = 2 SECONDS
	/// So keybinds can use these emotes ezpz
	var/special_override

/datum/emote/living/special/s
	key = "special_strength"
	special_override = EMOTE_SPECIAL_STR

/datum/emote/living/special/p
	key = "special_perception"
	special_override = EMOTE_SPECIAL_PER

/datum/emote/living/special/e
	key = "special_endurance"
	special_override = EMOTE_SPECIAL_END

/datum/emote/living/special/c
	key = "special_charisma"
	special_override = EMOTE_SPECIAL_CHA

/datum/emote/living/special/i
	key = "special_intelligence"
	special_override = EMOTE_SPECIAL_INT

/datum/emote/living/special/a
	key = "special_agility"
	special_override = EMOTE_SPECIAL_AGI

/datum/emote/living/special/l
	key = "special_luck"
	special_override = EMOTE_SPECIAL_LCK

/datum/emote/living/special/run_emote(mob/user, params, type_override, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(jobban_isbanned(user, "emote"))	// emote ban
		to_chat(user, "You cannot send emotes (banned).")
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)	// muted
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE

	if(isnull(user.special_a))
		to_chat(user, span_phobia("You arent special."))
		to_chat(user, span_notice("Mainly because you're playing a mob withough any special skills. This is probably a bug~"))
		return FALSE

	var/special_noun = null
	var/special_phrase_input = special_override ? special_override : lowertext(params)

	for(var/which_special in GLOB.special_skill_list)
		/// if the thing we said after the emote is in one of these lists, pick the corresponding key
		if(special_phrase_input in GLOB.special_triggers[which_special])
			special_noun = which_special

	if(!(special_noun in GLOB.special_skill_list) || !special_noun)
		to_chat(user, span_alert("That's not a valid SPECIAL stat!"))
		to_chat(user, span_notice("To use this emote, type '*special' followed by a SPECIAL stat. For instance, '*special luck' will do a (luck*10)% roll and say if you passed or not."))
		var/valid_specials
		for(var/word in GLOB.special_triggers)
			valid_specials += "[GLOB.special_triggers[word][1]], "
			valid_specials += "[GLOB.special_triggers[word][2]]. "
		to_chat(user, span_notice("Some of the valid SPECIAL keywords are:[valid_specials]."))
		return

	var/special_skill = null
	switch(special_noun)
		if(EMOTE_SPECIAL_STR)
			special_skill = user.special_s
		if(EMOTE_SPECIAL_PER)
			special_skill = user.special_p
		if(EMOTE_SPECIAL_END)
			special_skill = user.special_e
		if(EMOTE_SPECIAL_CHA)
			special_skill = user.special_c
		if(EMOTE_SPECIAL_INT)
			special_skill = user.special_i
		if(EMOTE_SPECIAL_AGI)
			special_skill = user.special_a
		if(EMOTE_SPECIAL_LCK)
			special_skill = user.special_l
		if(EMOTE_SPECIAL_GEN) // generic random 50% chance
			special_skill = 5

	var/first_phrase = pick(GLOB.special_phrases[special_noun]["initial"])
	var/message_first = span_notice("\[[special_noun], [special_skill]0%] <b>[user]</b> [first_phrase].")	// [Luck, 100%] User tests their Luck.

	user.visible_message(
		message = message_first,
		self_message = message_first,
		blind_message = message_first)
	user.emote_for_ghost_sight(message_first)

	spawn(special_delay)
		if(!user)
			return
		if(!can_run_emote(user, TRUE,intentional))
			return

		var/message_second
		if(prob(special_skill * 10))
			var/success_phrase = pick(GLOB.special_phrases[special_noun]["success"])
			if(prob(5)) // crit success!
				success_phrase += " [pick(GLOB.special_phrases[EMOTE_SPECIAL_SUF]["success"])]"
			message_second = span_green("\[Success\] <b>[user]</b> [success_phrase]") // [Success] User is pretty lucky!
		else
			var/fail_phrase = pick(GLOB.special_phrases[special_noun]["failure"])
			if(prob(5)) // crit fail!
				fail_phrase += " [pick(GLOB.special_phrases[EMOTE_SPECIAL_SUF]["failure"])]"
			message_second = span_red("\[Failure\] <b>[user]</b> [fail_phrase]") // [Failure} User isn't very lucky...

		user.visible_message(
			message = message_second,
			self_message = message_second,
			blind_message = message_second)
		user.emote_for_ghost_sight(message_second)

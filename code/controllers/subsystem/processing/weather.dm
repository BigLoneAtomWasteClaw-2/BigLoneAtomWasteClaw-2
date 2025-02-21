/*
#define STARTUP_STAGE 1
#define MAIN_STAGE 2
#define WIND_DOWN_STAGE 3
#define END_STAGE 4

//Used for all kinds of weather, ex. lavaland ash storms.
PROCESSING_SUBSYSTEM_DEF(weather)
	name = "Weather"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/eligible_zlevels = list()
	var/list/next_hit_by_zlevel = list() //Used by barometers to know when the next storm is coming
	var/weather_on_start = FALSE

/datum/controller/subsystem/processing/weather/fire()
	. = ..() //Active weather is handled by . = ..() processing subsystem base fire().
	if(COOLDOWN_FINISHED(src, wind_change_cooldown))
		set_wind_direction()
		COOLDOWN_START(src, wind_change_cooldown, rand(5 MINUTES, 15 MINUTES))
	// start random weather on relevant levels - the SAME weather on all those Zs!
	if(weather_queued || !LAZYLEN(weather_rolls))
		return FALSE
	var/datum/weather/W = pickweight(weather_rolls)
	var/randTime = rand(WEATHER_WAIT_MIN, WEATHER_WAIT_MAX)
	timerid = addtimer(CALLBACK(src, PROC_REF(run_weather), W), randTime + initial(W.weather_duration_upper), TIMER_UNIQUE | TIMER_STOPPABLE) //Around 25-30 minutes between weathers
	next_hit_by_zlevel = world.time + randTime + initial(W.telegraph_duration)
	weather_queued = TRUE // weather'll set this to FALSE when it ends

/datum/controller/subsystem/processing/weather/Initialize(start_timeofday)
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		// any weather with a probability set may occur at random
		if (probability)
			for(var/z in SSmapping.levels_by_trait(target_trait))
				LAZYINITLIST(eligible_zlevels["[z]"])
				eligible_zlevels["[z]"][W] = probability
	return ..()

/datum/controller/subsystem/processing/weather/proc/run_weather(datum/weather/weather_datum_type, z_levels, duration)
	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/weather))
			var/datum/weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	if (isnull(z_levels))
		z_levels = SSmapping.levels_by_trait(initial(weather_datum_type.target_trait))
	else if (isnum(z_levels))
		z_levels = list(z_levels)
	else if (!islist(z_levels))
		CRASH("run_weather called with invalid z_levels: [z_levels || "null"]")

	if(duration && !isnum(duration))
		CRASH("run_weather called with invalid duration: [duration || "null"]")

	var/datum/weather/W = new weather_datum_type(z_levels, duration)
	W.telegraph()

/datum/controller/subsystem/processing/weather/proc/make_eligible(z, possible_weather)
	eligible_zlevels[z] = possible_weather
	next_hit_by_zlevel["[z]"] = null

/datum/controller/subsystem/processing/weather/proc/get_weather(z, area/active_area)
	var/datum/weather/A
	for(var/V in processing)
		var/datum/weather/W = V
		if((z in W.impacted_z_levels) && is_path_in_list(active_area.type, W.area_types))
			A = W
			break
	return A
*/

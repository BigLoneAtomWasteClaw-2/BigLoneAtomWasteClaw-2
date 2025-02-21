/datum/component/waddling
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

/datum/component/waddling/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	if(!isnull(amount_to_waddle))
		waddle_amount = amount_to_waddle
	if(!isnull(amount_to_bob_up))
		up_waddle_time = amount_to_bob_up
	if(!isnull(amount_to_bob_side))
		side_waddle_time = amount_to_bob_side
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(Waddle))

/datum/component/waddling/proc/Waddle()
	var/mob/living/L = parent
	if(L.incapacitated() || L.lying)
		return
	animate(L, pixel_z = 4, time = 0)
	animate(pixel_z = 0, transform = turn(matrix(), pick(-12, 0, 12)), time=2)
	animate(pixel_z = 0, transform = matrix(), time = 0)

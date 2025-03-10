/* To use the ref tracking debugging tool in game
1. Enable/uncomment the following before using debug tools on your local machine:

**TESTING

**REFERENCE_TRACKING

**REFERENCE_TRACKING_DEBUG

**GC_FAILURE_HARD_LOOKUP

2. Set return statement of the object you wish to ref track to QDEL_HINT_FINDREFERENCE or QDEL_HINT_IFFAIL_FINDREFERENCE (read qdel.dm for the difference between the two)


3. Start game up on your local machine and delete the object in question. Look at the daemon log for results.

*/

//#define TESTING				
//By using the testing("message") proc you can create debug-feedback for people with this
								//uncommented, but not visible in the release version) 

// Comment this out if you are debugging problems that might be obscured by custom error handling in world/Error
#ifdef DEBUG
#define USE_CUSTOM_ERROR_HANDLER
#endif

#ifdef TESTING

///Used to find the sources of harddels, quite laggy, don't be surpised if it freezes your client for a good while
//#define REFERENCE_TRACKING
#ifdef REFERENCE_TRACKING

///Used for doing dry runs of the reference finder, to test for feature completeness
///Slightly slower, higher in memory. Just not optimal
//#define REFERENCE_TRACKING_DEBUG

///Run a lookup on things hard deleting by default.
//#define GC_FAILURE_HARD_LOOKUP
#ifdef GC_FAILURE_HARD_LOOKUP
///Don't stop when searching, go till you're totally done
#define FIND_REF_NO_CHECK_TICK
#endif //ifdef GC_FAILURE_HARD_LOOKUP

#endif //ifdef REFERENCE_TRACKING

//#define VISUALIZE_ACTIVE_TURFS	//Highlights atmos active turfs in green

#endif //ifdef TESTING
//#define UNIT_TESTS			//If this is uncommented, we do a single run though of the game setup and tear down process with unit tests in between

#ifndef PRELOAD_RSC				//set to:
#define PRELOAD_RSC	2			//	0 to allow using external resources or on-demand behaviour;
#endif							//	1 to use the default behaviour;
								//	2 for preloading absolutely everything;

#ifdef LOWMEMORYMODE
#define FORCE_MAP "_maps/runtimestation.json"
#endif
/*
//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 515
#define MIN_COMPILER_BUILD 1623
#if DM_VERSION < MIN_COMPILER_VERSION || DM_BUILD < MIN_COMPILER_BUILD
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 513.1508 or higher
#endif
*/
//Additional code for the above flags.
#ifdef TESTING
#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif

#ifdef GC_FAILURE_HARD_LOOKUP
//#define FIND_REF_NO_CHECK_TICK
#endif

#ifdef CIBUILDING
#define UNIT_TESTS
#endif

#ifdef CITESTING
#define TESTING
#endif

#ifdef TGS
// TGS performs its own build of dm.exe, but includes a prepended TGS define.
#define CBT
#endif

#ifdef CBT
#define ALL_MAPS
#endif

// A reasonable number of maximum overlays an object needs
// If you think you need more, rethink it
#define MAX_ATOM_OVERLAYS 100

#if !defined(CBT) && !defined(SPACEMAN_DMM)
#warn Building with Dream Maker is no longer supported and will result in errors.
#warn In order to build, run BUILD.bat in the root directory.
#warn Consider switching to VSCode editor instead, where you can press Ctrl+Shift+B to build.
#endif

/*
 *  Author: Dorbedo
 *
 *  Description:
 *      server post init
 *
 */
#include "script_component.hpp"

GVAR(cleaningUp) = false;
GVAR(cleanup_positions) = [];
GVAR(cleanUpDump) = [];
GVAR(cleanUp_waittime) = 120;
GVAR(cleanup_Dump_int) = [];

[QEGVAR(mission,end_server),LINKFUNC(onMissionEnding)] call CBA_fnc_addEventHandler;

[LINKEFUNC(spawn,cleanupHandler) , 5, []] call CBA_fnc_addPerFrameHandler;

[] call FUNC(Army_set);

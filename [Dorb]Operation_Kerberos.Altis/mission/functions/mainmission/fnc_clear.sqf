/*
 *  Author: Dorbedo
 *
 *  Description:
 *      Mission Clear
 *
 *  Parameter(s):
 *      0 : [STRING,ARRAY]  - Destination [Locationname, Position]
 *
 *  Returns:
 *      [CODE,ARRAY] - [Taskhandler conditional function, its arguments]
 *
 */
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

_this params [["_destination",["",[0,0,0]],[["",[]]]]];

private _position = _destination select 1;
private _distance = getNumber(missionConfigFile >> "missions_config" >> "main" >> "clear" >> "location" >> "distance");

[_position,"clear",_distance] call EFUNC(spawn,spawnMissionTarget);

private _clearradius = getNumber(missionConfigFile >> "missions_config" >> "main" >> "clear" >> "radius");
private _unitamount = getNumber(missionConfigFile >> "missions_config" >> "main" >> "clear" >> "unitamount");

[QFUNC(mainmission_clear_cond),[_position,_clearradius,_unitamount]]

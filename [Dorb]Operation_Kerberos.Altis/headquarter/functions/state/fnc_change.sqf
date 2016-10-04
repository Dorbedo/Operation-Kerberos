/*
    Author: Dorbedo

    Description:
        changes the state of a group

    Parameter(s):
        0 : Group - <GROUP>
        1 : Statement to be called after finishing the waypoint <STRING>

    Returns:
        none
*/
#include "script_component.hpp"
_this params[["_group",grpNull,[grpNull,objNull]],["_statementFinish","",[""]]];

_group = _group call CBA_fnc_getGroup;

private _grouphash = _group getVariable "grouphash";
/// update the strenght if the unit received some losses or if the unit lost the vehicle
private _strenghtArray = (_group call FUNC(strengthAI)) params ["_GroupType","_value","_thread"];
HASH_SET(_grouphash,"type",_GroupType);
HASH_SET(_grouphash,"value",_value);
HASH_SET(_grouphash,"thread",_thread);

private _state = HASH_GET(_grouphash,"state");

switch (_state) do {
    case "patrol" : {
            private _formation = selectRandom ["COLUMN","STAG COLUMN","WEDGE","VEE","FILE","DIAMOND"];
            private _position = HAST_GET(_grouphash,"target");
            If (isNil "_position") then {_position = getPos (leader _group)};
            [_group, _position, "AWARE", "WHITE", "NORMAL", "NO CHANGE", "", [5,10,15],50] call EFUNC(spawn,patrol_task);
        };
    default {[_group,_statementFinish] call (missionnamespace getVariable [format["%1_%2",QGVAR(fnc_state),_state],{}]);};
};

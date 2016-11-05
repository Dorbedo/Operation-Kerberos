/*
 *  Author: Dorbedo
 *
 *  Description:
 *      uses armored-attack
 *
 *  Parameter(s):
 *      0 : LOCATION - Attackposition
 *      0 : LOCATION - strategyhash
 *
 *  Returns:
 *      none
 *
 */
#include "script_component.hpp"


_this params ["_currentLocation","_strategyHash"];

private _attackgroups = HASH_GET(GVAR(groups),"attackGroups");
private _availableGroups = [];

{
    private _hash = _x getVariable QGVAR(grouphash);
    private _state = HASH_GET(_hash,"state");
    private _type = HASH_GET(_hash,"type");
    If ((_state in ["idle","wait"])&&(_type == 1)) then {
        _availableGroups pushBack _x;
    };
} forEach _attackgroups;

//_availableGroups = _availableGroups call BIS_fnc_arrayShuffle;

CHECK(_availableGroups isEqualTo [])

private _chosenOne = selectRandom _availableGroups;

private _statementFinish = QUOTE(this call FUNC(strategy__onFinishSAD););

[_chosenOne,"attack",_currentLocation,_statementFinish] call FUNC(state_set);

private _grouphash = _chosenOne getVariable QGVAR(grouphash);
HASH_SET(_groupHash,"strategy",_strategyHash);

private _vehicle = vehicle(leader _chosenOne);

[_vehicle];

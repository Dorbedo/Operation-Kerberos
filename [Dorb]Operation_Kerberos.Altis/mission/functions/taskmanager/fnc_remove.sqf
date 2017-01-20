/*
    Author: iJesuz

    Description:
        Deletes a Task

    Parameter(s):
        0 : NUMBER OR [NUMBER,NUMBER]  - TaskNumber

    Return:
        -

*/
#include "script_component.hpp"

_this params [["_number",-1,[0,[]]]];

private "_taskID";
if (typeName _number == typeName []) then {
    _taskID = format ["%1_%2_side_%3",QGVAR(task),_number select 0,_number select 1];
} else {
    _taskID = format ["%1_%2",QGVAR(task),_number];
};

{
    private _args = _x select 1;

    if (typeName _number == typeName []) then {
        if (typeName _args == typeName [] && {_args isEqualTo _number}) then {
            GVAR(conditions) = GVAR(conditions) - [_x];
        };
    } else {
        if (typeName _args == typeName 0 && {_args == _number}) then {
            GVAR(conditions) = GVAR(conditions) - [_x];
        };
    };
} forEach +GVAR(conditions);

[_taskID] call BIS_fnc_deleteTask;
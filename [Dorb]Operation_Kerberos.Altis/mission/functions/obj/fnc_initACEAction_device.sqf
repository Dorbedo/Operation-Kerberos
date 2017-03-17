/*
 *  Author: iJesuz
 *
 *  Description:
 *      init ace actions for device
 *      (it's called once from clientPostInit)
 *
 *  Parameter(s):
 *      -
 *
 *  Returns:
 *      -
 */
#include "script_component.hpp"

private _action = [
    QGVAR(disableDevice),
    localize LSTRING(OBJECTS_DEVICE_DISABLE),
    "",
    {
        [
            5,
            [_target],
            { (_this select 0) call FUNC(obj__increaseCounter); },
            {},
            LSTRING(OBJECTS_DEVICE_DISABLING)
        ] call ace_common_fnc_progressBar;
    },
    { (_this select 0) getVariable [QGVAR(isActive), false]; }
] call ace_interact_menu_fnc_createAction;

private _classes = ["device"] call FUNC(getObjects);
_classes pushBack (["emp"] call FUNC(getObjects));
TRACEV_1(_classes);

{
    [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToClass;
} forEach _classes;

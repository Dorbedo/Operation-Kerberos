/*
    Author: Dorbedo
    
    Description:
        initialization for logistics
*/
#include "script_component.hpp"
CHECK(isHeadless)
CHECK(!isClass(missionconfigFile >> "logistics"))

ISNILS(EGVAR(player,respawn_fnc),[]);
EGVAR(player,respawn_fnc) pushBack QUOTE(player setVariable [ARR_2('GVAR(isloading)',false)];);

private _cfgLog = missionconfigFile >> "logistics" >> "vehicles";
private _loadAction = [QGVAR(action_load), localize LSTRING(ACTION_LOAD), "", {[_target] spawn FUNC(doload);}, {[_target] call FUNC(canload);}] call ace_interact_menu_fnc_createAction;
private _unloadAction = [QGVAR(action_unload), localize LSTRING(ACTION_UNLOAD), "", {[_target] spawn FUNC(dounload);}, {  [_target] call FUNC(canUnload);  }] call ace_interact_menu_fnc_createAction;
private _infoAction = [QGVAR(action_info), localize LSTRING(ACTION_DISP_CARGO),"",{[_target] spawn FUNC(disp_cargo);},{true}] call ace_interact_menu_fnc_createAction;
private _paraAction = [QGVAR(action_paradrop), localize LSTRING(ACTION_PARADROP), "", {[_target,true] spawn FUNC(dounload);}, {[_target] call FUNC(candrop);}] call ace_interact_menu_fnc_createAction;

[localize ELSTRING(main,name), QGVAR(keybind_g), [localize LSTRING(ACTION_PARADROP), localize LSTRING(ACTION_PARADROP)], { if ([vehicle player] call FUNC(candrop)) then { [vehicle player,true] spawn FUNC(dounload)}; }, {true}, [0x22, [false, false, false]], false] call CBA_fnc_addKeybind;

for "_i" from 0 to ((count _cfgLog)-1) do {
    private _vehicle = configname(_cfgLog select _i);
    If (isClass(configFile >> "cfgvehicles" >> _vehicle)) then {
        private _canLoad = ( getnumber(missionconfigFile >> "logistics" >> "vehicles" >> _vehicle >> "max_length") ) > 0;
        private _canPara = ((( getnumber(missionconfigFile >> "logistics" >> "vehicles" >> _vehicle >> "max_length") ) > 0)&&(_vehicle isKindOf "Air"));
        If (_canLoad) then {
            [_vehicle, 0, ["ACE_MainActions"], _loadAction] call ace_interact_menu_fnc_addActionToClass;
            [_vehicle, 0, ["ACE_MainActions"], _unloadAction] call ace_interact_menu_fnc_addActionToClass;
            [_vehicle, 0, ["ACE_MainActions"], _infoAction] call ace_interact_menu_fnc_addActionToClass;
            [_vehicle, 1, ["ACE_SelfActions"], _infoAction] call ace_interact_menu_fnc_addActionToClass;
            If (_canPara) then {
                [_vehicle, 1, ["ACE_SelfActions"], _paraAction] call ace_interact_menu_fnc_addActionToClass;
            };
            
        };
    };
};
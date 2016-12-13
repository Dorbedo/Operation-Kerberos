/*
    Author: Dorbedo

    Description:
        postinit server
*/
#include "script_component.hpp"

GVAR(handles) = HASH_CREATE;
private "_handle";

["medical_onUnconscious", {
    _this params ["_unit", "_status"];
    if ((isplayer _unit)&&(_status)) then {
        [_unit] call FUNC(player_unconscious);
    };
}] call ace_common_fnc_addEventHandler;
/*************************
*
*       waypoints
*
************************/
GVAR(waypoints) = HASH_CREATE;

/*************************
*
*           FDC
*
*************************/
GVAR(FDC) = HASH_CREATE;
HASH_SET(GVAR(FDC),"mortars",[]);
HASH_SET(GVAR(FDC),"artilleries",[]);
HASH_SET(GVAR(FDC),"rockets",[]);

_handle = [{_this call FUNC(fdc_handle)},INTERVALL_FDC,[]] call CBA_fnc_addPerFrameHandler;
HASH_SET(GVAR(handles),"fdc_main",_handle);
_handle = [{_this call FUNC(fdc_defend_artypos)},INTERVALL_SEARCH,[]] call CBA_fnc_addPerFrameHandler;
HASH_SET(GVAR(handles),"fdc_defend",_handle);
/*************************
*
*       Anti Air
*
*************************/
GVAR(antiair) = HASH_CREATE;
HASH_SET(GVAR(antiair),"mobile",[]);
HASH_SET(GVAR(antiair),"static",[]);
/*************************
*
*       Headquarter
*
*************************/
GVAR(active) = false;
GVAR(handle) = scriptNull;

/// ressources
GVAR(ressources_amount) = 0;


/// groups - player & ai
GVAR(groups) = HASH_CREATE;
HASH_SET(GVAR(groups),"playergroups",[]);
GVAR(playergroups_new) = 0;

/// radars
GVAR(radars) = CREATE_HASH;
HASH_SET(GVAR(radars),"objects",[]);
HASH_SET(GVAR(radars),"targets",[]);

/// POI
GVAR(dangerzones) = HASH_CREATE;
HASH_SET(GVAR(dangerzones),"definitions",[ARR_3(2000,125,16)]);
HASH_SET(GVAR(dangerzones),"gridsize",125);
HASH_SET(GVAR(dangerzones),"distance",2000);

/// Strategy
GVAR(strategy_memory) = HASH_SERIALIZE(GETPRVAR(GVAR(strategy_memory),HASH_CREATE));

/// AttaclPos
GVAR(attackpos) = HASH_CREATE;

/// Handles
_handle = [{_this call FUNC(handle)},INTERVALL_HQ,[]] call CBA_fnc_addPerFrameHandler;
HASH_SET(GVAR(handles),"main",_handle);
_handle = [{_this call FUNC(check_radars)},INTERVALL_RADARS,[]] call CBA_fnc_addPerFrameHandler;
HASH_SET(GVAR(handles),"radars",_handle);
_handle = [{_this call FUNC(handlePlayerGroups);},INTERVALL_PLAYERGROUPS,[]] call CBA_fnc_addPerFrameHandler;
HASH_SET(GVAR(handles),"playergroups",_handle);
_handle = [{_this call FUNC(handleAA);},INTERVALL_AA,[]] call CBA_fnc_addPerFrameHandler;
HASH_SET(GVAR(handles),"antiair",_handle);


/// Events
[QEGVAR(mission,start),{GVAR(active) = true;_this call FUNC(MissionInit);}] call CBA_fnc_addEventHandler;
[QEGVAR(mission,end),{GVAR(active) = false;_this call FUNC(MissionCleanUp);}] call CBA_fnc_addEventHandler;
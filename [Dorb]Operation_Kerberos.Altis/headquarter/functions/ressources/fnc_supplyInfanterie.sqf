/*
 *  Author: Dorbedo
 *
 *  Description:
 *      supplys with Infantry
 *
 *  Parameter(s):
 *      none
 *
 *  Returns:
 *      SCALAR - costs
 *
 */
#include "script_component.hpp"

private _centerpos = HASH_GET(GVAR(dangerzones),"centerpos");

private _transporttype = ["transporter_lorry"] call EFUNC(spawn,getUnit);
private _spawnPos = [_centerpos,_transporttype] call FUNC(ressources_getsaveSpawnPos);

([_spawnPos,GVARMAIN(side),_transporttype] call EFUNC(spawn,vehicle)) params ["_transportGroup","_transportVehicle"];

private _groupType = ["group_infantry"] call EFUNC(spawn,getUnit);
private _newGroup = [_spawnpos, _grouptype] call EFUNC(spawn,group);

{
    _x assignAsCargo _transportVehicle;
    _x moveInCargo _transportVehicle;
}forEach units _newGroup;

_transportGroup addWaypoint [_centerpos,200];
_transportVehicle doMove _centerpos;

[
    {
        (_this select 0) params ["_transportGroup","_newGroup","_centerpos","_transportVehicle","_spawnPos"];
        If (((_transportVehicle distance _centerpos) > 400)&&(canMove _transportVehicle)) exitWith {};
        [_this select 1] call CBA_fnc_removePerFrameHandler;

        {
            unassignVehicle (_x);
            moveOut _x;
        } forEach (units _newGroup);
        [_newGroup,"attack"] call FUNC(registerGroup);
        [_newGroup,"idle",getPos (leader _newGroup)] call FUNC(state_set);

        If (canMove _transportVehicle) then {
            [_transportGroup] call CBA_fnc_clearWaypoints;
            [_transportGroup,_spawnPos,200,"MOVE","SAFE","WHITE","FULL"] call CBA_fnc_addWaypoint;
            _transportVehicle domove _spawnpos;
            [
                {
                    (_this select 0) params ["_transporter","_spawnpos"];
                    If (((_transporter distance _spawnpos) > 200)&&(canMove _transportVehicle)) exitWith {};
                    [_this select 1] call CBA_fnc_removePerFrameHandler;
                    {deletevehicle _x} foreach crew _transporter;
                    deletevehicle _transporter;
                },
                30,
                [_transporter,_spawnPos]
            ] call CBA_fnc_addPerFrameHandler;
        }else{
            private _defendPos = getPos (selectrandom (HASH_GET(GVAR(POI),"Locations")));
            [_transportGroup,"defend"] call FUNC(registerGroup);
            [_newGroup,"idle",_defendPos] call FUNC(state_set);
        };
    },
    10,
    [_transportGroup,_newGroup,_centerpos,_transportVehicle,_spawnPos]
] call CBA_fnc_addPerFrameHandler;

(([_newGroup] call FUNC(strenghtAi)) param [1,0]);

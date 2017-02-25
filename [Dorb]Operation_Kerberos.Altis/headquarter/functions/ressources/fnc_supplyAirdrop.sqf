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

private _spawnPos = [_centerpos,4000,4000,10000] call FUNC(ressources_getsavespawnposair);

_spawnPos set [2,400];
private _transporttype = ["transporter_airdrop"] call EFUNC(spawn,getUnit);
if (_transporttype isEqualTo []) exitWith {0};
([_spawnPos,GVARMAIN(side),_transporttype] call EFUNC(spawn,vehicle)) params ["_transportGroup","_transportVehicle"];

_transportVehicle setpos [_spawnpos];
_transportVehicle flyInHeight 400;
_transportVehicle setSpeedMode "FULL";
_transportVehicle setBehaviour "CARELESS";



private _groupType = ["group_airdrop"] call EFUNC(spawn,getUnit);
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
            _x enableAI "Move";
            unassignVehicle (_x);
            _x allowDamage false;
            moveOut _x;
            sleep 0.2;
            _fallschirm = createVehicle ["NonSteerable_Parachute_F",(getPos _x), [], 0, "FLY"];
            _x moveInDriver _fallschirm;
            sleep 0.2;
            _x allowDamage true;
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
                    If (((_transporter distance2D _spawnpos) > 400)&&(canMove _transportVehicle)) exitWith {};
                    [_this select 1] call CBA_fnc_removePerFrameHandler;
                    {deletevehicle _x} foreach crew _transporter;
                    deletevehicle _transporter;
                },
                30,
                [_transporter,_spawnPos]
            ] call CBA_fnc_addPerFrameHandler;
        }else{
            {deletevehicle _x} foreach units _transportGroup;
        };
    },
    10,
    [_transportGroup,_newGroup,_centerpos,_transportVehicle,_spawnPos]
] call CBA_fnc_addPerFrameHandler;

(([_newGroup] call FUNC(strenghtAi)) param [1,0]);

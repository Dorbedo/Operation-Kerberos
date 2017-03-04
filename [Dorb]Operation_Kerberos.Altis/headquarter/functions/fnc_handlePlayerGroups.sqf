/*
 *  Author: Dorbedo
 *
 *  Description:
 *      updates the strength of the playergroups
 *      gets the values over time to prevent smaller attacks if the units moved out of a vehicle
 *
 *  Parameter(s):
 *      none
 *
 *  Returns:
 *      none
 *
 */
#define DEBUG_MODE_FULL
#include "script_component.hpp"

(_this select 0) params[["_fullCheck",false,[true]]];

private _allPlayerGroups = allGroups select {side _x == GVARMAIN(playerside)};
private _playergrouphashes = HASH_GET(GVAR(groups),"playergroups");
//TRACEV_3(_this,_allPlayerGroups,_playergrouphashes);
If !((count _allPlayerGroups)==(count _playergrouphashes)) then {
    _fullCheck = true;
};

If ((!(IS_ARRAY(GVAR(playergroups_new))))&&{GVAR(playergroups_new) < CBA_missiontime}) then {
    _fullCheck = true;
};

If (_fullCheck) then {
    GVAR(playergroups_new) = [];
    {
        private _group = _x;
        private _grouphash = _group getVariable QGVAR(grouphash);
        If (isNil "_grouphash") then {
            [_group] call FUNC(registerPlayerGroup);
        };
        GVAR(playergroups_new) pushBackUnique _grouphash;
        private _strengthArray = (_group call FUNC(strengthPlayer)) params ["_GroupType","_value","_threat"];

        private _temphistory = (HASH_GET(_grouphash,"typehistory"));
        If (count _temphistory >= 10) then {_temphistory deleteAt 0;};
        _temphistory pushBack _GroupType;
        HASH_SET(_grouphash,"typehistory",_temphistory);
        private _GroupType = (_temphistory call CBA_fnc_findMax) select 0;
        HASH_SET(_grouphash,"type",_GroupType);


        private _temphistory = (HASH_GET(_grouphash,"valuehistory"));
        If (count _temphistory >= 10) then {_temphistory deleteAt 0;};
        _temphistory pushBack _value;
        HASH_SET(_grouphash,"valuehistory",_temphistory);
        private _value = [_temphistory] call EFUNC(common,arithmeticMean);
        HASH_SET(_grouphash,"value",_value);


        private _temphistory = (HASH_GET(_grouphash,"threathistory"));
        If (count _temphistory >= 10) then {_temphistory deleteAt 0;};
        _temphistory pushBack _threat;
        HASH_SET(_grouphash,"threathistory",_temphistory);
        private _tempThreatA = [];
        private _tempThreatB = [];
        private _tempThreatC = [];
        {
            _tempThreatA pushBack (_x select 0);
            _tempThreatB pushBack (_x select 1);
            _tempThreatC pushBack (_x select 2);
        } forEach _temphistory;
        private _tempThreatA = (_tempThreatA call CBA_fnc_findMax) select 0;
        private _tempThreatB = (_tempThreatB call CBA_fnc_findMax) select 0;
        private _tempThreatC = (_tempThreatC call CBA_fnc_findMax) select 0;
        _threat = [_tempThreatA,_tempThreatB,_tempThreatC];
        HASH_SET(_grouphash,"threat",_threat);
        #ifdef DEBUG_MODE_FULL
            If !(isNil "dorb_grouptestvalue") then {
                dorb_grouptestvalue params ["_GroupType","_value","_threat"];
                HASH_SET(_grouphash,"type",_GroupType);
                HASH_SET(_grouphash,"value",_value);
                HASH_SET(_grouphash,"threat",_threat);
                TRACE("Setting debug Values");
            };
        #endif
    } forEach _allPlayerGroups;

    HASH_SET(GVAR(groups),"playergroups",GVAR(playergroups_new));
    GVAR(playergroups_new) = CBA_missiontime + DEF_PLAYERGROUPCHECKINTERVALL;
};

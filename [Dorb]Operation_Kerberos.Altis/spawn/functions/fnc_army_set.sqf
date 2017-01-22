/*
 *  Author: Dorbedo
 *
 *  Description:
 *      chooses the army
 *
 *  Parameter(s):
 *      0 : STRING  - armytype (optional)
 *
 *  Returns:
 *      none
 *
 */
//#define DEBUG_MODE_FULL
#include "script_component.hpp"

if (isNil QGVARMAIN(side)) then {
    GVARMAIN(side) = switch (GVARMAIN(playerside)) do {
        case "east" : {"west"};
        default {"east"};
    };
};

_this params [["_army","",[""]]];
If ((_army isEqualTo "")||{!isClass(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> _army)}) then {
    private _allArmys = configProperties [(missionConfigFile >> "unitlists" >> str GVARMAIN(side)),"true",true];
    _army = configName (selectRandom(_allArmys));
    GVARMAIN(side_type) = _army;
}else{
    GVARMAIN(side_type) = _army;
};

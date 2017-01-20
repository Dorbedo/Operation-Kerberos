/*
 *  Author: Dorbedo
 *
 *  Description:
 *      gets a random unit
 *
 *  Parameter(s):
 *      0 : STRING - Unittype
 *
 *  Returns:
 *      STRING - classname of a unit
 *
 */
#include "script_component.hpp"

_this params [["_type","",[""]]];
CHECK(_type isEqualTo "")

switch _type do {
    case "intel" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "intel");
        selectRandom _allObjects;
    };
    case "weaponcache" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "weaponcache");
        selectRandom _allObjects;
    };
    case "hostage" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "pow");
        selectRandom _allObjects;
    };
    case "capture" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "commander");
        selectRandom _allObjects;
    };
    case "device" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "device");
        selectRandom _allObjects;
    };
    case "emp" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "emp");
        selectRandom _allObjects;
    };
    case "dronecommando" : {
        private _allObjects = getArray(missionConfigFile >> "unitlists" >> str GVARMAIN(side) >> GVARMAIN(side_type) >> "mission" >> "hq_mobile");
        selectRandom _allObjects;
    };
    default {ERROR(FORMAT_1("Missing entrie: %1",_this))};
};
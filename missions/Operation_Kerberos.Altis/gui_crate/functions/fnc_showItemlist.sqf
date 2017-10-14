/**
 * Author: Dorbedo
 * fills the itemlist
 *
 * Arguments:
 * 0: <CONTROL> the itemlist to be filled
 * 1: <ARRAY> the list
 *
 * Return Value:
 * Nothing
 *
 */

#include "script_component.hpp"

params ["_ctrl",["_list",[],[[]]]];

lnbClear _ctrl;
{
    private _configString = _x;
    HASH_GET(GVAR(libary),_x) params ["_modpicture","_getMod","_picture","_displayname"];
    private _curIndex = _ctrl lnbAddRow ["",_modname,"",_displayname,[_configString] call FUNC(getCurAmount)];
    _ctrl lnbSetPicture [[_curIndex,0],_modPicture];
    _ctrl lnbSetPictureColor [[_curIndex,0],[1,1,1,1]];
    _ctrl lnbSetPicture [[_curIndex,2],_Picture];
    _ctrl lnbSetPictureColor [[_curIndex,2],[1,1,1,1]];
    _ctrl lnbSetData [[_curIndex,0],_configString];
} count _list;

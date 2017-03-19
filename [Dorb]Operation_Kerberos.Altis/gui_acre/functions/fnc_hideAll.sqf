/*
 *  Author: Dorbedo
 *
 *  Description:
 *      [Description]
 *
 *  Parameter(s):
 *      0 : [TYPE] - [argument name]
 *
 *  Returns:
 *      [TYPE] - [return name]
 *
 */
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
disableSerialization;
private _display = uiNamespace getVariable QEGVAR(gui_Echidna,dialog);
{
    _x params ["_idc",["_handler",[],[[]]]];
    private _ctrl = _display displayCtrl _idc;
    _ctrl ctrlsetPosition [0,0,0,0];
    _ctrl ctrlCommit 0;
    {
        _ctrl ctrlRemoveAllEventHandlers _x;
    }forEach _handler;
} forEach [
    [IDC_ACRE_MENU_ITEMLIST,["LBDrop"]],
    [IDC_ACRE_MENU_RADIOLIST,["LBDrop","LBSelChanged"]],
    [IDC_ACRE_MENU_TREE,["TreeSelChanged"]],
    [IDC_ACRE_MENU_PROPERTIESLIST],
    [IDC_ACRE_MENU_PROPERTIES]
];
private _header = _display displayCtrl IDC_ACRE_MENU_HEADER;
_header ctrlsetText "";

ISNILS(GVAR(tempProperties),[]);
{ctrlDelete _x;} forEach GVAR(tempProperties);

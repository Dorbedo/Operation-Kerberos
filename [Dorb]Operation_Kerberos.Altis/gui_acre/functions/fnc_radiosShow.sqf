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
#define INCLUDE_GUI
#include "script_component.hpp"
disableSerialization;

_this params ["_target"];
GVAR(curSelIndex) = -1;
GVAR(radioSettingsTarget) = _target;

// hide all other things
[] call FUNC(hideAll);

// get the tree and the propertiesList
private _display = uiNamespace getVariable QEGVAR(gui_Echidna,dialog);
private _itemlist = _display displayCtrl IDC_ACRE_MENU_ITEMLIST;
private _radiolist = _display displayCtrl IDC_ACRE_MENU_RADIOLIST;
private _properties = _display displayCtrl IDC_ACRE_MENU_PROPERTIES;
private _back1 = _display displayCtrl IDC_ACRE_MENU_BACK_1;
private _back2 = _display displayCtrl IDC_ACRE_MENU_BACK_2;
private _back3 = _display displayCtrl IDC_ACRE_MENU_BACK_3;
private _properties_combo = _properties controlsGroupCtrl IDC_ACRE_MENU_PROPERTIES_COMBO;

lbClear _itemlist;
lbClear _radiolist;

_back1 ctrlSetPosition [
    GUI_ECHIDNA_X + 5.5*GUI_ECHIDNA_W,
    GUI_ECHIDNA_Y + 2.5*GUI_ECHIDNA_H,
    5*GUI_ECHIDNA_W,
    24.5*GUI_ECHIDNA_H
];
_itemlist ctrlSetPosition [
    GUI_ECHIDNA_X + 5.5*GUI_ECHIDNA_W,
    GUI_ECHIDNA_Y + 2.5*GUI_ECHIDNA_H,
    5*GUI_ECHIDNA_W,
    24.5*GUI_ECHIDNA_H
];

_back2 ctrlSetPosition [
    GUI_ECHIDNA_X + 11*GUI_ECHIDNA_W,
    GUI_ECHIDNA_Y + 2.5*GUI_ECHIDNA_H,
    10*GUI_ECHIDNA_W,
    24.5*GUI_ECHIDNA_H
];
_radiolist ctrlSetPosition [
    GUI_ECHIDNA_X + 11.5*GUI_ECHIDNA_W,
    GUI_ECHIDNA_Y + 3*GUI_ECHIDNA_H,
    9*GUI_ECHIDNA_W,
    23.5*GUI_ECHIDNA_H
];

_back3 ctrlSetPosition [
    GUI_ECHIDNA_X + 21.5*GUI_ECHIDNA_W,
    GUI_ECHIDNA_Y + 2.5*GUI_ECHIDNA_H,
    18*GUI_ECHIDNA_W,
    20.5*GUI_ECHIDNA_H
];
_properties ctrlSetPosition [
    GUI_ECHIDNA_X + 22*GUI_ECHIDNA_W,
    GUI_ECHIDNA_Y + 3*GUI_ECHIDNA_H,
    17*GUI_ECHIDNA_W,
    19.5*GUI_ECHIDNA_H
];


_properties_combo ctrlSetPosition [
    GUI_ECHIDNA_W,
    GUI_ECHIDNA_H,
    15.5*GUI_ECHIDNA_W,
    1*GUI_ECHIDNA_H
];

private _pos_x = GUI_ECHIDNA_X + 36.5*GUI_ECHIDNA_W;
private _pos_y = GUI_ECHIDNA_Y + 24*GUI_ECHIDNA_H;
private _pos_w = GUI_ECHIDNA_W*3;
private _pos_h = GUI_ECHIDNA_H*3;
private _picture = "a3\ui_f\data\igui\cfg\simpletasks\types\upload_ca.paa";
private _displayName = localize LSTRING(RADIOS_TRANSMITT);
private _ctrl = _display displayCtrl IDC_ACRE_MENU_BTTN6;
_ctrl ctrlAddEventHandler ["ButtonClick",{[player] call FUNC(transmitt);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

_back1 ctrlCommit 0;
_back2 ctrlCommit 0;
_back3 ctrlCommit 0;
_itemlist ctrlCommit 0;
_radiolist ctrlCommit 0;
_properties ctrlCommit 0;
_properties_combo ctrlCommit 0;
_ctrl ctrlCommit 0;

_itemlist ctrladdEventHandler ["LBDrop",{_this call FUNC(radiosDrop)}];
_radiolist ctrladdEventHandler ["LBDrop",{_this call FUNC(radiosDrop)}];
_radiolist ctrlAddEventHandler ["LBSelChanged",{GVAR(curSelIndex) = _this select 1;[GVAR(curSelIndex)] call FUNC(radiosProperties);}];
_properties_combo ctrlAddEventHandler ["LBSelChanged",{_this call FUNC(radiosPropertiesUpdate);}];


{
    private _radioHash = HASH_GET(GVAR(radioTypeList),_x);
    private _picture = HASH_GET(_radioHash,"picture");
    private _description = HASH_GET(_radioHash,"displayname");
    TRACEV_3(_radioHash,_picture,_description);
    private _index = _itemlist lbAdd "";
    _itemlist lbSetPicture [_index, _picture];
    _itemlist lbSetTooltip [_index, _description];
    _itemlist lbSetData [_index, _x];
} forEach HASH_KEYS(GVAR(radioTypeList));

GVAR(tempRadioList) = (_target getVariable [QGVAR(radios),[]]) select {!(isNull _x)};

[] call FUNC(radiosList);

[GVAR(curSelIndex)] call FUNC(radiosProperties);
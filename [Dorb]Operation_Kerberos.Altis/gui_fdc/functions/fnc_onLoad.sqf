/*
 *  Author: [Name of Author(s)]
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
_this params ["_display"];


// a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa
// a3\ui_f\data\gui\cfg\communicationmenu\cas_ca.paa

// a3\ui_f\data\gui\cfg\hints\artillerycall_ca.paa
// a3\ui_f\data\gui\cfg\hints\callsupport_ca.paa
// a3\ui_f\data\gui\cfg\hints\rules_ca.paa
// a3\ui_f\data\gui\cfg\hints\map_ca.paa
// a3\ui_f\data\gui\cfg\hints\tasks_ca.paa
// a3\ui_f\data\gui\cfg\hints\zeroing_ca.paa

// a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa

// a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_clear_ca.paa



private _pos_x = GUI_ECHIDNA_X;
private _pos_y = GUI_ECHIDNA_Y;
private _pos_w = GUI_ECHIDNA_W*2;
private _pos_h = GUI_ECHIDNA_H*2;

// order Assistent
private _picture = "\a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_clear_ca.paa";
private _displayName = localize LSTRING(MENU_NEWORDER);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_1;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(newOrder);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

// order List
private _pos_x = GUI_ECHIDNA_X + GUI_ECHIDNA_W * 2;
private _picture = "\a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
private _displayName = localize LSTRING(MENU_NEWPOSITION);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_2;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(newPosition);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

// target List
private _pos_x = GUI_ECHIDNA_X + GUI_ECHIDNA_W * 4;
private _picture = "\a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
private _displayName = localize LSTRING(MENU_NEWPOSITION);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_2;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(newPosition);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

// Artillery List
private _pos_x = GUI_ECHIDNA_X + GUI_ECHIDNA_W * 6;
private _picture = "\a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
private _displayName = localize LSTRING(MENU_NEWPOSITION);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_2;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(newPosition);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

// Illumination Plan
private _pos_x = GUI_ECHIDNA_X + GUI_ECHIDNA_W * 8;
private _picture = "\a3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa";
private _displayName = localize LSTRING(MENU_NEWPOSITION);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_2;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(newPosition);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

private _background1 = _dialog displayCtrl IDC_FDC_MAIN_BTTN_BACK_1;
_background1 ctrlSetPosition [
    _pos_x + _pos_w,
    _pos_y,
    (_pos_x + _pos_w) - GUI_ECHIDNA_X,
    _pos_h
];
_background1 ctrlCommit 0;




/*
 *  Right side
 */



private _pos_x = GUI_ECHIDNA_X + GUI_ECHIDNA_W*38;
private _pos_y = GUI_ECHIDNA_Y;
private _pos_w = GUI_ECHIDNA_W*2;
private _pos_h = GUI_ECHIDNA_H*2;
// Info
private _picture = "\a3\ui_f\data\gui\cfg\hints\rules_ca.paa";
private _displayName = localize LSTRING(MENU_INFO);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_2;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(showInfo);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

// Own Artillery
private _pos_x = _pos_x - _pos_w;
private _picture = "\a3\ui_f\data\gui\cfg\hints\rules_ca.paa";
private _displayName = localize LSTRING(MENU_INFO);
private _ctrl = _dialog displayCtrl IDC_FDC_MAIN_BTTN_2;
_ctrl ctrlAddEventHandler ["ButtonClick",{_this call FUNC(showInfo);true}];
["changepos",[_ctrl,[_pos_x, _pos_y, _pos_w, _pos_h]]] call FUNC(AnimBttn);
_ctrl ctrlSetText _picture;
_ctrl ctrlSetTooltip _displayName;
_ctrl ctrlSetFontHeight (GUI_ECHIDNA_METRO_BTTN_H * 0.1);
_ctrl ctrlSetTextColor [1,1,1,1];

private _background1 = _dialog displayCtrl IDC_FDC_MAIN_BTTN_BACK_2;
_background2 ctrlSetPosition [
    _pos_x,
    _pos_y,
    GUI_ECHIDNA_X*40 - _pos_x,
    _pos_h
];
_background2 ctrlCommit 0;


















//

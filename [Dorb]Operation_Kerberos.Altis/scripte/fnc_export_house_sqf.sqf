/*
    Author: Dorbedo

    Rotation nach DIN 8855
        1. Gier
        2. Nick
        3. Wank


    Call via:
        [cursorTarget,25] execVM "fnc_export_obj_sqf.sqf";


    class Housename_randomnumber {
        housetype = "Classname";
        material[] = {  {classname,position,direction,offset,vectorUp}  };
        vehicles[] = {  {classname,position,direction,offset,vectorUp}  };        //static and vehicles
        soldier[] = {  {classname,position,direction,offset,vectorUp}  };
    };
*/

_this params[["_haus",objNull,[objNull]],["_radius",25,[0]]];
hint "Export in progess....";
If (isNull _haus) exitWith {hint "No Object";};
private _haustyp = typeOf _haus;
private _hauspos = getPosASL _haus;

private _alleobjekte = _haus nearObjects [["CAManBase","Static","LandVehicle","Air","Ship"],_radius];
private _exportarray = [];


private _fnc_rotiereVektor2D = {
    _this params ["_vektor","_dir"];
    private _return = +(_vektor);
    _return set [0, (cos _dir)*(_vektor select 0) - (sin _dir)*(_vektor select 1)];
    _return set [1, (sin _dir)*(_vektor select 0) - (cos _dir)*(_vektor select 1)];
    _return;
};

private _fnc_getObjWankNickGier = {
    _this params ["_object"];

    private _objectVDir = VectorDir _object;
    private _objectVUp = VectorUp _object;
    private _Gierwinkel = (getDir _object) mod 360;

    private _vdir = [_vdir,_Gierwinkel] call _fnc_rotiereVektor2D;
    private _vup = [_vup, _Gierwinkel] call _fnc_rotiereVektor2D;

    private _vupZ = _vup select 2;
    private _vdirY = (_vdir select 1);

    If (_vdirY == 0) then {_vdirY=0.01;};
    if (_vupZ == 0) then {_vupZ = 0.01;};

    private _Nickwinkel = atan ((_vdir select 2) / _vdirY);
    private _Wankwinkel = atan ((_vup select 0) / _vupZ);
    if((_vup select 2) < 0) then {
        _Wankwinkel = _Wankwinkel - ([1,-1] select (_Wankwinkel < 0)) * 180;
    };

    [_Wankwinkel,_Nickwinkel,_Gierwinkel];
};

([_haus] call _fnc_getObjWankNickGier) params ["_haus_Wank","_haus_Nick","_haus_Gier"];


private _fnc_getObjTransl = {
    _this params ["_object"];
    ([_object] call _fnc_getObjWankNickGier) params ["_obj_Wank","_obj_Nick","_obj_Gier"];

    private _W = (_obj_Wank + _haus_Wank) mod 360;
    private _N = (_obj_Nick + _haus_Nick) mod 360;
    private _G = (_obj_Gier + _haus_Gier) mod 360;

    // Gimbal Lock
    If (_N mod 90 == 0) then {_N = _N + 0.01;};

    [
        [cos _N * cos _G,                              cos _N * cos _G,                             -1 * sin _N     ],
        [sin _W * sin _N * cos _G - cos _W * sin _G,    sin _W * sin _N * sin _G + cos _W * cos _G,   sin _W * cos _N  ],
        [cos _W * sin _N * cos _G + sin _W * sin _G,    cos _W * sin _N * sin _G - sin _W * cos _G,   cos _W * cos _W  ]
    ];

};



{
    private _temp = []
    If !(isPlayer _x) then {
        private _currentObject = _x;

        private _currenttype = typeOf _currentObject;
        private _currentPos = getPosASL _currentObject;
        private _temppos = _hauspos vectorDiff _currentPos;

        private _currentTransMat = [_currentObject] call _fnc_getObjTransl;

        _temp = [_currenttype,_temppos,_currentTransMat];
    };
    If !(_temp isEqualTo []) then {
        _exportArray pushBack _temp;
    };
}forEach _alleobjekte;


private _export_vehicles = [];
private _export_soldier = [];
private _export_material = [];
private _export_targets = [];

{
    If ((_x select 0) isKindOf "Land_CargoBox_V1_F") then {
        _export_targets pushBack _x;
    }else{
        if ((_x select 0) isKindOf "LandVehicle") then {
            _export_vehicles pushBack _x;
        }else{
            If ((_x select 0) isKindOf "Man") then {
                _export_soldier pushBack _x;
            }else{
                _export_material pushBack _x;
            };
        };
    };
}forEach _exportarray;


private _br = toString [0x0D, 0x0A];
private _tab = "    "; // changed into spaces - toString[0x09];
private _tab2 = _tab + _tab;
private _tab3 = _tab2 + _tab;

private _output = _tab2 + format["class %1_ver%2 {",_haustyp,floor(random 99999)] + _br
+ _tab3 + format["housetype = ""%1"";",_haustyp] + _br
+ _tab3 + "material[] = {";
If ((count(_export_material))>0) then {
    _i=0;
    _output = _output + format["{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_material select _i)select 0),(((_export_material select _i)select 1)select 0),(((_export_material select _i)select 1)select 1),(((_export_material select _i)select 1)select 2),((((_export_material select _i)select 2)select 0)select 0),((((_export_material select _i)select 2)select 0)select 1),((((_export_material select _i)select 2)select 0)select 2),((((_export_material select _i)select 2)select 1)select 0),((((_export_material select _i)select 2)select 1)select 1),((((_export_material select _i)select 2)select 1)select 2),((((_export_material select _i)select 2)select 2)select 0),((((_export_material select _i)select 2)select 2)select 1),((((_export_material select _i)select 2)select 2)select 2)];
    For "_i" from 1 to (count _export_material -1) do {
        _output = _output + format[",{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_material select _i)select 0),(((_export_material select _i)select 1)select 0),(((_export_material select _i)select 1)select 1),(((_export_material select _i)select 1)select 2),((((_export_material select _i)select 2)select 0)select 0),((((_export_material select _i)select 2)select 0)select 1),((((_export_material select _i)select 2)select 0)select 2),((((_export_material select _i)select 2)select 1)select 0),((((_export_material select _i)select 2)select 1)select 1),((((_export_material select _i)select 2)select 1)select 2),((((_export_material select _i)select 2)select 2)select 0),((((_export_material select _i)select 2)select 2)select 1),((((_export_material select _i)select 2)select 2)select 2)];
    };
};
_output = _output + "};" + _br
+ _tab3 + "vehicles[] = {";
If ((count(_export_vehicles))>0) then {
    _i=0;
    _output = _output + format["{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_vehicles select _i)select 0),(((_export_vehicles select _i)select 1)select 0),(((_export_vehicles select _i)select 1)select 1),(((_export_vehicles select _i)select 1)select 2),((((_export_vehicles select _i)select 2)select 0)select 0),((((_export_vehicles select _i)select 2)select 0)select 1),((((_export_vehicles select _i)select 2)select 0)select 2),((((_export_vehicles select _i)select 2)select 1)select 0),((((_export_vehicles select _i)select 2)select 1)select 1),((((_export_vehicles select _i)select 2)select 1)select 2),((((_export_vehicles select _i)select 2)select 2)select 0),((((_export_vehicles select _i)select 2)select 2)select 1),((((_export_vehicles select _i)select 2)select 2)select 2)];
    For "_i" from 1 to (count _export_vehicles -1) do {
        _output = _output + format[",{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_vehicles select _i)select 0),(((_export_vehicles select _i)select 1)select 0),(((_export_vehicles select _i)select 1)select 1),(((_export_vehicles select _i)select 1)select 2),((((_export_vehicles select _i)select 2)select 0)select 0),((((_export_vehicles select _i)select 2)select 0)select 1),((((_export_vehicles select _i)select 2)select 0)select 2),((((_export_vehicles select _i)select 2)select 1)select 0),((((_export_vehicles select _i)select 2)select 1)select 1),((((_export_vehicles select _i)select 2)select 1)select 2),((((_export_vehicles select _i)select 2)select 2)select 0),((((_export_vehicles select _i)select 2)select 2)select 1),((((_export_vehicles select _i)select 2)select 2)select 2)];
    };
};
_output = _output + "};" + _br
+ _tab3 + "soldiers[] = {";
If ((count(_export_soldier))>0) then {
    _i=0;
    _output = _output + format["{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_soldier select _i)select 0),(((_export_soldier select _i)select 1)select 0),(((_export_soldier select _i)select 1)select 1),(((_export_soldier select _i)select 1)select 2),((((_export_soldier select _i)select 2)select 0)select 0),((((_export_soldier select _i)select 2)select 0)select 1),((((_export_soldier select _i)select 2)select 0)select 2),((((_export_soldier select _i)select 2)select 1)select 0),((((_export_soldier select _i)select 2)select 1)select 1),((((_export_soldier select _i)select 2)select 1)select 2),((((_export_soldier select _i)select 2)select 2)select 0),((((_export_soldier select _i)select 2)select 2)select 1),((((_export_soldier select _i)select 2)select 2)select 2)];
    For "_i" from 1 to (count _export_soldier -1) do {
        _output = _output + format[",{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_soldier select _i)select 0),(((_export_soldier select _i)select 1)select 0),(((_export_soldier select _i)select 1)select 1),(((_export_soldier select _i)select 1)select 2),((((_export_soldier select _i)select 2)select 0)select 0),((((_export_soldier select _i)select 2)select 0)select 1),((((_export_soldier select _i)select 2)select 0)select 2),((((_export_soldier select _i)select 2)select 1)select 0),((((_export_soldier select _i)select 2)select 1)select 1),((((_export_soldier select _i)select 2)select 1)select 2),((((_export_soldier select _i)select 2)select 2)select 0),((((_export_soldier select _i)select 2)select 2)select 1),((((_export_soldier select _i)select 2)select 2)select 2)];
    };
};
_output = _output + "};" + _br
+ _tab3 + "targets[] = {";
If ((count(_export_targets))>0) then {
    _i=0;
    _output = _output + format["{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_targets select _i)select 0),(((_export_targets select _i)select 1)select 0),(((_export_targets select _i)select 1)select 1),(((_export_targets select _i)select 1)select 2),((((_export_targets select _i)select 2)select 0)select 0),((((_export_targets select _i)select 2)select 0)select 1),((((_export_targets select _i)select 2)select 0)select 2),((((_export_targets select _i)select 2)select 1)select 0),((((_export_targets select _i)select 2)select 1)select 1),((((_export_targets select _i)select 2)select 1)select 2),((((_export_targets select _i)select 2)select 2)select 0),((((_export_targets select _i)select 2)select 2)select 1),((((_export_targets select _i)select 2)select 2)select 2)];
    For "_i" from 1 to (count _export_targets -1) do {
        _output = _output + format[",{%1,{%2,%3,%4},{{%5,%6,%7},{%8,%9,%10},{%11,%12,%13}}}",((_export_targets select _i)select 0),(((_export_targets select _i)select 1)select 0),(((_export_targets select _i)select 1)select 1),(((_export_targets select _i)select 1)select 2),((((_export_targets select _i)select 2)select 0)select 0),((((_export_targets select _i)select 2)select 0)select 1),((((_export_targets select _i)select 2)select 0)select 2),((((_export_targets select _i)select 2)select 1)select 0),((((_export_targets select _i)select 2)select 1)select 1),((((_export_targets select _i)select 2)select 1)select 2),((((_export_targets select _i)select 2)select 2)select 0),((((_export_targets select _i)select 2)select 2)select 1),((((_export_targets select _i)select 2)select 2)select 2)];
    };
};
_output = _output + "};" + _br + _tab2 + "};" + _br;


copyToClipboard _output;
uisleep 3;
hint "copied to clipboard";
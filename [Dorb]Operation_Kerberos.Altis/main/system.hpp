/*
 *  Author: Dorbedo
 *
 *  Description:
 *      This feature is the main compiling system. It adds security featrues
 *      therefore no more manipulation via config shoould be possible
 *
 *      DON'T MODIFY (unless you understand what this is doing)
 *
 *  Version: 2.0
 *
 */
#define CBA_OFF
#define COMPONENT SYSTEM
#include "script_component.hpp"

/*
    Name: dorb_system_fnc_compile

    Author: Dorbedo - Version 1.0

    Description:
        main compiling function
        adds header to functions
        adds functions to functionfviewer
        adds recompilingprevention

    Parameter(s):
        0: STRING - path to function file
        1: STRING - functionsname
        2: SCALAR - add the debug-header (default: 0 - MINIMAL; 1: SMALL; 2: MAPPING)

    Return
        nil
*/
class system {

    compile = QUOTE( \
        private _fnc_scriptName = 'Main compiling function'; \
        scriptName _fnc_scriptName; \
        _this params [ARR_3([ARR_3('_path','',[''])],[ARR_3('_funcName','',[''])],[ARR_3('_headertype',0,[1])])]; \
        If (isClass(configFile>>'cfgPatches'>>'cba_cache_disable')) then { \
            [ARR_5(missionNamespace,_funcName,_path,_headertype,true)] call (parsingNamespace getVariable 'TRIPLES(PREFIX,SYSTEM,compile_sys)'); \
            with parsingNamespace do { \
                If (isNil 'GVARMAIN(recompileCache)') then {GVARMAIN(recompileCache) = [];}; \
                GVARMAIN(recompileCache) pushBackUnique [ARR_3(_path,_funcName,_headertype)]; \
                diag_log text format [ARR_2('[MissionFile] (System) compiling: %1',[ARR_3(_path,_funcName,_headertype)])]; \
            }; \
        }else{ \
            private _cache = uiNamespace getVariable _funcName; \
            if (isNil '_cache') then { \
                [ARR_4(uiNamespace,_funcName,_path,_headertype)] call (parsingNamespace getVariable 'TRIPLES(PREFIX,SYSTEM,compile_sys)'); \
                missionNamespace setVariable [ARR_2(_funcName, uiNamespace getVariable _funcName)]; \
            }else{ \
                missionNamespace setVariable [ARR_2(_funcName,_cache)]; \
            }; \
        }; \
        nil;);

    recompile = QUOTE( \
        private _fnc_scriptName = 'Recompiling function'; \
        scriptName _fnc_scriptName; \
        systemChat 'recompiling started'; \
        { \
            _x params [ARR_3('_path','_funcName','_headertype')]; \
            diag_log text format [ARR_2('[MissionFile] (System) recompiling: %1',[ARR_3(_path,_funcName,_headertype)])]; \
            [ARR_5(missionNamespace,_funcName,_path,_headertype,true)] call (parsingNamespace getVariable 'TRIPLES(PREFIX,SYSTEM,compile_sys)'); \
        } forEach (parsingNamespace getVariable [ARR_2('GVARMAIN(recompileCache)',[])]); \
        systemChat 'recompiling finished'; \
        );

    recompilecomponent = QUOTE( \
        private _fnc_scriptName = 'Recompiling function'; \
        scriptName _fnc_scriptName; \
        _this params [[ARR_3('_componentName','',[''])]]; \
        If (_componentName isEqualTo '') exitWith {}; \
        private _searchString = _componentName + '_fnc_'; \
        systemChat format[ARR_2('recompiling component: %1 started',_componentName)]; \
        { \
            _x params [ARR_3('_path','_funcName','_headertype')]; \
            If ((_funcName find _searchString)==0) then { \
                diag_log text format [ARR_2('[MissionFile] (System) recompiling: %1',[ARR_3(_path,_funcName,_headertype)])]; \
                [ARR_5(missionNamespace,_funcName,_path,_headertype,true)] call (parsingNamespace getVariable 'TRIPLES(PREFIX,SYSTEM,compile_sys)'); \
            }; \
        } forEach (parsingNamespace getVariable [ARR_2('GVARMAIN(recompileCache)',[])]); \
        systemChat format[ARR_2('recompiling component: %1 finished',_componentName)]; \
        );

    compile_sys = QUOTE( \
        private _fnc_scriptName = 'Compiling SyS'; \
        scriptName _fnc_scriptName; \
        _this params [ARR_5('_namespace','_funcName','_pathstring','_headertype','_recompile')]; \
        private _headerstring = switch (_headertype) do { \
            case 2 : {format [ARR_2('private _fnc_scriptNameParent = If (!isNil ''_fnc_scriptName'') then {_fnc_scriptName}else{''%1''};private _fnc_scriptName = ''%1'';scriptName _fnc_scriptName;',_funcName)];}; \
            case 3 : {format [ARR_2('private _fnc_scriptNameParent = If (!isNil ''_fnc_scriptName'') then {_fnc_scriptName}else{''%1''};private _fnc_scriptName = ''%1'';scriptName _fnc_scriptName; private _fnc_scriptMap = if !(isnil ''_fnc_scriptMap'') then {_fnc_scriptMap + [''%1'']} else {[''%1'']};',_funcName)];}; \
            case 0 : {''''}; \
            default {format [ARR_2('private _fnc_scriptName = ''%1'';scriptName _fnc_scriptName;',_funcName)];};}; \
        If (_recompile) exitWith {_namespace setVariable [ARR_2(_funcName,compile (_headerstring + preprocessFileLineNumbers _pathstring))];}; \
        private _metadata = [ARR_3(_funcName,_pathstring,_headertype)]; \
        private _cache = uiNamespace getVariable format[ARR_2('%1_meta',_funcName)]; \
        If (isNil '_cache') exitWith {uiNamespace setVariable [ARR_2(format[ARR_2('%1_meta',_funcName)],compilefinal str _metadata)];_namespace setVariable [ARR_2(_funcName,compilefinal (_headerstring + preprocessFileLineNumbers _pathstring))];}; \
        If !((((call _cache) select 0) isEqualTo (_metadata select 0))||(((call _cache) select 1) isEqualTo (_metadata select 1))) exitWith {diag_log text '[MissionFile] (System) Compiling Violation'; call FUNCSYS(kick);}; \
        _namespace setVariable [ARR_2(_funcName,compilefinal (_headerstring + preprocessFileLineNumbers _pathstring))];);

    kick = QUOTE( \
        [] spawn { \
            If (!hasInterface) exitWith {}; \
            diag_log text '[MissionFile] kicking player due to critical violation'; \
            waitUntil {!isNil 'BIS_fnc_init'}; \
            waituntil {!(IsNull (findDisplay 46))}; \
            findDisplay 46 closeDisplay 0; \
        }; \
        );

    compile_check = QUOTE( \
        private _fnc_scriptName = 'Compiling Check'; \
        scriptName _fnc_scriptName; \
        private _error = false; \
        private _fnc_compile_cacheSys = parsingnamespace getVariable 'TRIPLES(PREFIX,SYSTEM,compile_sys)'; \
        private _fnc_compile_cache = parsingnamespace getVariable 'TRIPLES(PREFIX,SYSTEM,compile)'; \
        If !(isNil '_fnc_compile_cache') then { \
            private _tempFnc = compile getText(missionConfigFile>>'system'>>'compile'); \
            If !((str _tempFnc) isEqualTo (str _fnc_compile_cache)) then {_error = true;}; \
        }; \
        If !(isNil '_fnc_compile_cacheSys') then { \
            private _tempFnc = compile getText(missionConfigFile>>'system'>>'compile_sys'); \
            If !((str _tempFnc) isEqualTo (str _fnc_compile_cacheSys)) then {_error = true;}; \
        }; \
        If (_error) then { \
            diag_log text '[MissionFile] (System) Compiling system check failed'; \
            If (isMultiplayer) then {[] call compile getText(missionConfigFile>>'system'>>'kick');}; \
        }else{ \
            diag_log text '[MissionFile] (System) Compiling system check finished without errors'; \
        }; \
        );

};

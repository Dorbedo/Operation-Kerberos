#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"dorb_common","dorb_spawn"};
        author = ECSTRING(main,BrigTeam);
        authors[] = {"Dorbedo"};
        url = ECSTRING(main,URL);
        VERSION_CONFIG;
    };
};

#include "CfgEventhandlers.hpp"

class CfgKerberos {
    class CfgComposition {
        class compositions {
            #include "config\compositions.hpp"
        };
        class houses {
            #include "config\houses.hpp"
        };
        class missionhouses {
            #include "config\missionhouses.hpp"
        };
        class missioncompositions {
            #include "config\missioncompositions.hpp"
        };
    };
};

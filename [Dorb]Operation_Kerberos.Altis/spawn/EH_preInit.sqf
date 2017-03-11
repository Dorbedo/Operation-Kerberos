
#include "script_component.hpp"

ADDON = false;

PREP(army_set);

PREP(cleanup_base);
PREP(cleanup_full);
PREP(createMinefields);
PREP(createMission);
PREP(createMissionComposition);
PREP(createMissionHouse);
PREP(createMissionTarget);
PREP(crew);

PREP(delaySpawn);

PREP(gear);
PREP(getGroup);
PREP(getMissionObject);
PREP(getRoadsInArea);
PREP(getUnit);
PREP(group);
PREP(groupFromArray);

PREP(onHit);
PREP(onMissionEnding);
PREP(onMissionStart);

PREP(patrol_task);

PREP(spawnCivCarGarage);
PREP(spawnCivVehRoadside);
PREP(spawnExplosive);
PREP(spawnGroup_attack);
PREP(spawnGroup_defence);
PREP(spawnGroup_patrol);
PREP(spawnMinefieldACE);
PREP(spawnRoadIEDs);
PREP(stayInVehicle);

PREP(unitLimit);
PREP(unit);

PREP(vehicle);

PREPS(composition,chooseComposition);
PREPS(composition,chooseHouse);
PREPS(composition,createFromHouse);
PREPS(composition,createFromPosition);
PREPS(composition,hasCrew);
PREPS(composition,helperRoad);
PREPS(composition,exportHouse);
PREPS(composition,exportPosition);
PREPS(composition,exportToHpp);
PREPS(composition,issimpleobject);
PREPS(composition,onFiredNear);
PREPS(composition,spawnComposition);
PREPS(composition,spawnHouse);

PREPS(fallback,createBuildingsLib);
PREPS(fallback,fortifyBuildings);
PREPS(fallback,patrolBuildings);
PREPS(fallback,roadsInArea);
PREPS(fallback,spawnDoorMines);
PREPS(fallback,spawnExplosives);
PREPS(fallback,spawnStatic);
PREPS(fallback,spawnUnit);

PREPS(mission,capture);
PREPS(mission,clear);
PREPS(mission,device);
PREPS(mission,dronecommando);
PREPS(mission,emp);
PREPS(mission,hostage);
PREPS(mission,intel);
PREPS(mission,prototype);
PREPS(mission,radar);
PREPS(mission,radiotower);
PREPS(mission,scarab);
PREPS(mission,specops);
PREPS(mission,weaponcache);

PREPS(sidemission,artillery);
PREPS(sidemission,radar);

PREPS(water,createPatrols);
PREPS(water,minefield);
PREPS(water,patrol);

ADDON = true;

GVAR(SpawnLast) = CBA_missiontime;
GVAR(targetHouses) = [];
GVAR(usedHouses) = [];
GVAR(spawnedCompositions) = [];
GVAR(cleanUpDump) = [];


	sleep 2;

	//[] call BIS_fnc_animViewer;

	call compilefinal preprocessFileLineNumbers "oo_infected.sqf";
	
	private ["_group"];
	_group = creategroup civilian;

	{
		if(side _x != west) then {
			[_x] joinsilent _group;
			_zombie = ["new", _x] call OO_INFECTED;
			"monitor" spawn _zombie;
		};
	}foreach allunits;	

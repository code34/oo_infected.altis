	/*
	Author: code34 nicolas_boiteux@yahoo.fr
	Copyright (C) 2014-2018 Nicolas BOITEUX

	CLASS OO_INFECTED
	
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>. 
	*/

	#include "oop.h"

	CLASS("OO_INFECTED")
		PRIVATE VARIABLE("object","zombie");
		PRIVATE VARIABLE("object","target");

		PUBLIC FUNCTION("object","constructor") {
			DEBUG(#, "OO_INFECTED::constructor")
			MEMBER("zombie", _this);
			MEMBER("setInventory", _this);
		};

		PUBLIC FUNCTION("object","setInventory") {
			DEBUG(#, "OO_INFECTED::setInventory")
			removeallweapons _this;
			removeAllAssignedItems _this;
			removeBackpack _this;
			_this setdammage (random 1);

			if(random 1 > 0.5) then {removeGoggles _this;};
			if(random 1 > 0.5) then {removeHeadgear _this;};
			if(random 1 > 0.5) then {removeVest _this;};
			if(random 1 > 0.5) then {removeUniform _this;};
		};

		PUBLIC FUNCTION("", "monitor") {
			DEBUG(#, "OO_INFECTED::monitor")
			private _zombie = MEMBER("zombie", nil);
			private _targets = [];

			while { alive _zombie} do {
				_targets = MEMBER("scanTarget", nil);
				if(count _targets > 0) then {
					MEMBER("defineTarget", _targets);
					MEMBER("killTarget", nil);
					MEMBER("eat", nil);
				};
				sleep 1;
			};
			sleep 60;
			MEMBER("deconstructor", nil);
		};

		PUBLIC FUNCTION("", "scanTarget") {
			DEBUG(#, "OO_INFECTED::scanTarget")
			private _targets = [];
			private_zombie = MEMBER("zombie", nil);
			private _list = nearestObjects [_zombie, ["MAN"], 200];
			sleep 1;
			{
				if(isplayer _x) then {
					_targets = _targets + [_x];
				};
			}foreach _list;
			_targets;
		};

		PUBLIC FUNCTION("array", "defineTarget") {
			DEBUG(#, "OO_INFECTED::defineTarget")
			private _targets = _this;
			private _min = -1;
			private _temp = 0;
			private _target = objNull;
			{
				_temp = MEMBER("zombie", nil) knowsAbout _x;
				if(_temp > _min) then {
					_min = _temp;
					_target = _x;
				};
			}foreach _targets;
			MEMBER("target", _target);
		};

		PUBLIC FUNCTION("", "killTarget") {
			DEBUG(#, "OO_INFECTED::killTarget")
			private _run = true;
			private _target =MEMBER("target", nil);
			private _zombie = MEMBER("zombie", nil);
			(group _zombie) setSpeedMode "FULL";
			(group _zombie) setCombatMode "BLUE";
			(group _zombie) setBehaviour "CARELESS";

			_zombie addEventHandler ['HandleDamage', {
				private _damage = damage(_this select 0);
				if(_this select 1 == "head") then {
					if((_this select 2) > 1) then {
						(_this select 0) setdammage 1;
					};
				} else {
					if((_this select 2) < 2) then {
						false;
					};
				};
			}];

			while { _run } do {
				if(!alive _target) then { _run = false;};
				if(!alive _zombie) then { _run = false;};
				MEMBER("moveTo", nil);
				if(_zombie distance _target < 2) then {
					MEMBER("attack", nil);
				};
				if(_zombie distance _target > 200) then {
					_run = false;
				};
				_zombie setFatigue 0;
				sleep 1;
			};
		};

		PUBLIC FUNCTION("", "moveTo") {
			DEBUG(#, "OO_INFECTED::moveTo")
			MEMBER("zombie", nil) domove getposatl MEMBER("target", nil);
		};

		PUBLIC FUNCTION("", "attack") {
			DEBUG(#, "OO_INFECTED::attack")
			MEMBER("zombie", nil) dowatch MEMBER("target", nil);
			MEMBER("zombie", nil) switchMove "AwopPercMstpSgthWnonDnon_end";
			MEMBER("zombie", nil) say format["zomb%1", round random (6)];
			private _damage = getdammage MEMBER("target", nil);
			MEMBER("target", nil) setdammage ( _damage+ random 1);
		};			

		PUBLIC FUNCTION("", "eat") {
			DEBUG(#, "OO_INFECTED::eat")
			MEMBER("zombie", nil) dowatch MEMBER("target", nil);
			MEMBER("zombie", nil) switchMove "AmovPercMstpSnonWnonDnon_Scared";
			sleep 0.5;
		};

		PUBLIC FUNCTION("","deconstructor") { 
			DEBUG(#, "OO_INFECTED::deconstructor")
			deletevehicle MEMBER("zombie", nil);
			DELETE_VARIABLE("zombie");
			DELETE_VARIABLE("run");
		};
	ENDCLASS;
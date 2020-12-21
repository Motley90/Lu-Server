/* 
    Before running:
remove all server side pickups and vehicles! 

This is a outdated backup of Darbytown. It's the only copy that could be recovered.

Use at risk

please remove java bassed arrays array(GetmaxPlayers(), val)

player ID starts at 0 so we can't use tables as is for the player.  

Update Vector system. It was a fast version I made. The sphere just hits every freaking index. And you have to understand that the first vector is the spawnpos
as will the starting sphere. I never made it jump at the time. But mostly set vehicle positions. I just assumed as I tested. 

The race functions are odd. I set them to auto work with each other. If that stays the same it needs to be updated and left as a tool. 

Attempt to add eight spawn positions


Add race type. Single player. Go to random positions. Add barrel races to piss off the players
CreateObject( 1344, Vector( x, y, z ) );

these are explosive type anyway. I'm going to make the area really tight. If I can detect there distance of hitting it I will use create explosion at the sight of impact.
Every freaking barrel could explode. I can't find the cone ID so I will use this for now

*/

local white = Colour(255, 255, 255)
local red = Colour(255, 0, 0)
local green = Colour(0, 255, 0)
local blue = Colour(0, 0, 255)
local grey = Colour(25, 25, 25)
local Deaths = array(GetMaxPlayers(), 0);
local Kills = array(GetMaxPlayers(), 0);
local TimesKilled = array(GetMaxPlayers(), 0);
local RaceCheckpoint = array(GetMaxPlayers(), 0)

local SpawnWeapons = [
  0,    // Fist (always 0)
  1,    // Bat
  30,   // Colt 45
  30,   // Uzi
  10,   // Shotgun
  60,   // AK-47
  0,    // M16
  0,    // Sniper Rifle
  0,    // Rocket Launcher
  0,    // Flamethrower
  0,    // Molotov
  1     // Grenade
];

local HealthCap = array(GetMaxPlayers(), 25);
local HealthLevel = [
  25,   // Default spawn level
  50,   // 50 Kills
  75,   // 75 Kills
  100   // 100 Kills
];


function onScriptLoad() {

  SetServerRule("Owner", "Motley");
  SetServerRule("2020", "End of times are near");
  SetServerRule("Soo..", "Come and die with us in Liberty");
  print( "Script is starting" );
  NewTimer( "MyHeart", 1000, 0 );

  return 1;
}

function onScriptUnload() {
  print( "The script has terminated" );
  
  return 1;
}

function onPlayerJoin(player) {
  ActivePlayer.push( player.ID );
	
  local ClearRows = 72, i = 0;
	
  while ( i != ClearRows) {
    MessagePlayer("", player);
    i++;
  }
  MessagePlayer("***DARBYTOWN SCRIPT***", player);
  SmallMessage( "~r~Demo Mode", 999999999, 1 ); // Updates for everyone playing
  MessagePlayer("To see in game stats type /stats", player);
  MessagePlayer("Need a car guy? Type /spawncar number", player);
  MessagePlayer("If you wish to die at this point feel free to type /die", player);

  MessagePlayer("** This is a demo so chill my guy**", player);

  return 1;
}

function onPlayerSpawn(player, iclass) {
  
  foreach(i, v in SpawnWeapons) {
    if(v > 0) {
      player.SetWeapon(i, v);
    }
  }
  player.Health = HealthCap[player.ID]
  player.SetWeapon(0); // SetWeapon to fist

  Message(">> " + player.Name + ": has spawned into the freeroam.");  
  return 1;
}  

function onPlayerDeath( player, reason ) {
     Message( ">> " + player.Name + ": has died" );
     Deaths[player.ID]++;
	 
     return 1;
}
function onPlayerPart( player, reason ) {
  ActivePlayer.remove( player.ID );
  Deaths[player.ID] = 0;  
  Kills[player.ID] = 0;
  TimesKilled[player.ID] = 0;
  HealthCap[player.ID] = 25;
  return 1;
}

function onPlayerCommand( player, cmd, text ) {
  if ( cmd == "stats" ) {
    Message( player.Name + " Deaths: " + Deaths[player.ID] + ", Times Killed: " + TimesKilled[player.ID] + ", Kills: " + Kills[player.ID] + "." );
    return true;  
  }
  
  if (cmd == "die") {
    player.Health = 0;
    return true;
  }
	
  if (cmd == "spawncar" ) {
    if (!IsNum(text)) {
      MessagePlayer("/spawncar number", player);
      return true;
    }
    local SpawnCar = CreateVehicle( text.tointeger(), player.Pos, player.Angle, -1, -1 );
    SpawnCar.OneTime = true;
    return true;
  }
  
  if (cmd == "pos") {
    print( "[ " + player.Pos.x + ", " + player.Pos.y + ", " + player.Pos.z + " );" );
    return true;
  }
	 
  if (cmd == "race") {
    if (player.Vehicle) {
      local UserVehicle = FindVehicle(player.Vehicle.ID)
      player.RemoveFromVehicle();
      UserVehicle.Remove();
    }
    if (!text) {
      MessagePlayer("/race TheBanshee", player) 
      return true;
    }
    if (text == "The Banshee" ) {
      RaceEnd( player )
      ServerRace = TheBanshee
      RaceCounter(ServerRace, player)
      StartRace(player);		   
    }
    return true;
  }
  if (cmd == "angle" ) {
    print(player.Angle)
    return true;
  }
}
// return here to fix broken syntax
function onPlayerKill( killer, player, reason, bodypart )
{
  Message( ">> " + killer.Name + " killed " + player.Name );
  Kills[killer.ID]++;
  TimesKilled[player.ID]++;
	 
  if(Kills[killer.ID] > HealthCap[killer.ID]) {
    foreach(i, v in HealthLevel) {
      if(v == Kills[killer.ID]) {
        HealthCap[killer.ID] = HealthLevel[i];
        killer.Health = HealthCap[killer.ID]
        break;
      }
    }
  }  
     return 1;
}


local SphereCheck = array(GetMaxPlayers(), 0); //it "The Banshee"
local BlipCheck = array(GetMaxPlayers(), 0 )
ServerRace <- null;
TheBanshee <- [
[ 1139.6, 50.95, -0.29 ], // Startline, create vehicle etc
[ 1173.3, 53.64, -0.58 ],  // first checkpoint sphere
[ 1195.6, 23.42, -0.51 ],
[ 1195.7, -49.38, 9.4 ],
[ 1195.6, -122.49, 14.4 ],
[ 1124, -202.86, 14.4 ],
[ 1127.6, -247.57, 16.86 ],
[ 1131.3, -275.49, 19.48 ],
[ 1124.2, -394.5, 19.4 ],
[ 1133, -449, 19.55 ],
[ 1156.3, -459.5, 21.03 ],
[ 1191.9, -463.4, 24.57 ],
[ 1196.9, -407.6, 24.5 ],
[ 1207.2, -388.9, 24.68 ],
[ 1269.5, -388.5, 31.55 ],
[ 1352.3, -388.4, 48.86 ],
[ 1367.9, -440.6, 49.5 ],
[ 1245.9, -505.8, 28.52 ],
[ 1075.6, -501.8, 15.39 ],
[ 1062, -566.6, 16.19 ],
[ 1059.2, -620.1, 14.4 ],
[ 1038, -678, 14.4 ],
[ 1013.4, -665.2, 14.41 ],
[ 1048.8, -652.6, 14.4 ],
[ 1045.7, -766.1, 14.4 ],
[ 921.3, -770.3, 14.4 ],
[ 826.4, -770.1, 14.49 ],
[ 825.8, -849, 14.66 ],
[ 877.3, -932.7, 14.55 ],
[ 936.8, -934.6, 18.41 ],
[ 1051.3, -932.9, 14.4 ],
[ 1056, -804.1, 14.4 ],
[ 1054.1, -632.8, 14.4 ],
[ 872, -626.6, 14.4 ],
[ 869.1, -665.5, 14.55 ],
[ 869, -698.6, 14.4 ],
[ 901, -667.8, 14.41 ],
[ 871.8, -665.9, 14.55 ],
[ 867.9, -624.7, 14.4 ],
[ 799.5, -623.4, 14.55 ],
[ 785.6, -825.3, 14.59 ],
[ 776.9, -875.6, 14.33 ],
[ 770.5, -784.9, 14.33 ],
[ 776.4, -707.1, 14.33 ],
[ 790, -661, 14.65 ],
[ 790.6, -609.1, 15.35 ],
[ 789.9, -580.3, 17.51 ],
[ 788.4, -507.9, 15.32 ],
[ 825.4, -454.2, 14.4 ],
[ 839.5, -451.5, 14.4 ],
[ 903, -453.9, 14.4 ],
[ 909.8, -373.1, 13.69 ],
[ 911.3, -177.26, 4.4 ],
[ 910.8, -48.72, 6.91 ],
[ 976.2, 0.44, 4.67 ],
[ 1096.8, -0.26, 4.1 ],
[ 1125.4, -92.1, 7.84 ],
[ 1172.3, -129.29, 14.4 ],
[ 1194.6, -127.58, 14.4 ],
[ 1195.9, -48.92, 9.4 ]
];
/*    foreach(i, v in ServerRace) {
      print(ServerRace[i][0] + " " + ServerRace[i][1] + " "+ ServerRace[i][2])
    }
*/
function StartRace(player) { 

  local StartPos = Vector(ServerRace[RaceCheckpoint[player.ID]][0], ServerRace[RaceCheckpoint[player.ID]][1], ServerRace[RaceCheckpoint[player.ID]][2])
  player.Pos = StartPos;
  local SpawnCar = CreateVehicle( 119,  player.Pos, player.Angle) // go back and get an angle for that position
  player.Vehicle = SpawnCar;
  SpawnCar.Angle = 274.085;  
  SpawnCar.OneTime = true;  

  player.Frozen = true;
  NewTimer( "RaceStarted", 5000, 1, player );
}
function RaceStarted(player) { 
  player.Frozen = false;
  RaceSphere(player);
}
local MaxSpheres = array(GetMaxPlayers(), 0 )
function RaceCounter(Race, player) {
   foreach(i, v in Race) {
      MaxSpheres[player.ID] = i;
    }
	  local StartPos = Vector(ServerRace[RaceCheckpoint[player.ID]][0], ServerRace[RaceCheckpoint[player.ID]][1], ServerRace[RaceCheckpoint[player.ID]][2])

  SphereCheck[player.ID] = CreateClientSphere( StartPos, 8.00, player );
  BlipCheck[player.ID] = CreateClientBlip( player, BLIP_NONE, StartPos);
}
function RaceSphere(player) {
 if (RaceCheckpoint[player.ID] <= MaxSpheres[player.ID]) { 
  local StartPos;
  StartPos = Vector(ServerRace[RaceCheckpoint[player.ID]][0], ServerRace[RaceCheckpoint[player.ID]][1], ServerRace[RaceCheckpoint[player.ID]][2])

  local sphere = FindSphere(SphereCheck[player.ID], player ); 
  if (sphere) sphere.Pos = StartPos;
  
  local blip = FindBlip(BlipCheck[player.ID], player ); 
  if (blip) blip.Pos = StartPos

  RaceCheckpoint[player.ID]++;
 }
  else { 
   Message("Race Over" )
   RaceEnd( player )
   return true;
 }
}

function RaceEnd( player ) { 
  RaceCheckpoint[player.ID] = 0
  
  local sphere = FindSphere(SphereCheck[player.ID], player ); 
  if (sphere) sphere.Remove()

  local blip = FindBlip(BlipCheck[player.ID], player ); 
  if (blip) blip.Remove()
  
  print(BlipCheck[player.ID])
  print(MaxSpheres)
  BlipCheck[player.ID] = 0;
  MaxSpheres[player.ID] = 0;
  
  ServerRace = null

}
function onPlayerEnterSphere( player, sphere )
{
     if ( sphere.ID == SphereCheck[player.ID].ID ) { 
	   RaceSphere(player)
     }
     return 1;
}
  
ActivePlayer <- [];

function MyHeart()
{
	foreach(Index, ActiveID in ActivePlayer ) {
	
		print( "CLIENT NAME: " + FindPlayer(ActiveID).Name );
		
	}
  }

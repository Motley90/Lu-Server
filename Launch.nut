/*

Re developemental shit 

Use loadscript http://www.squirrel-lang.org/squirreldoc/stdlib/stdiolib.html?highlight=dofile#loadfile

*/ 

print("Server Loader has been loaded!");

class Server { 
  RaceScript = false;
  ScriptsLoaded = [];
  BaseMode = false;
  Memory = null;
  function LoadScript(strName) {
    loadfile(ScriptsLoaded[i]);
  }
 };
print(Server().RaceScript)
//ActivePlayer.push( player.ID );

//ServerData.insert(player.ID, GoToSpherePlayer)

function onScriptLoad() {

  SetServerRule("Owner", "Motley");
  SetServerRule("2020", "End of times are near");
  SetServerRule("Soo..", "Come and die with us in Liberty");
  print( "Script is starting" );

  return 1;
}

function onScriptUnload() {
  print( "The script has terminated" );
  
  return 1;
}

function onPlayerJoin(player) {
  //ActivePlayer.push( player.ID );
  if (RaceScript) {
    //RaceWelcome(player);
    MessagePlayer("Race Event is [active]", player);
  }
  if (BaseMode) { 
    //BaseWelcome(player);
    MessagePlayer("Save the base Event is [active]", player);	
  }
	
  SmallMessage( "~r~Demo Mode", 999999999, 1 ); // Updates for everyone playing
  
	MessagePlayer("To see in game stats type /stats", player);
  MessagePlayer("Need a car guy? Type /spawncar number", player);
  MessagePlayer("If you wish to die at this point feel free to type /die", player);

  MessagePlayer("** This is a demo so chill my guy**", player);

  return 1;
}

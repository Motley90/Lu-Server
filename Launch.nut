/*

Re developemental shit 

Use loadscript http://www.squirrel-lang.org/squirreldoc/stdlib/stdiolib.html?highlight=dofile#loadfile

*/ 




local server = {
    Name = "DarbyTown",
    Runtime = function() {
        
    }
}

local ServerData = [];  
Server <- class() { 
  RaceScript = false;
  ScriptsLoaded = [];
	    
  Memory = nil;
  function LoadScript(strName) 
  {
    Memory.apply(function() 
    {
      foreach(index, script in ScriptsLoaded) {
      loadfile(ServerRace[i]);
    });
  }
};

//GoToSpherePlayerArray.insert(player.ID, GoToSpherePlayer)

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
  MessagePlayer("***DARBYTOWN SCRIPT***", player);
  SmallMessage( "~r~Demo Mode", 999999999, 1 ); // Updates for everyone playing
  MessagePlayer("To see in game stats type /stats", player);
  MessagePlayer("Need a car guy? Type /spawncar number", player);
  MessagePlayer("If you wish to die at this point feel free to type /die", player);

  MessagePlayer("** This is a demo so chill my guy**", player);

  return 1;
}

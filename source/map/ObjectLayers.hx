package map;

import flixel.group.FlxGroup;

/**
 * Container class for the object layers of a tiled level
 * @author Strauzen
 */
class ObjectLayers 
{
	public var information(default, null):FlxGroup;
	public var enemies(default, null):FlxGroup;
	public var puzzles(default, null):FlxGroup;

	public function new(informationLayer:FlxGroup, ?enemiesLayer:FlxGroup, ?puzzlesLayer:FlxGroup) {
		// TODO modify level layer names and level loader to match this description
		if (informationLayer == null) 
		    throw "Information layer not defined in loaded level, in your level please add a layer with the name lvl_information.";

		this.information = informationLayer;
		this.enemies = if (enemiesLayer != null) enemiesLayer else new FlxGroup();
		this.puzzles = if (puzzlesLayer != null) puzzlesLayer else new FlxGroup();
	}
	
}
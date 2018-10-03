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

	public function new(informationLayer:FlxGroup, enemiesLayer:FlxGroup, puzzlesLayer:FlxGroup) {
		this.information = informationLayer;
		this.enemies = enemiesLayer;
		this.puzzles = puzzlesLayer;
	}
	
}
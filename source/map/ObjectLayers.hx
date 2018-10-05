package map;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTileblock;

/**
 * Container class for the object layers of a tiled level
 * @author Strauzen
 */
class ObjectLayers 
{
	public var information(default, null):FlxGroup;
	public var enemies(default, null):FlxGroup;
	public var puzzles(default, null):FlxGroup;
	public var levelBounds(default, null):FlxGroup;

	public function new(informationLayer:FlxGroup, ?enemiesLayer:FlxGroup, ?puzzlesLayer:FlxGroup, ?levelBounds:FlxGroup) {
		if (informationLayer == null) 
		    throw "Information layer not defined in loaded level, in your level please add a layer " +
			"with the property dev_name of value lvl_information.";

		this.information = informationLayer;
		this.enemies = if (enemiesLayer != null) enemiesLayer else new FlxGroup();
		this.puzzles = if (puzzlesLayer != null) puzzlesLayer else new FlxGroup();
		this.levelBounds = if (levelBounds != null) levelBounds else createLevelBounds();
	}
	
	private function createLevelBounds():FlxGroup {
		var thickness = 16;
		
		var left = new FlxTileblock(0 - thickness, 0, thickness, FlxG.height);
		var right = new FlxTileblock(FlxG.width, 0 + thickness, thickness, FlxG.height);
		var top = new FlxTileblock(0 - thickness, 0 - thickness, FlxG.width + thickness * 2, thickness);
		var bottom = new FlxTileblock(0 - thickness, FlxG.height, FlxG.width + thickness * 2, thickness);
				
		var result = new FlxGroup();
		result.add(left);
		result.add(top);
		result.add(right);
		result.add(bottom);
		
		return result;
	}
	
}
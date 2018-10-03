package map;

import flixel.group.FlxGroup;

/**
 * Container class for the tile layers of a tiled level.
 * @author Strauzen
 */
class TileLayers 
{

	public var backgroundTiles(default, null):FlxGroup;
    public var collisionTiles(default, null):FlxGroup;
	public var foregroundTiles(default, null):FlxGroup;
	
	public function new(backgroundLayer:FlxGroup, collisionLayer:FlxGroup, foregroundLayer:FlxGroup) 
	{
		this.backgroundTiles = backgroundLayer;
		this.collisionTiles = collisionLayer;
		this.foregroundTiles = foregroundLayer;
	}
	
}
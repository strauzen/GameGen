package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.editors.tiled.TiledMap;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

/**
 * Class that encapsulates all the information of a tiled level.
 * @author Strauzen
 */
class TiledLevel
{
	public var informationLayer(default, null):FlxGroup;
	public var enemiesLayer(default, null):FlxGroup;
	public var puzzlesLayer(default, null):FlxGroup;
    public var backgroundLayer(default, null):FlxGroup;
    public var collisionLayer(default, null):FlxGroup;
	public var foregroundLayer(default, null):FlxGroup;
	public var collidableTileLayers(default, null):Array<FlxTilemap>;
	

	public function new(informationLayer:FlxGroup, ?enemiesLayer:FlxGroup, ?puzzlesLayer:FlxGroup, 
	backgroundLayer:FlxGroup, collisionLayer:FlxGroup, ?foregroundLayer:FlxGroup, collidableTileLayers:Array<FlxTilemap>) 
	{
		this.informationLayer = informationLayer;
		this.enemiesLayer = if (enemiesLayer != null) enemiesLayer else new FlxGroup();
		this.puzzlesLayer = if (puzzlesLayer != null) puzzlesLayer else new FlxGroup();
		this.backgroundLayer = backgroundLayer;
		this.collisionLayer = collisionLayer;
		this.foregroundLayer = if (foregroundLayer != null) foregroundLayer else new FlxGroup();
		this.collidableTileLayers = collidableTileLayers;
	}
		
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject -> FlxObject -> Void, ?processCallback:FlxObject -> FlxObject -> Bool):Bool {
        if (collidableTileLayers == null)
            return false;

        for (map in collidableTileLayers) {
            // IMPORTANT: Always collide the map with objects, not the other way around.
            //            This prevents odd collision errors (collision separation code off by 1 px).
            if (FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate)) {
                return true;
            }
        }
        return false;
    }
}
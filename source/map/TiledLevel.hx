package map;

import flixel.FlxG;
import flixel.FlxObject;

/**
 * Class that encapsulates all the information of a tiled level.
 * @author Strauzen
 */
class TiledLevel
{	
	public var width(default, null):Int;
	public var height(default, null):Int; 
	public var tileWidth(default, null):Int; 
	public var tileHeight(default, null):Int;
	
	public var fullWidth(default, null):Int;
	public var fullHeight(default, null):Int;
	
	public var objects(default, null):ObjectLayers;
	public var layers(default, null):TileLayers;	

	public function new(width:Int, height:Int, tileWidth:Int, tileHeight:Int, fullWidth:Int, fullHeight:Int, 
	objects:ObjectLayers, layers:TileLayers) 
	{
		this.width = width;
		this.height = height;
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		
		this.fullWidth = fullWidth;
		this.fullHeight = fullHeight;
		
		this.objects = objects;
		this.layers = layers;
	}
		
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject -> FlxObject -> Void, ?processCallback:FlxObject -> FlxObject -> Bool):Bool {
        if (layers.collisionTiles == null)
            return false;

        for (tilemap in layers.collisionTiles.members) {
            // IMPORTANT: Always collide the map with objects, not the other way around.
            //            This prevents odd collision errors (collision separation code off by 1 px).
            if (FlxG.overlap(tilemap, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate)) {
                return true;
            }
        }
        return false;
    }
}
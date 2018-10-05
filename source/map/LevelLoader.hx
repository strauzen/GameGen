package map ;

import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer; 
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.group.FlxGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import haxe.io.Path;
import map.TiledLevel;

/**
 * Class that loads a TiledMap Editor level from the assets/tiled/ directory. It expects the following information:
 * 
 * One to three object layers, the layers are identified by a custom property called "dev_name" which can have the 
 * following values:
 *     - informationLayer: Mandatory. This layer contains information such as where the player should start or where is 
 *                         the end of a level.
 *     - enemiesLayer:     Optional. This layer contains the information such as the enemy positions in the level and 
 *                         their type.
 *     - puzzlesLayer:     Optional. This layer contains the information such as the positions of puzzle related objects 
 *                         in the level and their type.
 * 
 * One to three tile layers, the layers are identified by a custom property called "dev_name" which can have the 
 * following values:
 *     - backgroundLayer: Optional. This layer contains the information of the non-collidable tiles of the level that are
 *                        drawn under the object layers.
 *     - collisionLayer:  Optional. This layer contains the information of all the collidable tiles in the level.
 *     - foregroundLayer: Optional. This layer contains the information of all the non-collidable tiles of the level that are
 *                        drawn under the object layers.
 * Additionally, tile layers need to have a custom string property "tileset" that contains the name of the tileset they 
 * are using. The name needs to be written without extensions.
 * 
 * @author Strauzen
 * 
 * Based on the code of the TiledEditor demo from the haxe-flixel engine written by @author Gama11.
 */
class LevelLoader extends TiledMap {

    // Path for TiledMap Editor related assets
    inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	// Container that encapsulates the tiled level
	public var loadedLevel:map.TiledLevel;
	
    // Object layers used in the editor
	private var informationLayer:FlxGroup;
	private var enemiesLayer:FlxGroup;
	private var puzzlesLayer:FlxGroup;
	
	// Tile layers used in the editor according to draw order and properties
    private var backgroundLayer:FlxGroup;
    private var collisionLayer:FlxGroup;
	private var foregroundLayer:FlxGroup;

    function new(tiledLevel:FlxTiledMapAsset, state:PlayState) {
        super(tiledLevel);

        informationLayer = new FlxGroup();
		enemiesLayer = new FlxGroup();
		puzzlesLayer = new FlxGroup();
		
        backgroundLayer = new FlxGroup();
        collisionLayer = new FlxGroup();
		foregroundLayer = new FlxGroup();

        loadObjects(state);
        loadTiles();
		
		// We build the level information in its containers
		var objects:ObjectLayers = new ObjectLayers(informationLayer, collisionLayer, foregroundLayer);
		var layers:TileLayers = new TileLayers(backgroundLayer, collisionLayer, foregroundLayer);
		this.loadedLevel = new map.TiledLevel(width, height, tileWidth, tileHeight, objects, layers);
    }

	public static function LoadLevel(tiledLevel:FlxTiledMapAsset, state:PlayState):map.TiledLevel {
		var levelLoader = new LevelLoader(tiledLevel, state);
		return levelLoader.loadedLevel;
	}
	
    private function loadTiles() {
        // Load Tile Maps
        for (layer in layers) {
            // If it is not a tile layer go to the next one
            if (layer.type != TiledLayerType.TILE) continue;
            var tileLayer:TiledTileLayer = cast layer;

            // Load tilesets according to the tileset property
            var tileSheetName:String = tileLayer.properties.get("tileset");

            if (tileSheetName == null)
                throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

            var tileSet:TiledTileSet = null;
            for (ts in tilesets) {
                if (ts.name == tileSheetName) {
                    tileSet = ts;
                    break;
                }
            }

            if (tileSet == null)
                throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";

            var imagePath = new Path(tileSet.imageSource);
            var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

            // could be a regular FlxTilemap if there are no animated tiles
            var tilemap = new FlxTilemapExt();
            tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
            tileSet.tileWidth, tileSet.tileHeight, FlxTilemapAutoTiling.OFF, tileSet.firstGID, 1, 1);

			switch(tileLayer.properties.get("dev_name").toLowerCase()) {
				case "lvl_background":
					backgroundLayer.add(tilemap);
					
				case "lvl_collision":
					collisionLayer.add(tilemap);
					
				case "lvl_foreground":
					foregroundLayer.add(tilemap);
			}
        }
    }

    private function loadObjects(state:PlayState) {
        for (layer in layers) {
            if (layer.type != TiledLayerType.OBJECT)
                continue;
            var objectLayer:TiledObjectLayer = cast layer;

            //objects layer
			switch (layer.properties.get("dev_name").toLowerCase()) {
				case "lvl_information":
					loadObjectLayer(state, objectLayer, informationLayer);
					
				case "lvl_enemies":
					loadObjectLayer(state, objectLayer, enemiesLayer);
					
				case "lvl_puzzles":
					loadObjectLayer(state, objectLayer, puzzlesLayer);
			}
        }
    }

	private function loadObjectLayer(state:PlayState, objectLayer:TiledObjectLayer, group:FlxGroup) {
		for (o in objectLayer.objects) {
			loadObject(state, o, objectLayer, group);
		}
	}
	
    private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer, group:FlxGroup) {
        var x:Int = o.x;
        var y:Int = o.y;

        // objects in tiled are aligned bottom-left (top-left in flixel)
        if (o.gid != -1)
            y -= g.map.getGidOwner(o.gid).tileHeight;

        switch (o.type.toLowerCase())
        {	
            case "player_start":
                var player = new Player(x, y);
                state.player = player;
                group.add(player);

            case "exit":
                // Create the level exit
                var exit = new FlxSprite(x, y);
                exit.makeGraphic(32, 32, 0xff3f3f3f);
                exit.exists = false;
                state.exit = exit;
                group.add(exit);
        }
    }
}

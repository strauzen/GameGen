package ;

import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import haxe.io.Path;

class LevelTest extends TiledMap {

    // Path for TiledMap Editor related assets
    inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

    // Layers used in the editor
    //public var foregroundLayer:FlxGroup;
    public var objectsLayer:FlxGroup;
    public var backgroundLayer:FlxGroup;
    public var wallsLayer:FlxGroup;
    var collidableTileLayers:Array<FlxTilemap>;

    public function new(tiledLevel:FlxTiledMapAsset, state:PlayState) {
        super(tiledLevel);

        objectsLayer = new FlxGroup();
        backgroundLayer = new FlxGroup();
        wallsLayer = new FlxGroup();

        FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);

        loadObjects(state);
        loadTiles();
    }

    public function loadTiles() {
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

            if (tileLayer.properties.contains("nocollide")) {
                backgroundLayer.add(tilemap);
            }
            else {
                if (collidableTileLayers == null)
                    collidableTileLayers = new Array<FlxTilemap>();

                wallsLayer.add(tilemap);
                collidableTileLayers.push(tilemap);
            }
        }
    }

    public function loadObjects(state:PlayState) {
        for (layer in layers) {
            if (layer.type != TiledLayerType.OBJECT)
                continue;
            var objectLayer:TiledObjectLayer = cast layer;

            //objects layer
            if (layer.name == "objects") {
                for (o in objectLayer.objects) {
                    loadObject(state, o, objectLayer, objectsLayer);
                }
            }
        }
    }

    function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer, group:FlxGroup) {
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

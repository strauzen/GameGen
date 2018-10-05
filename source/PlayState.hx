package;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import map.LevelLoader;
import map.TiledLevel;

class PlayState extends FlxState {
    public var level:map.TiledLevel;

	public var cameraPos:FlxObject;
    public var player:Player;
    public var exit:FlxSprite;

    override public function create():Void {
        FlxG.mouse.visible = false;
		
        bgColor = 0xffaaaaaa;

        // Load the level's tilemaps
        level = LevelLoader.LoadLevel("assets/tiled/lvl_test1.tmx", this);
		FlxG.worldBounds.set(0 - level.tileWidth * 2, 0 - level.tileHeight * 2, 
		FlxG.width + (level.tileWidth * 2), FlxG.height + (level.tileHeight * 2));

        // Add backgrounds
        add(level.layers.backgroundTiles);

        // Add collision tiles
        add(level.layers.collisionTiles);

        // Load map information objects
        add(level.objects.information);
		
		// Load enemies objects
		add(level.objects.enemies);
		
		// Load puzzle objects
		add(level.objects.puzzles);
		
		// Load the level boundaries
		add(level.objects.levelBounds);
		
		// Add foreground tiles after the objects so they are rendered on top of the player
		add(level.layers.foregroundTiles);
		
		// Set the camera information
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.width, FlxG.height, true);
        FlxG.camera.follow(player, SCREEN_BY_SCREEN, 1);

        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Collide with foreground tile layer
        level.collideWithLevel(player);
		if (level.collideWithLevelBorder(player)) {
			trace("Hello");
		}

        FlxG.overlap(exit, player, win);
    }

    public function win(Exit:FlxObject, Player:FlxObject):Void
    {
		player.kill();
    }
}

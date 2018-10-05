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
		
		// Add foreground tiles after the objects so they are rendered on top of the player
		add(level.layers.foregroundTiles);
		
		// Set the camera information
		FlxG.camera.setScrollBoundsRect(0, 0, level.fullWidth, level.fullHeight, true);
        FlxG.camera.follow(player, SCREEN_BY_SCREEN, 1);

        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Collide with foreground tile layer
        level.collideWithLevel(player);
		// TODO implement this with callbacks?
		if (level.collideWithLevelBorder(player)){
			trace("Hello");
		}

        FlxG.overlap(exit, player, win);
    }

    public function win(Exit:FlxObject, Player:FlxObject):Void
    {
    }
}

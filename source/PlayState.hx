package;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
    public var level:LevelTest;

	public var cameraPos:FlxObject;
    public var player:Player;
    public var exit:FlxSprite;

    override public function create():Void {
        FlxG.mouse.visible = false;

        bgColor = 0xffaaaaaa;

        // Load the level's tilemaps
        level = new LevelTest("assets/tiled/lvl_test.tmx", this);

        // Add backgrounds
        add(level.backgroundLayer);

        // Add foreground tiles after adding level objects, so these tiles render on top of player
        add(level.wallsLayer);

        // Load player objects
        add(level.objectsLayer);

		//FlxG.camera.setPosition(cameraPos.x, cameraPos.y);
        FlxG.camera.follow(player, SCREEN_BY_SCREEN, 1);

        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Collide with foreground tile layer
        level.collideWithLevel(player);

        FlxG.overlap(exit, player, win);
    }

    public function win(Exit:FlxObject, Player:FlxObject):Void
    {
    }
}

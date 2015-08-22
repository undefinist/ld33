package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.camera.bgColor = 0xffffffff;
		
		var text:FlxText = new FlxText(8, FlxG.height / 2 - 16, FlxG.width, "pyinpyang", 8);
		text.color = 0xff000000;
		add(text);
		
		text = new FlxText(16, FlxG.height / 2, FlxG.width, "by @undefinist");
		text.color = 0xff000000;
		text.alpha = 0.5;
		add(text);
		
		text = new FlxText(16, FlxG.height / 2 + 16, FlxG.width, "up/down/w/s to move\nyou can eat spikes when you're evil\nbut avoid them otherwise");
		text.color = 0xff000000;
		text.alpha = 0.5;
		add(text);
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.anyJustPressed([ UP, DOWN, W, S, ENTER, SPACE ]))
			FlxG.switchState(new PlayState());
	}
}

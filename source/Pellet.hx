package;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Malody Hoe / undefinist
 */
class Pellet extends FlxSprite
{

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		loadGraphic(AssetPaths.pellet__png);
		
		drag.x = drag.y = 1024;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (x > FlxG.width || x < -3 || y > FlxG.height || y < -3)
		{
			FlxG.state.remove(this).destroy();
		}
	}
	
}
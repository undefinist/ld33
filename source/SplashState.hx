package;

import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author Malody Hoe / undefinist
 */
class SplashState extends FlxState
{
	
	override public function create():Void 
	{
		super.create();
		
		if (FlxG.save.data.highscore == null)
			FlxG.save.data.highscore = 0;
			
		FlxG.switchState(new MenuState());
	}
	
}
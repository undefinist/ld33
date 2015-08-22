package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Malody Hoe / undefinist
 */
class Enemy extends FlxSprite
{

	public function new(x:Float, y:Float, vel:FlxPoint) 
	{
		super(x - 4, y - 4);
		
		pixelPerfectPosition = false;
		
		loadGraphic(AssetPaths.spikeball__png);
		
		this.velocity = vel;
		maxVelocity.set(128, 128);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (x > FlxG.width - width)
		{
			x = FlxG.width - width;
			velocity.x *= -1;
		}
		else if (x < 0)
		{
			x = 0;
			velocity.x *= -1;
		}
		
		if (y > FlxG.height - height)
		{
			y = FlxG.height - height;
			velocity.y *= -1;
		}
		else if (y < 0)
		{
			y = 0;
			velocity.y *= -1;
		}
		
		velocity.x += elapsed * 4;
		velocity.y += elapsed * 4;
	}
	
}
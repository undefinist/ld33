package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.plus.FlxPlus;

/**
 * ...
 * @author Malody Hoe / undefinist
 */
class Player extends FlxSprite
{

	private static inline var MAX_SPEED:Float = 96;
	private static inline var ACCELERATION:Float = 96 * 5;
	
	public var state(default, set):Int = 0; // 0 good 1 bad
	
	private var invincibleDuration:Float;
	
	public function damage(amt:Float):Void
	{
		if (invincibleDuration > 0)
			return;
		health -= amt;
		invincibleDuration = 1;
		Reg.combo--;
		if (Reg.combo < 1)
			Reg.combo = 1;
		FlxPlus.playPersistingSound("hurt");
	}
	
	public function new() 
	{
		super(0, FlxG.height / 2 - 8);
		
		state = 0;
		
		maxVelocity.y = MAX_SPEED;
		maxVelocity.x = MAX_SPEED * 2.5;
		drag.y = ACCELERATION;
		velocity.x = 64;
		
		health = 100;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		var v:Int = 0;
		if (FlxG.keys.anyPressed([ UP, W ]))
			v--;
		else if (FlxG.keys.anyPressed([ DOWN, S ]))
			v++;
			
		acceleration.y = ACCELERATION * v;
		
		if (x > FlxG.width - 16)
		{
			x = FlxG.width - 16;
			state = 1;
		}
		else if (x < 0)
		{
			x = 0;
			state = 0;
		}
		
		health -= elapsed * 2;
		velocity.x += elapsed * 4;
		
		if (invincibleDuration > 0)
		{
			invincibleDuration -= elapsed;
			// y = abs(cos (20x / pi))
			alpha = Math.abs(Math.cos(20 * invincibleDuration / Math.PI));
			
			if (invincibleDuration < 0)
			{
				invincibleDuration = 0;
				alpha = 1;
			}
		}
	}
	
	private function set_state(v:Int):Int
	{
		if (v == 0)
			loadGraphic(AssetPaths.good__png, true);
		else
			loadGraphic(AssetPaths.bad__png, true);
			
		animation.add("def", [ 0, 1, 2, 3, 4, 5 ], 12);
		animation.play("def");
		width = 6;
		height = 10;
		
		if (v == 0)
		{
			FlxG.camera.bgColor = 0xff000000;
			flipX = false;
			offset.x = 10;
			offset.y = 3;
			if (state != v)
			{
				FlxG.camera.shake(0.025, 0.25);
				velocity.x /= -1.5;
				maxVelocity.y /= 1.5;
			}
		}
		else
		{
			FlxG.camera.bgColor = 0xffffffff;
			flipX = true;
			offset.x = 0;
			offset.y = 3;
			if (state != v)
			{
				FlxPlus.sleep(0.125);
				FlxG.camera.shake(0.025, 0.25);
				velocity.x *= -1.5;
				maxVelocity.y *= 1.5;
			}
		}
		
		return state = v;
	}
	
}
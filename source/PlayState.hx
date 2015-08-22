package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.plus.FlxPlus;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var player:Player;
	private var prevState:Int = 0;
	
	private var gameOver:Bool = false;
	private var canRestart:Bool = false;
	
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.camera.pixelPerfectRender = false;
		
		add(player = new Player());
		
		generatePellets();
		
		add(new HUD(player));
	}
	
	private function generatePellets():Void
	{
		for (i in 0...10)
		{
			var x = FlxG.random.float(32, FlxG.width - 32);
			var y = FlxG.random.float(32, FlxG.height - 32);
			add(new Pellet(x, y));
		}
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		player = null;
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (gameOver)
		{
			if (!canRestart)
				return;
			
			if (FlxG.keys.anyJustPressed([ ESCAPE, BACKSPACE ]))
			{
				FlxG.timeScale = 1;
				FlxG.switchState(new MenuState());
			}
			else if (FlxG.keys.justPressed.ANY)
			{
				FlxG.timeScale = 1;
				FlxG.resetState();
			}
			
			return;
		}
		
		FlxG.overlap(player, this, onOverlap);
		
		if (player.health <= 0)
		{
			player.health = 0;
			remove(player).destroy();
			FlxG.camera.shake(0.05, 0.25);
			FlxG.timeScale = 0.25;
			FlxPlus.playPersistingSound("over", 0.75);
			gameOver = true;
			
			new FlxTimer().start(1 * 0.25, function(_):Void {
				var text:FlxText = new FlxText(0, FlxG.height / 2 - 16, FlxG.width, "GAME OVER", 16);
				text.setBorderStyle(OUTLINE, 0xff000000);
				text.alignment = "center";
				add(text);
				new FlxTimer().start(1 * 0.25, function(_):Void {
					text = new FlxText(0, FlxG.height / 2 + 12, FlxG.width, "", 16);
					text.setBorderStyle(OUTLINE, 0xff000000);
					text.alignment = "center";
					var hs = FlxG.save.data.highscore;
					text.text = Reg.score > hs ? "NEW HIGHSCORE!!!" : 'HIGHSCORE: $hs';
					if (Reg.score > hs)
						FlxG.save.data.highscore = Reg.score;
					add(text);
					canRestart = true;
				} );
			} );
			
			return;
		}
		
		if (prevState != player.state)
		{
			prevState = player.state;
			
			for (spr in this)
			{
				if (!Std.is(spr, Player))
				{	
					cast(spr, FlxSprite).color = player.state == 0 ? 0xffffffff : 0xff000000;
				}
			}
			
			if (player.state == 0)
			{
				var x = FlxG.random.float(32, FlxG.width - 32);
				var y = FlxG.random.float(32, FlxG.height - 32);
				add(new Pellet(x, y));
			}
			
			Reg.combo--;
			if (Reg.combo < 1)
				Reg.combo = 1;
		
			FlxPlus.playPersistingSound("wall", 0.75);
		}
			
		Reg.score += Std.int(100 * elapsed) * Reg.combo;
	}
	
	private function onOverlap(player:Player, spr:FlxSprite):Void
	{
		if (player.state == 0) // good, eat pellets
		{
			if (Std.is(spr, Pellet))
			{
				onPelletEaten(cast spr);
			}
			else if (Std.is(spr, Enemy))
			{
				player.damage(10);
			}
		}
		else
		{
			if (Std.is(spr, Enemy))
			{
				onEnemyEaten(cast spr);
			}
		}
	}
	
	private function onPelletEaten(pellet:Pellet):Void
	{
		var px:Float = player.x - 8;
		var py:Float = pellet.y;
		
		remove(pellet).destroy();
		
		var dir:FlxVector = new FlxVector(px - player.x, py - player.y).normalize();
		var enemyPos:FlxPoint = new FlxPoint(px, py).addPoint(dir.scale(8));
		
		var enemy:Enemy = new Enemy(enemyPos.x, enemyPos.y, dir.scale(player.velocity.x / 6));
		add(enemy);
		
		player.health += 2;
		if (player.health > 100)
			player.health = 100;
			
		Reg.score += 20 * Reg.combo;
		Reg.combo++;
		
		FlxPlus.sleep(0.05);
		FlxG.camera.shake(0.0125, 0.125);
		
		FlxPlus.playPersistingSound("pellet");
	}
	
	private function onEnemyEaten(enemy:Enemy):Void
	{
		var px:Float = player.x + player.width + 8;
		var py:Float = enemy.y;
		
		remove(enemy).destroy();
		
		var dir:FlxVector = new FlxVector(px - player.x, py - player.y).normalize();
		dir.scale(16);
		
		var pellet:Pellet = new Pellet(px + dir.x, py + dir.y);
		add(pellet);
		pellet.color = player.state == 0 ? 0xffffffff : 0xff000000;
		pellet.velocity.copyFrom(dir.scale( -player.velocity.x / 8));
		
		player.health += 5;
		if (player.health > 100)
			player.health = 100;
			
		Reg.score += 100 * Reg.combo;
		Reg.combo++;
		
		var mul:Float = -player.velocity.x / 96;
		FlxPlus.sleep(0.075 + 0.025 * mul);
		FlxG.camera.shake(0.0125 + 0.0025 * mul, 0.125 + 0.1 * mul);
		
		FlxPlus.playPersistingSound("chomp");
	}
	
}

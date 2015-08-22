package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Malody Hoe / undefinist
 */
class HUD extends FlxTypedSpriteGroup<FlxSprite>
{

	private var player:Player;
	
	private var scoreText:FlxText;
	private var comboText:FlxText;
	private var healthBar:FlxSprite;
	
	public function new(player:Player) 
	{
		super();
		
		this.player = player;
		
		healthBar = new FlxSprite(0, 0);
		healthBar.makeGraphic(FlxG.width, 8);
		add(healthBar);
		
		add(scoreText = new FlxText(4, FlxG.height - 16, FlxG.width, "0", 8));
		add(comboText = new FlxText(0, FlxG.height - 16, FlxG.width - 4, "", 8));
		comboText.alignment = "right";
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		healthBar.scale.x = player.health / 100;
		
		scoreText.text = Std.string(Reg.score);
		comboText.text = Reg.combo == 1 ? "" : "x" + Std.string(Reg.combo);
	}
	
}
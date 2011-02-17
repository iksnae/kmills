package com.iksnae.skinny.states.rtj
{
	import com.iksnae.skinny.items.Background;
	import com.iksnae.skinny.states.PlayState;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class RTJStartScreenState extends FlxState
	{
		private var text1:FlxText;
		private var text2:FlxText;
		private var string1:String = "RAT TAIL JAIL";
		private var string2:String = "press enter to start";
		private var welcome:FlxSprite;
		
		public function RTJStartScreenState()
		{
			super();
			text1 = new FlxText(200,100, FlxG.width,string1);
			text2 = new FlxText(200,110, FlxG.width,string2);
			welcome = new FlxSprite(70, 100,Background.RTJWelcome);
			add(text1);
			add(text2);
			add(welcome);
			
			
		}
		override public function update():void
		{
			if(FlxG.keys.ENTER)
			{
				FlxG.mouse.hide();
				FlxG.state = new RTJGameState();
			}
		}
	}
}
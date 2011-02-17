package
{
	import com.iksnae.skinny.levels.TestLevel;
	import com.iksnae.skinny.states.*;
	import com.iksnae.skinny.states.rtj.RTJStartScreenState;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	
	import org.flixel.FlxGame;	

	public class SkinnyPlatformer extends FlxGame
	{
		
		public function SkinnyPlatformer()
		{
			super(320,240,MultiLevelState,1)
		}
		
	}
}
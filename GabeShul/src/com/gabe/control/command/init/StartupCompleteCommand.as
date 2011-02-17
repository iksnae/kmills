package com.gabe.control.command.init
{
	
	import com.gabe.control.event.GabeShuEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCompleteCommand extends SimpleCommand
	{
		public function StartupCompleteCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			Debug.log('EXECUTE: StartupCompleteCommand');

			sendNotification(GabeShuEvent.STAGE_RESIZE);
			sendNotification(GabeShuEvent.THEME_CHANGE,0);
		}
	}
}
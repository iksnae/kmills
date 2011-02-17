package com.gabe.control.command.init
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCommand extends MacroCommand
	{
		public function StartupCommand()
		{
			super();
		}
		override protected function initializeMacroCommand():void
		{
			Debug.log('EXECUTE: StartupCommand');
			addSubCommand(PrepModelCommand)
			addSubCommand(PrepViewCommand)
			addSubCommand(PrepControlCommand)
		}
	}
}
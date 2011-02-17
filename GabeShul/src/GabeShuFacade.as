package
{
	import com.gabe.control.command.init.StartupCommand;
	import com.gabe.control.command.init.StartupCompleteCommand;
	import com.gabe.control.event.GabeShuEvent;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class GabeShuFacade extends Facade
	{
		
		static private var _app:GabeShul;
		
		static private var _instance:GabeShuFacade=null;
		static public function getInstance():GabeShuFacade
		{
			return _instance;
		}
		static public function init(app:GabeShul):GabeShuFacade
		{
			if(_instance==null) _instance=new GabeShuFacade(app);
			return _instance;
		}
		
		
		
		public function GabeShuFacade(app:GabeShul)
		{
			super();
			_app=app;
		}
		
		
		
		public function startup():void
		{
			sendNotification(GabeShuEvent.STARTUP);
		}
		public function get app():GabeShul
		{
			return _app
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(GabeShuEvent.STARTUP, StartupCommand);
			registerCommand(GabeShuEvent.READY, StartupCompleteCommand);
		}
		
		
		
	}
}
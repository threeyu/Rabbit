package application.controller
{
	import application.model.DataProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class RestartGameCommand extends SimpleCommand implements ICommand
	{
		public function RestartGameCommand()
		{
//			var data:DataProxy=facade.retrieveProxy(DataProxy.NAME) as DataProxy;
//			data.restartTiles();
			
		}
		
		override public function execute(notification:INotification):void
		{
			var data:DataProxy=facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			data.restartTiles();
		}
	}
}
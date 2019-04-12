package application.controller
{

	
	import application.model.DataProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SnakeMoveCommand extends SimpleCommand implements ICommand
	{
		private var data:DataProxy;
		override public function execute(notification:INotification):void
		{
			var dir:int=notification.getBody() as int;
			data=facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			data.modifyTiles(dir);
		}
	}
}
package application.controller
{
	import application.model.DataProxy;
	import application.view.ApplicationMediator;
	import application.view.TileFrameMediator;
	import application.view.components.TileFrame;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ReDrawSnakeCommand extends SimpleCommand implements ICommand
	{
		public function ReDrawSnakeCommand()
		{
			
		}
		
		override public function execute(notification:INotification):void
		{
			//这里用command来引用各个mediator和proxy，处理业务逻辑
			//这里只是举例，并没有用到所有所引用的mediator
			var tileFrameMediator:TileFrameMediator=facade.retrieveMediator(TileFrameMediator.NAME) as TileFrameMediator;
			var appMediator:ApplicationMediator=facade.retrieveMediator(ApplicationMediator.NAME) as ApplicationMediator
			var data:DataProxy=facade.retrieveProxy(DataProxy.NAME) as DataProxy;

			//如果不考虑封装性，下面注释掉的两个方法也可以使用public，因为有时候也会用到显示对象的传递			
//			var tileFrame:TileFrame=tileFrameMediator.tileFrame;
//			var main:Main=appMediator.main;
			
			var refArr:Array=notification.getBody().ref as Array;
			var fullTileArr:Array=notification.getBody().fullTileArr as Array;
			tileFrameMediator.refreshTile(refArr,fullTileArr);
			
			
		}
	}
}
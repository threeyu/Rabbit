package application.controller
{
	import application.model.DataProxy;
	import application.view.TileFrameMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class RndFoodCommand extends SimpleCommand implements ICommand
	{
		public function RndFoodCommand()
		{
			
		}
		override public function execute(notification:INotification):void
		{
			//随机由视图发起，也可以设置由数据层发起
			var data:DataProxy=facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			var tileFrameMediator:TileFrameMediator=facade.retrieveMediator(TileFrameMediator.NAME) as TileFrameMediator;
			var food:int=tileFrameMediator.rndAFood();
			data.setFood(food);
			
		}
	}
}
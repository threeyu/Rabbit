package t6.rabbitMath.org.ppy.framework.cmd
{
	import flash.display.DisplayObject;
	
	import t6.rabbitMath.org.ppy.framework.event.PPYEvent;
	import t6.rabbitMath.org.ppy.framework.model.ViewModel;
	import t6.rabbitMath.org.ppy.framework.view.ISceneView;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-12-4 下午6:07:52
	 **/
	public class ChangeViewCmd extends Command
	{
		[Inject]
		public var contextView : ContextView;
		
		[Inject]
		public var evt : PPYEvent;
		
		[Inject]
		public var viewModel : ViewModel;
		
		public function ChangeViewCmd()
		{
		}
		
		override public function execute():void
		{
			if(contextView.view.numChildren > 0)
			{
				var curView : ISceneView = contextView.view.getChildAt(0) as ISceneView;
				if(curView)
					contextView.view.removeChild(curView as DisplayObject);
			}
			
			var newView : DisplayObject = viewModel.getView(evt.info) as DisplayObject;
			contextView.view.addChild(newView);
		}
	}
}
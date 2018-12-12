package t6.rabbitRead.org.ppy.framework.cmd
{
	import flash.display.DisplayObject;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;
	
	import t6.rabbitRead.org.ppy.framework.event.PPYEvent;
	import t6.rabbitRead.org.ppy.framework.model.ViewModel;
	import t6.rabbitRead.org.ppy.framework.view.ISceneView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-11-22 下午4:10:14
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
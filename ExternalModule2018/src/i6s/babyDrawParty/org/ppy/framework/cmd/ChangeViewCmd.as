package i6s.babyDrawParty.org.ppy.framework.cmd
{
	import flash.display.DisplayObject;
	
	import i6s.babyDrawParty.org.ppy.framework.event.PPYEvent;
	import i6s.babyDrawParty.org.ppy.framework.model.ViewModel;
	import i6s.babyDrawParty.org.ppy.framework.util.PopUpManager;
	import i6s.babyDrawParty.org.ppy.framework.view.ISceneView;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-10 下午3:56:11
	 **/
	public class ChangeViewCmd extends Command
	{
		[Inject]
		public var contextView : ContextView;
		
		[Inject]
		public var evt : PPYEvent;
		
		[Inject]
		public var viewModel : ViewModel;
		
		[Inject]
		public var popManager : PopUpManager;
		
		
		public function ChangeViewCmd()
		{
		}
		
		override public function execute():void 
		{
			if(contextView.view.numChildren > 0) {
				var curView : ISceneView = contextView.view.getChildAt(0) as ISceneView;
				if(curView) {
					popManager.removePopUp(curView as DisplayObject, 1, function() : void {
						contextView.view.removeChild(curView as DisplayObject);
					});
				}
			}
			
			var newView : DisplayObject = viewModel.getView(evt.info) as DisplayObject;
			contextView.view.addChild(newView);
			popManager.addPopUp(newView, 0, 0, 1);
		}
	}
}
package t6.rabbitHealth.org.ppy.framework.cmd
{
	import flash.display.DisplayObject;
	
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;
	
	import t6.rabbitHealth.org.ppy.framework.event.PPYEvent;
	import t6.rabbitHealth.org.ppy.framework.model.IPageModel;
	import t6.rabbitHealth.org.ppy.framework.model.ViewModel;
	import t6.rabbitHealth.org.ppy.framework.util.SoundData;
	import t6.rabbitHealth.org.ppy.framework.util.SoundManager;
	import t6.rabbitHealth.org.ppy.framework.view.ISceneView;

	/**
	 * 切换场景Cmd
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-10-25 下午4:28:15
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
		public var pageModel : IPageModel;
		
		private var _soundManager : SoundManager;
		
		public function ChangeViewCmd()
		{
			_soundManager = SoundManager.getInstance();
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
			var displayName : String = getDisObjName(newView);
			viewSoundPlay(displayName);// 声音控制
			contextView.view.addChild(newView);
		}
		
		private function getDisObjName(display : DisplayObject) : String
		{
			var name : String = String(display).split(" ")[1];
			return name.slice(0, name.length - 1);
		}
		
		// 声音控制
		private function viewSoundPlay(name : String) : void
		{
			_soundManager.stopSound();
			_soundManager.playSound(SoundData.COMMON_SOUND[1]);
			
			var curPage : uint = pageModel.getPage();
			
			switch(name)
			{
				case "GameStartView":
					break;
				case "GameMenuView":
					_soundManager.playSound(SoundData.COMMON_SOUND[0], 0, 999);
					break;
				case "GameTitleView":
					_soundManager.playSound(SoundData.TITLE_SOUND[curPage]);
					break;
				case "GameTrainView":
					if(curPage != pageModel.getMaxPage())
						_soundManager.playSound(SoundData.TRAIN_SOUND[curPage]);
					break;
				default:
					break;
			}
		}
		
		
		
	}
}

















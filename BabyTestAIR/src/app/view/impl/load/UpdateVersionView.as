package app.view.impl.load
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-27 下午2:39:25
	 **/
	public class UpdateVersionView extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function UpdateVersionView()
		{
//			_mainUI = new UpdateModuleUI();
//			this.addChild(_mainUI);
		}
		
		public function btnClose() : SimpleButton
		{
			return _mainUI["mcPanel"]["btnClose"];
		}
		
		public function txtPercent() : TextField
		{
			return _mainUI["mcPanel"]["txtPercent"];
		}
	}
}
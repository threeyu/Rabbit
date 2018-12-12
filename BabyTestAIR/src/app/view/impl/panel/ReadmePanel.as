package app.view.impl.panel
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-16 下午3:10:04
	 **/
	public class ReadmePanel extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function ReadmePanel()
		{
			_mainUI = new ReadmePanelUI();
			this.addChild(_mainUI);
		}
		
		public function btnGo() : SimpleButton
		{
			return _mainUI["btnGo"];
		}
		
		public function btnCancel() : SimpleButton
		{
			return _mainUI["btnCancel"];
		}
	}
}
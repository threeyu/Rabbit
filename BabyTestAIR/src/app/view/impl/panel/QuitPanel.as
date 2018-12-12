package app.view.impl.panel
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import app.view.api.BaseCommonView;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-17 上午10:58:26
	 **/
	public class QuitPanel extends BaseCommonView
	{
		private var _mainUI : Sprite;
		
		public function QuitPanel()
		{
			_mainUI = new QuitPanelUI();
			this.addChild(_mainUI);
		}
		
		public function btnOK() : SimpleButton
		{
			return _mainUI["btnOK"];
		}
		
		public function btnCancel() : SimpleButton
		{
			return _mainUI["btnCancel"];
		}
			
	}
}
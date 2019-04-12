package org.zengrong.robotlegs2.timer.view
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	
	/**
	 * 时间到之后显示的界面
	 * @author zrong (http://zengrong.net)
	 */
	public class AlertView extends VBox implements ITimerView
	{
		
		public function AlertView() 
		{
			myInit();
			myAddChildren();
		}
		
		private var _label:Label;
		private var _dimissBtn:PushButton;
		
		public function get dismissBtn():PushButton
		{
			return _dimissBtn;
		}
		
		private function myInit():void
		{
			this.alignment = VBox.CENTER;
			_label = new Label(this, 0, 0, "Time up!");
			_dimissBtn = new PushButton(this, 0,0, "Dismiss");
		}
		
		private function myAddChildren():void
		{
			
		}
		
	}
}
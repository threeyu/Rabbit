package i6s.babyDrawAndGuess.org.ppy.framework.util
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import i6s.babyDrawAndGuess.org.ppy.framework.model.GameConfig;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-11 上午9:11:10
	 **/
	public class PopUpManager extends Sprite 
	{
		[Inject]
		public var gameConfig : GameConfig;
		
		private static var _instance : PopUpManager;
		
		public function PopUpManager()
		{
		}
		
		public static function getInstance() : PopUpManager
		{
			if(_instance == null)
				_instance = new PopUpManager();
			
			return _instance;
		}
		/**
		 * 
		 * @param view			面板
		 * @param popUpWidth	指定弹窗宽度，定位使用
		 * @param popUpHeight	指定弹窗高度，定位使用
		 * @param effectType	0：没有动画 1:从中间轻微弹出 2：从中间猛烈弹出  3：从左向右 4：从右向左 5、从上到下 6、从下到上
		 * @param isAlert
		 * @return 
		 * 
		 */		
		public function addPopUp(view : DisplayObject, popUpWidth : uint = 0, popUpHeight : Number = 0, effectType : uint = 0, isAlert : Boolean = false) : void
		{
			view.scaleX = 1;
			view.scaleY = 1;
			view.x = 0;
			view.y = 0;
			view.alpha = 1;
			
			if(popUpWidth != 0) {
				view.x = (gameConfig.getStageWidth() - popUpWidth) * 0.5;
				view.y = (gameConfig.getStageHeight() - popUpHeight) * 0.5;
			} else {
				popUpWidth = view.width;
				popUpHeight = view.height;
			}
			
			var leftX : Number = (gameConfig.getStageWidth() - popUpWidth) * 0.5;
			var upY : Number = (gameConfig.getStageHeight() - popUpHeight) * 0.5;
			
			switch(effectType) {
				case 0:
					break;
				case 1:
					view.alpha = 0;
					view.scaleX = 0.5;
					view.scaleY = 0.5;
					view.x = view.x + popUpWidth / 4;
					view.y = view.y + popUpHeight / 4;
					TweenLite.to(view, .3, {alpha : 1, scaleX : 1, scaleY : 1, x : view.x - popUpWidth / 4, y : view.y - popUpHeight / 4, ease :Back.easeOut});
					break;
				default:
					break;
			}
		}
		/**
		 * 
		 * @param view			面板
		 * @param effectType	0：没有动画 1:从中间缩小消失 2：  3：从左向右 4：从右向左 5、从上到下 6、从下到上
		 * @return 
		 * 
		 */		
		public function removePopUp(view : DisplayObject, effectType : uint = 0, onComplete : Function = null) : void
		{
			switch(effectType) {
				case 0:
					break;
				case 1:
					TweenLite.to(view, .3, {alpha : 0, scaleX : 0, scaleY : 0, x : view.x + view.width / 2, y : view.y + view.height / 2, onComplete : onComplete});
					break;
				default:
					break;
			}
			
		}
		
		
		
		
		
		
		
		
		
	}
}
package app.base.manager
{
	import flash.display.Sprite;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-20 下午6:10:55
	 **/
	public class LayerManager extends Sprite
	{
		private static var _instance : LayerManager;
		
		
		/**
		 * 背景层
		 */		
		public var bgLayer : Sprite = new Sprite();
		/**
		 * 场景层
		 */		
		public var sceneLayer : Sprite = new Sprite();
		/**
		 * 关卡层 外部模块的关卡
		 */		
		public var gameLayer : Sprite = new Sprite();
		/**
		 * 主UI层 如底部功能栏、角色信息之类的
		 */		
		public var uiLayer : Sprite = new Sprite();
		/**
		 * 弹框层 如设置、消息之类的
		 */		
		public var panelLayer : Sprite = new Sprite();
		/**
		 * 特效层 如闪烁、飘字之类的
		 */		
		public var effectLayer : Sprite = new Sprite();
		/**
		 * 加载遮罩层 场景切换时加载资源UI
		 */		
		public var loadLayer : Sprite = new Sprite();
		
		
		public function LayerManager()
		{
			init();
		}
		
		public static function getInstance() : LayerManager
		{
			if(_instance == null) {
				_instance = new LayerManager();
			}
			
			return _instance;
		}
		
		private function init() : void
		{
			this.addChild(bgLayer);			// 背景层
			this.addChild(sceneLayer);		// 场景层
			this.addChild(gameLayer);		// 关卡层
			this.addChild(uiLayer);			// 主UI层
			this.addChild(panelLayer);		// 弹框层
			this.addChild(effectLayer);		// 特效层 
			this.addChild(loadLayer);		// 加载遮罩层
		}
	}
}
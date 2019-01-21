package app.conf.constant
{
	/**
	 * 命令号
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-9-21 上午10:55:46
	 **/
	public class CommandID
	{
		public function CommandID()
		{
		}
		
		// ---------------------- cmd 命令 ----------------------
//		public static const DEACTIVATE_LISTEN : String = "deactivate_listen";
		
		public static const ASSETS_LOAD : String = "assets_load";
		public static const INIT_QUESTION_POOL : String = "init_question_pool";
		
		
		public static const CLEAR_BG      : String = "clear_bg";
		public static const CLEAR_SCENE   : String = "clear_scene";
		public static const CLEAR_PANEL   : String = "clear_panel";
		public static const CLEAR_EFFECT  : String = "clear_effect";
		public static const CLEAR_LOAD    : String = "clear_load";
		
		
		
		public static const CHANGE_BG     : String = "change_bg";
		public static const CHANGE_SCENE  : String = "change_scene";
		public static const CHANGE_PANEL  : String = "change_panel";
		public static const CHANGE_EFFECT : String = "change_effect";
		public static const CHANGE_LOAD   : String = "change_load";
		
		
		// -----------------     外部模块命令              -----------------
		public static const CLEAR_GAME    : String = "clear_game";
		// -----------------    一个开始对应一个结束       -----------------
		public static const GAME_START       : String = "game_start";		// 游戏开始
		public static const GAME_OVER        : String = "game_over";			// 游戏结束
		
		public static const EXTMODULE_START  : String = "extmodule_start";  // 每一关开始
		public static const EXTMODULE_OVER   : String = "extmodule_over";   // 每一关结束
		
		
		// ---------------------- api ----------------------
		/**
		 * 参数：<br>
		 * packageName(String)		应用包名<br>
		 * version(String)			当前版本
		 */
		public static const CHECK_VERSION : String = "http://service.alilo.com.cn/appstore/application/checkVersion";
		
		
		
		
	}
}
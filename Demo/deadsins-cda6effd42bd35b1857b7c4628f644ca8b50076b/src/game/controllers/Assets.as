package game.controllers {
	
	public class Assets
	{	
		[Embed(source="../../../embed/Hero.png")]
		public static const Hero:Class;
		
		[Embed(source="../../../embed/Hero.xml", mimeType="application/octet-stream")]
		public static const _heroConfig:Class;	
		
		
		[Embed(source="../../../embed/bgLayer1.jpg")]
		public static const BgLayer1:Class;
		
		[Embed(source="../../../embed/crate.png")]
		public static const _cratePng:Class;	
		
		[Embed(source="../../../embed/shar.png")]
		public static const shar:Class;	
		
		
		[Embed(source="../../../embed/tiles/stone/stone_010.png")]
		public static const stone_tile:Class;
		
		[Embed(source="../../../embed/tiles/stone/stone_010_wide.png")]
		public static const stone_wide:Class;	
		
		
		[Embed(source="../../../embed/tiles/stone/STONE.png")]
		public static const stone_TEMP:Class;	
		
		
	}
}
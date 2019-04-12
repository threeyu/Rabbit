package example._02DragonBonesStarling
{
	import citrus.core.starling.StarlingScene;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.physics.box2d.Box2D;
	import citrus.view.starlingview.AnimationSequence;
	
	import dragonBones.Armature;
	import dragonBones.Bone;
	import dragonBones.factories.StarlingFactory;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2017-7-14 下午2:53:02
	 **/
	public class DragonBonesStarling extends StarlingScene
	{
		
		[Embed(source = "/../embed/dragonbones/DragonWithClothes.png",mimeType = "application/octet-stream")]
		private const _ResourcesData : Class;
		
		[Embed(source="/../embed/dragonbones/Hero.xml", mimeType="application/octet-stream")]
		private const _HeroConfig:Class;
		
		[Embed(source="/../embed/dragonbones/Hero.png")]
		private const _HeroPng:Class;
		
		private var _factory : StarlingFactory;
		private var _armature : Armature;
		
		private var _textureIdx : uint = 0;
		private var _textureList : Array = ["parts/clothes1", "parts/clothes2", "parts/clothes3", "parts/clothes4"];
		
		public function DragonBonesStarling()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_factory = new StarlingFactory();
			_factory.addEventListener(Event.COMPLETE, onTextureComHandler);
			_factory.parseData(new _ResourcesData());
			
			
			var box2d : Box2D = new Box2D();
			box2d.visible = true;
			add(box2d);
			
			add(new Platform({ x : stage.stageWidth / 2, y : stage.stageHeight, width : stage.stageWidth }));
			
			var bm : Bitmap = new _HeroPng();
			var texture : Texture = Texture.fromBitmap(bm);
			var xml : XML = XML(new _HeroConfig());
			var sTextureAtlas : TextureAtlas = new TextureAtlas(texture, xml);
			
			var patch : Hero = new Hero({ x : 300, width : 60, height : 135, view : new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle") });
			add(patch);
		}
		
		
		private function onTextureComHandler(e : Event) : void
		{
			_factory.removeEventListener(Event.COMPLETE, onTextureComHandler);
			
			_armature = _factory.buildArmature("Dragon");
			(_armature.display as Sprite).scaleX = -0.5;
			(_armature.display as Sprite).scaleY = 0.5;
			
			var dragon : Hero = new Hero({ x : 150, width : 60, height : 135, offsetY : 135 / 2, view : _armature, registration : "topLeft" });
			add(dragon);
			
			setTimeout(onChangeClothes, 2000);
		}
		
		private function onChangeClothes() : void
		{
			setTimeout(onChangeClothes, 2000);
			
			_textureIdx++;
			if(_textureIdx >= _textureList.length)
				_textureIdx = _textureIdx - _textureList.length;
			
			var name : String = _textureList[_textureIdx];
			var img : Image = _factory.getTextureDisplay(name) as Image;
			var bone : Bone = _armature.getBone("clothes");
			bone.display.dispose();
			bone.display = img;
		}
		
		
		
		
		
		
		
		
		
		
	}
}
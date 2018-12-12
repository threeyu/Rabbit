package i6s.babyDress.org.ppy.framework.mediator
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import i6s.babyDress.org.ppy.framework.event.PPYEvent;
	import i6s.babyDress.org.ppy.framework.model.SoundModel;
	import i6s.babyDress.org.ppy.framework.util.SoundManager;
	import i6s.babyDress.org.ppy.framework.view.GameGateView_5;
	import i6s.babyDress.org.ppy.framework.view.GameMenuView;
	
	import robotlegs.bender.bundles.mvcs.Mediator;
	
	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-7-25 上午11:20:20
	 **/
	public class GameGateMediator_5 extends Mediator
	{
		[Inject]
		public var view : GameGateView_5;
		
		[Inject]
		public var soundData : SoundModel;
		
		private var _soundManager : SoundManager = SoundManager.getInstance();
		
		private var _isClick : Boolean;
		
		private var _iconId : uint;
		
		public function GameGateMediator_5()
		{
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			initData();
			addEvent();
		}
		
		private function initData() : void
		{
			_iconId = 999;
			
			for(var i : uint = 0; i < 7; ++i) {
				view.mcIcon(i).visible = true;
			}
			view.mcClothes().visible = false;
			view.mcClothes().gotoAndStop(1);
			view.btnOK().visible = true;
			view.mcMov().visible = false;
			view.mcMov().gotoAndStop(1);
			
			// 衣服部件
			view.mcCoat().gotoAndStop(1);
			view.mcShoe().gotoAndStop(1);
			view.mcHat().gotoAndStop(1);
			view.mcScarf().gotoAndStop(1);
			view.mcGlass().gotoAndStop(1);
			view.mcNecklace().gotoAndStop(1);
			view.mcCrown().gotoAndStop(1);
			
			_isClick = false;
			soundPlay(soundData.getTips(5));
		}
		
		private function soundPlay(name : String) : void
		{
			_soundManager.stopSoundExpect(soundData.getEffect(0));
			_soundManager.playSound(name);
		}
		
		private function typeSoundPlay(id : uint) : void
		{
			switch(_iconId) {
				case 0:
					if(id == 0) {
						soundPlay(soundData.getYifuKeyiSound());
					} else if(id == 1) {
						soundPlay(soundData.getRightSound());
					} else if(id == 2) {
						soundPlay(soundData.getBuHeshiSound());
					} else if(id == 3) {
						soundPlay(soundData.getBuHeshiSound());
					}
					break;
				case 1:
					if(id == 0) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 1) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 2) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 3) {
						soundPlay(soundData.getRightSound());
					}
					break;
				case 2:
					if(id == 0) {
						soundPlay(soundData.getRightSound());
					} else if(id == 1) {
						soundPlay(soundData.getRightSound());
					} else if(id == 2) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 3) {
						soundPlay(soundData.getKeyiSound());
					}
					break;
				case 3:
					if(id == 0) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 1) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 2) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 3) {
						soundPlay(soundData.getKeyiSound());
					}
					break;
				case 4:
					if(id == 0) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 1) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 2) {
						soundPlay(soundData.getRightSound());
					} else if(id == 3) {
						soundPlay(soundData.getRightSound());
					}
					break;
				case 5:
					if(id == 0) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 1) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 2) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 3) {
						soundPlay(soundData.getKeyiSound());
					}
					break;
				case 6:
					if(id == 0) {
						soundPlay(soundData.getRightSound());
					} else if(id == 1) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 2) {
						soundPlay(soundData.getKeyiSound());
					} else if(id == 3) {
						soundPlay(soundData.getKeyiSound());
					}
					break;
				default:
					break;
			}
		}
		
		private function gameOver() : void
		{
			for(var i : uint = 0; i < 7; ++i) {
				view.mcIcon(i).visible = false;
			}
			view.mcClothes().visible = false;
			view.mcClothes().gotoAndStop(1);
			view.btnOK().visible = false;
			
			view.mcMov().visible = true;
			view.mcMov().gotoAndPlay(1);
		}
		
		private function onIconHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var name : String  = e.currentTarget.name;
			var i : uint;
			switch(name) {
				case "btnClose":
					view.mcClothes().visible = false;
					view.mcClothes().gotoAndStop(1);
					for(i = 0; i < 7; ++i) {
						view.mcIcon(i).visible = true;
					}
					break;
				default:
					var id : uint = uint(name.split("_")[1]);
					view.mcClothes().visible = true;
					view.mcClothes().gotoAndStop(id + 1);
					for(i = 0; i < 7; ++i) {
						view.mcIcon(i).visible = false;
					}
					
					_iconId = id;
					break;
			}
		}
		
		private function onChangeClothHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var id : uint = uint(e.currentTarget.name.split("_")[1]);
			switch(_iconId) {
				case 0:
					change(view.mcCoat(), id);
					break;
				case 1:
					change(view.mcShoe(), id);
					break;
				case 2:
					change(view.mcHat(), id);
					break;
				case 3:
					change(view.mcScarf(), id);
					break;
				case 4:
					change(view.mcGlass(), id);
					break;
				case 5:
					change(view.mcNecklace(), id);
					break;
				case 6:
					change(view.mcCrown(), id);
					break;
				default:
					break;
			}
		}
		private function change(mcCloth : MovieClip, id : uint) : void
		{
			if(mcCloth.currentFrame != (id + 2)) {
				mcCloth.gotoAndStop(id + 2);
				typeSoundPlay(id);
			} else {
				mcCloth.gotoAndStop(1);
			}
		}
		
		private function onFeatureHandler(e : MouseEvent) : void
		{
			if(_isClick)
				return;
			
			var name : String = e.currentTarget.name;
			switch(name) {
				case "btnClose":
					_isClick = true;
					
					soundPlay(soundData.getEffect(2));
					TweenLite.to(view.btnClose(), 1.2, {onComplete:function():void{
						eventDispatcher.dispatchEvent(new PPYEvent(PPYEvent.CHANGE_VIEW, GameMenuView));
					}});
					break;
				case "wanchengBtn":
					gameOver();
					soundPlay(soundData.getEffect(5));
					break;
				default:
					break;
			}
		}
		
		private function addEvent() : void
		{
			view.btnClose().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOK().addEventListener(MouseEvent.CLICK, onFeatureHandler);
			var i : uint;
			for(i = 0; i < 7; ++i) {
				// 具体部件
				if(i < 4) {
					view.mcCloth(i).addEventListener(MouseEvent.CLICK, onChangeClothHandler);
				}
				// 衣服icon
				view.mcIcon(i).addEventListener(MouseEvent.CLICK, onIconHandler);
			}
			view.btnIconClose().addEventListener(MouseEvent.CLICK, onIconHandler);
		}
		
		private function removeEvent() : void
		{
			view.btnClose().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			view.btnOK().removeEventListener(MouseEvent.CLICK, onFeatureHandler);
			var i : uint;
			for(i = 0; i < 7; ++i) {
				// 具体部件
				if(i < 4) {
					view.mcCloth(i).removeEventListener(MouseEvent.CLICK, onChangeClothHandler);
				}
				// 衣服icon
				view.mcIcon(i).removeEventListener(MouseEvent.CLICK, onIconHandler);
			}
			view.btnIconClose().removeEventListener(MouseEvent.CLICK, onIconHandler);
		}
		
		override public function destroy():void
		{
			removeEvent();
			
			TweenLite.killTweensOf(view.btnClose());
			
			
			super.destroy();
		}
	}
}
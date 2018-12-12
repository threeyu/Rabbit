package app.conf
{
	import app.base.core.cmd.ChangeLayerCmd;
	import app.base.core.cmd.ClearLayerCmd;
	import app.base.core.cmd.GameOverCmd;
	import app.base.core.cmd.GameStartCmd;
	import app.base.core.event.PPYEvent;
	import app.conf.constant.CommandID;
	import app.model.IGamePool;
	import app.model.IGameState;
	import app.model.vo.GamePool;
	import app.model.vo.GameState;
	
	import extmodule.impl.rabbitAnimalFantastic.AnimalFantasticModule3;
	import extmodule.impl.rabbitAnimalFantastic.AnimalFantasticView3;
	import extmodule.impl.rabbitAnimalMath.AnimalMathModule0;
	import extmodule.impl.rabbitAnimalMath.AnimalMathView0;
	import extmodule.impl.rabbitBalloon.BalloonModule1;
	import extmodule.impl.rabbitBalloon.BalloonView1;
	import extmodule.impl.rabbitBicycleSafety.BicycleSafetyModule3;
	import extmodule.impl.rabbitBicycleSafety.BicycleSafetyView3;
	import extmodule.impl.rabbitBirthdayParty.BirthdayPartyModule2;
	import extmodule.impl.rabbitBirthdayParty.BirthdayPartyView2;
	import extmodule.impl.rabbitBlockKingdom.BlockKingdomModule3;
	import extmodule.impl.rabbitBlockKingdom.BlockKingdomView3;
	import extmodule.impl.rabbitBreakfast.BreakfastModule1;
	import extmodule.impl.rabbitBreakfast.BreakfastView1;
	import extmodule.impl.rabbitBusyWeekend.BusyWeekendModule1;
	import extmodule.impl.rabbitBusyWeekend.BusyWeekendView1;
	import extmodule.impl.rabbitCards.MyCardsModule3;
	import extmodule.impl.rabbitCards.MyCardsView3;
	import extmodule.impl.rabbitCards2.MyCards2Module3;
	import extmodule.impl.rabbitCards2.MyCards2View3;
	import extmodule.impl.rabbitCircus.FindCircusModule0;
	import extmodule.impl.rabbitCircus.FindCircusView0;
	import extmodule.impl.rabbitColorInMirror.ColorInMirrorModule0;
	import extmodule.impl.rabbitColorInMirror.ColorInMirrorView0;
	import extmodule.impl.rabbitCount.LikeCountingModule1;
	import extmodule.impl.rabbitCount.LikeCountingView1;
	import extmodule.impl.rabbitCountAndRight.CountAndRightModule0;
	import extmodule.impl.rabbitCountAndRight.CountAndRightView0;
	import extmodule.impl.rabbitDream.MyDreamModule3;
	import extmodule.impl.rabbitDream.MyDreamView3;
	import extmodule.impl.rabbitFarmDay.FarmDayModule0;
	import extmodule.impl.rabbitFarmDay.FarmDayView0;
	import extmodule.impl.rabbitFillColor.FillColorShapeModule0;
	import extmodule.impl.rabbitFillColor.FillColorShapeView0;
	import extmodule.impl.rabbitFillColor2.LikeFillColorModule3;
	import extmodule.impl.rabbitFillColor2.LikeFillColorView3;
	import extmodule.impl.rabbitFillColor3.ObserveFillColorModule3;
	import extmodule.impl.rabbitFillColor3.ObserveFillColorView3;
	import extmodule.impl.rabbitFillColor4.LookAndFillColorModule0;
	import extmodule.impl.rabbitFillColor4.LookAndFillColorView0;
	import extmodule.impl.rabbitFindAndCount.FindAndCountModule0;
	import extmodule.impl.rabbitFindAndCount.FindAndCountView0;
	import extmodule.impl.rabbitFindAndMatch.FindAndMatchModule1;
	import extmodule.impl.rabbitFindAndMatch.FindAndMatchView1;
	import extmodule.impl.rabbitFindCount.FindCountModule0;
	import extmodule.impl.rabbitFindCount.FindCountView0;
	import extmodule.impl.rabbitFindDifference.FindDifferModule1;
	import extmodule.impl.rabbitFindDifference.FindDifferView1;
	import extmodule.impl.rabbitFindDifference2.FindSomeDiffModule1;
	import extmodule.impl.rabbitFindDifference2.FindSomeDiffView1;
	import extmodule.impl.rabbitFindDifference3.KnowledgeRaceModule0;
	import extmodule.impl.rabbitFindDifference3.KnowledgeRaceView0;
	import extmodule.impl.rabbitFoodAssort.FoodAssortModule0;
	import extmodule.impl.rabbitFoodAssort.FoodAssortView0;
	import extmodule.impl.rabbitFunAnimals.FunAnimalsModule0;
	import extmodule.impl.rabbitFunAnimals.FunAnimalsView0;
	import extmodule.impl.rabbitFunFarm.FunFarmModule0;
	import extmodule.impl.rabbitFunFarm.FunFarmView0;
	import extmodule.impl.rabbitFunSeq.FunSeqModule0;
	import extmodule.impl.rabbitFunSeq.FunSeqView0;
	import extmodule.impl.rabbitHandwork.MyHandwordModule3;
	import extmodule.impl.rabbitHandwork.MyHandwordView3;
	import extmodule.impl.rabbitLearnDraw.LearnDrawModule0;
	import extmodule.impl.rabbitLearnDraw.LearnDrawView0;
	import extmodule.impl.rabbitLearnMatch.LearnMatchModule0;
	import extmodule.impl.rabbitLearnMatch.LearnMatchView0;
	import extmodule.impl.rabbitLikeDraw.LikeDrawModule3;
	import extmodule.impl.rabbitLikeDraw.LikeDrawView3;
	import extmodule.impl.rabbitLikeWriting.LikeWritingModule0;
	import extmodule.impl.rabbitLikeWriting.LikeWritingView0;
	import extmodule.impl.rabbitLineUp.FindFoodModule0;
	import extmodule.impl.rabbitLineUp.FindFoodView0;
	import extmodule.impl.rabbitLineUp2.TryAndLineModule0;
	import extmodule.impl.rabbitLineUp2.TryAndLineView0;
	import extmodule.impl.rabbitLineUp3.DancePartyModule1;
	import extmodule.impl.rabbitLineUp3.DancePartyView1;
	import extmodule.impl.rabbitLineUp4.SceneLineUpModule4;
	import extmodule.impl.rabbitLineUp4.SceneLineUpView3;
	import extmodule.impl.rabbitLineUp5.BusyFarmModule3;
	import extmodule.impl.rabbitLineUp5.BusyFarmView3;
	import extmodule.impl.rabbitLookAndFind.LookAndFindModule0;
	import extmodule.impl.rabbitLookAndFind.LookAndFindView0;
	import extmodule.impl.rabbitLookCareful.LookCarefulModule0;
	import extmodule.impl.rabbitLookCareful.LookCarefulView0;
	import extmodule.impl.rabbitMaganaHouse.MaganaHouseModule1;
	import extmodule.impl.rabbitMaganaHouse.MaganaHouseView1;
	import extmodule.impl.rabbitManyShape.ManyShapeModule0;
	import extmodule.impl.rabbitManyShape.ManyShapeView0;
	import extmodule.impl.rabbitMorning.MyMorningModule1;
	import extmodule.impl.rabbitMorning.MyMorningView1;
	import extmodule.impl.rabbitNumberMatch.NumberMatchModule0;
	import extmodule.impl.rabbitNumberMatch.NumberMatchView0;
	import extmodule.impl.rabbitNumberWorld.NumberWorldModule0;
	import extmodule.impl.rabbitNumberWorld.NumberWorldView0;
	import extmodule.impl.rabbitObservedBoy.ObservedBoyModule0;
	import extmodule.impl.rabbitObservedBoy.ObservedBoyView0;
	import extmodule.impl.rabbitPatternAround.PatternAroundModule3;
	import extmodule.impl.rabbitPatternAround.PatternAroundView3;
	import extmodule.impl.rabbitPet.MyPetModule1;
	import extmodule.impl.rabbitPet.MyPetView1;
	import extmodule.impl.rabbitPetManual.PetManualModule0;
	import extmodule.impl.rabbitPetManual.PetManualView0;
	import extmodule.impl.rabbitPlayAndCount.PlayCountModule3;
	import extmodule.impl.rabbitPlayAndCount.PlayCountView3;
	import extmodule.impl.rabbitPlayGame.PlayGameModule1;
	import extmodule.impl.rabbitPlayGame.PlayGameView1;
	import extmodule.impl.rabbitPlayInZoo.PlayInZooModule0;
	import extmodule.impl.rabbitPlayInZoo.PlayInZooView0;
	import extmodule.impl.rabbitPlayMatch.PlayMatchModule0;
	import extmodule.impl.rabbitPlayMatch.PlayMatchView0;
	import extmodule.impl.rabbitPlayNumber.PlayNumberModule0;
	import extmodule.impl.rabbitPlayNumber.PlayNumberView0;
	import extmodule.impl.rabbitPlaygroundDay.PlaygroundDayModule1;
	import extmodule.impl.rabbitPlaygroundDay.PlaygroundDayView1;
	import extmodule.impl.rabbitPlaygroundFun.PlaygroundFunModule1;
	import extmodule.impl.rabbitPlaygroundFun.PlaygroundFunView1;
	import extmodule.impl.rabbitRecognizeNum.RecognizeNumModule1;
	import extmodule.impl.rabbitRecognizeNum.RecognizeNumView1;
	import extmodule.impl.rabbitRecycling.RecyclingModule3;
	import extmodule.impl.rabbitRecycling.RecyclingView3;
	import extmodule.impl.rabbitStrangeWeek.StrangeWeekModule0;
	import extmodule.impl.rabbitStrangeWeek.StrangeWeekView0;
	import extmodule.impl.rabbitToObAnimals.ToObAnimalsModule0;
	import extmodule.impl.rabbitToObAnimals.ToObAnimalsView0;
	import extmodule.impl.rabbitTortoise.LovelyTortoiseModule3;
	import extmodule.impl.rabbitTortoise.LovelyTortoiseView3;
	import extmodule.impl.rabbitToyBrick.ToyBrickModule0;
	import extmodule.impl.rabbitToyBrick.ToyBrickView0;
	import extmodule.impl.rabbitToys.MyToysModule1;
	import extmodule.impl.rabbitToys.MyToysView1;
	import extmodule.impl.rabbitToys2.FindMyToysModule0;
	import extmodule.impl.rabbitToys2.FindMyToysView0;
	import extmodule.impl.rabbitTraffic.TrafficLearnModule1;
	import extmodule.impl.rabbitTraffic.TrafficLearnView1;
	import extmodule.impl.rabbitTraffic2.TrafficKnowModule1;
	import extmodule.impl.rabbitTraffic2.TrafficKnowView1;
	import extmodule.impl.rabbitTraffic3.TrafficSymbolModule0;
	import extmodule.impl.rabbitTraffic3.TrafficSymbolView0;
	import extmodule.impl.rabbitTraffic4.TrafficColorModule3;
	import extmodule.impl.rabbitTraffic4.TrafficColorView3;
	import extmodule.impl.rabbitWardobe.WardobeModule0;
	import extmodule.impl.rabbitWardobe.WardobeView0;
	import extmodule.impl.rabbitWatchAndArray.WatchAndArrayModule0;
	import extmodule.impl.rabbitWatchAndArray.WatchAndArrayView0;
	import extmodule.impl.rabbitWonderfulDream.WonderfulDreamModule0;
	import extmodule.impl.rabbitWonderfulDream.WonderfulDreamView0;
	
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * @author: puppy
	 * @version: 1.0
	 * @time: 2018-10-10 下午7:03:38
	 **/
	public class ExtmoduleConfig implements IConfig
	{
		[Inject]
		public var injector : IInjector;
		
		[Inject]
		public var mediatorMap : IMediatorMap;
		
		[Inject]
		public var commandMap : IEventCommandMap;
		
		public function ExtmoduleConfig()
		{
		}
		
		public function configure() : void
		{
			trace("--------- ExtmoduleConfig.configure()");
			
			initModels();
			initServices();
			
			initMediators();
			
			initCommands();
		}
		
		private function initModels() : void
		{
			injector.map(IGameState).toSingleton(GameState);
			injector.map(IGamePool).toSingleton(GamePool);
		}
		
		private function initServices() : void
		{
			
		}
		
		private function initMediators() : void
		{
			mediatorMap.map(WardobeView0).toMediator(WardobeModule0);
			mediatorMap.map(BalloonView1).toMediator(BalloonModule1);
			mediatorMap.map(PatternAroundView3).toMediator(PatternAroundModule3);
			mediatorMap.map(MyDreamView3).toMediator(MyDreamModule3);
			mediatorMap.map(FindCircusView0).toMediator(FindCircusModule0);
			mediatorMap.map(LearnDrawView0).toMediator(LearnDrawModule0);
			mediatorMap.map(BreakfastView1).toMediator(BreakfastModule1);
			mediatorMap.map(MyMorningView1).toMediator(MyMorningModule1);
			mediatorMap.map(PlayGameView1).toMediator(PlayGameModule1);
			mediatorMap.map(LikeDrawView3).toMediator(LikeDrawModule3);
			mediatorMap.map(WonderfulDreamView0).toMediator(WonderfulDreamModule0);
			mediatorMap.map(MyToysView1).toMediator(MyToysModule1);
			mediatorMap.map(MyCardsView3).toMediator(MyCardsModule3);
			mediatorMap.map(ToyBrickView0).toMediator(ToyBrickModule0);
			mediatorMap.map(MyHandwordView3).toMediator(MyHandwordModule3);
			mediatorMap.map(RecyclingView3).toMediator(RecyclingModule3);
			mediatorMap.map(RecognizeNumView1).toMediator(RecognizeNumModule1);
			mediatorMap.map(FindDifferView1).toMediator(FindDifferModule1);
			mediatorMap.map(LikeCountingView1).toMediator(LikeCountingModule1);
			mediatorMap.map(LovelyTortoiseView3).toMediator(LovelyTortoiseModule3);
			mediatorMap.map(MyCards2View3).toMediator(MyCards2Module3);
			mediatorMap.map(PlayCountView3).toMediator(PlayCountModule3);
			
			mediatorMap.map(TrafficLearnView1).toMediator(TrafficLearnModule1);
			mediatorMap.map(TrafficKnowView1).toMediator(TrafficKnowModule1);
			mediatorMap.map(BicycleSafetyView3).toMediator(BicycleSafetyModule3);
			mediatorMap.map(TrafficSymbolView0).toMediator(TrafficSymbolModule0);
			mediatorMap.map(TrafficColorView3).toMediator(TrafficColorModule3);
			mediatorMap.map(MyPetView1).toMediator(MyPetModule1);
			mediatorMap.map(AnimalMathView0).toMediator(AnimalMathModule0);
			mediatorMap.map(AnimalFantasticView3).toMediator(AnimalFantasticModule3);
			mediatorMap.map(MaganaHouseView1).toMediator(MaganaHouseModule1);
			mediatorMap.map(BusyWeekendView1).toMediator(BusyWeekendModule1);
			mediatorMap.map(LookAndFindView0).toMediator(LookAndFindModule0);
			mediatorMap.map(PlaygroundDayView1).toMediator(PlaygroundDayModule1);
			mediatorMap.map(PlaygroundFunView1).toMediator(PlaygroundFunModule1);
			mediatorMap.map(BirthdayPartyView2).toMediator(BirthdayPartyModule2);
			mediatorMap.map(BlockKingdomView3).toMediator(BlockKingdomModule3);
			mediatorMap.map(FillColorShapeView0).toMediator(FillColorShapeModule0);
			mediatorMap.map(LikeFillColorView3).toMediator(LikeFillColorModule3);
			mediatorMap.map(ObserveFillColorView3).toMediator(ObserveFillColorModule3);
			mediatorMap.map(LookAndFillColorView0).toMediator(LookAndFillColorModule0);
			mediatorMap.map(FindMyToysView0).toMediator(FindMyToysModule0);
			mediatorMap.map(ManyShapeView0).toMediator(ManyShapeModule0);
			mediatorMap.map(LearnMatchView0).toMediator(LearnMatchModule0);
			mediatorMap.map(PetManualView0).toMediator(PetManualModule0);
			mediatorMap.map(FindFoodView0).toMediator(FindFoodModule0);
			mediatorMap.map(TryAndLineView0).toMediator(TryAndLineModule0);
			mediatorMap.map(DancePartyView1).toMediator(DancePartyModule1);
			mediatorMap.map(FindAndCountView0).toMediator(FindAndCountModule0);
			mediatorMap.map(StrangeWeekView0).toMediator(StrangeWeekModule0);
			mediatorMap.map(FindSomeDiffView1).toMediator(FindSomeDiffModule1);
			mediatorMap.map(FindAndMatchView1).toMediator(FindAndMatchModule1);
			mediatorMap.map(KnowledgeRaceView0).toMediator(KnowledgeRaceModule0);
			
			mediatorMap.map(ObservedBoyView0).toMediator(ObservedBoyModule0);
			mediatorMap.map(PlayMatchView0).toMediator(PlayMatchModule0);
			mediatorMap.map(WatchAndArrayView0).toMediator(WatchAndArrayModule0);
			mediatorMap.map(ColorInMirrorView0).toMediator(ColorInMirrorModule0);
			mediatorMap.map(PlayInZooView0).toMediator(PlayInZooModule0);
			mediatorMap.map(FunAnimalsView0).toMediator(FunAnimalsModule0);
			mediatorMap.map(FoodAssortView0).toMediator(FoodAssortModule0);
			mediatorMap.map(ToObAnimalsView0).toMediator(ToObAnimalsModule0);
			mediatorMap.map(FarmDayView0).toMediator(FarmDayModule0);
			mediatorMap.map(FindCountView0).toMediator(FindCountModule0);
			mediatorMap.map(FunFarmView0).toMediator(FunFarmModule0);
			mediatorMap.map(LookCarefulView0).toMediator(LookCarefulModule0);
			mediatorMap.map(CountAndRightView0).toMediator(CountAndRightModule0);
			mediatorMap.map(PlayNumberView0).toMediator(PlayNumberModule0);
			mediatorMap.map(NumberWorldView0).toMediator(NumberWorldModule0);
			mediatorMap.map(NumberMatchView0).toMediator(NumberMatchModule0);
			mediatorMap.map(LikeWritingView0).toMediator(LikeWritingModule0);
			mediatorMap.map(FunSeqView0).toMediator(FunSeqModule0);
			mediatorMap.map(SceneLineUpView3).toMediator(SceneLineUpModule4);
			mediatorMap.map(BusyFarmView3).toMediator(BusyFarmModule3);
		}
		
		private function initCommands() : void
		{
			// 游戏开始、结束命令
			commandMap.map(CommandID.GAME_START, PPYEvent).toCommand(GameStartCmd);
			commandMap.map(CommandID.GAME_OVER, PPYEvent).toCommand(GameOverCmd);
			
			
			// 外部模块启动命令
			commandMap.map(CommandID.EXTMODULE_START).toCommand(ChangeLayerCmd);
			
			
			// 清除游戏层命令
			commandMap.map(CommandID.CLEAR_GAME).toCommand(ClearLayerCmd);
		}
	}
}
package com.lcarpentier.ld
{
	import com.greensock.TweenNano;
	import com.lcarpentier.ld.game.MonthGameplay;
	import com.lcarpentier.ld.manager.XMLManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class Main extends Sprite 
	{
		private var startScreen:StartScreen;
		private var loadingScreen:ScreenLoading;
		
		private var currentScreen:Sprite;
			
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			startScreen = new StartScreen();
			addChild(startScreen);
			
			currentScreen = startScreen;
			
			startScreen.btnPlay.addEventListener(MouseEvent.CLICK, playClicked);
			
			loadingScreen = new ScreenLoading();
			addChild(loadingScreen);
			
			var xmlManager:XMLManager = new XMLManager();
			xmlManager.loadingOver.addOnce(endOfLoading);
		}
		
		private function playClicked(e:MouseEvent):void
		{
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			//launch actual game
			
			var firstMonth:MonthGameplay = new MonthGameplay();
			currentScreen = firstMonth;
			addChild(firstMonth);
			firstMonth.monthIsOver.addOnce(endOfAMonth);
			
		}
		
		//--------------------------------------------------------------------------
		// SIGNAL LISTENERS
		//--------------------------------------------------------------------------
		
		private function endOfLoading(xmlManager:XMLManager):void
		{
			removeChild(loadingScreen);
		}
		
		private function endOfAMonth():void
		{
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
		}
		
	}
	
}
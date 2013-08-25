package com.lcarpentier.ld
{
	import com.greensock.TweenNano;
	import com.lcarpentier.ld.game.DebateGameplay;
	import com.lcarpentier.ld.game.DebriefBox;
	import com.lcarpentier.ld.game.MonthGameplay;
	import com.lcarpentier.ld.manager.Global;
	import com.lcarpentier.ld.manager.SoundManager;
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
			startScreen.btnPlay.useHandCursor = true;
			startScreen.btnPlay.buttonMode = true;
			
			loadingScreen = new ScreenLoading();
			addChild(loadingScreen);
			
			var xmlManager:XMLManager = new XMLManager();
			xmlManager.loadingOver.addOnce(endOfLoading);
		}
		
		private function playClicked(e:MouseEvent):void
		{
			SoundManager.getInstance().action();
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			//launch actual game
			
			launchCampaignMonth();
			
		}
		
		private function launchCampaignMonth():void
		{
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
			
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
			SoundManager.getInstance().intro();
			removeChild(loadingScreen);
		}
		
		private function endOfAMonth():void
		{
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			var firstDebate:DebateGameplay = new DebateGameplay();
			addChild(firstDebate);
			currentScreen = firstDebate;
			
			firstDebate.debateOver.addOnce(endOfDebate);
		}
		
		private function endOfDebate():void
		{
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			var debrief:DebriefBox = new DebriefBox();
			addChild(debrief);
			currentScreen = debrief;
			
			debrief.debriefValidate.addOnce(newMonth);
		}
		
		private function newMonth():void
		{
			if(Global.round < 4) 
			{
				launchCampaignMonth();
			} else {
				electionDay();
			}
		}
		
		private function electionDay():void
		{
			if(currentScreen){
				removeChild(currentScreen);
				currentScreen = null;
			}
			
			var election:ScreenElectionDay = new ScreenElectionDay();
			addChild(election);
			currentScreen = election;
			election.gotoAndStop(Global.votes > 50 ? 1 : 2);
			
			if (Global.votes < 50) {
				SoundManager.getInstance().gameOver();
				election.txtTitle.text = "You lost the election by " + String(50 - Global.votes) +"%";
				election.txtSubtitle.text = "Remember to always blame immigrants. Also, no gun control. Ever.";
				election.txtPlayAgain.text = "retry...";
			} if (Global.votes == 50) {
				election.txtTitle.text = "You lost the election at the last minute...";
				election.txtSubtitle.text = "But you're almost there. 4 years is nothing...";
				election.txtPlayAgain.text = "retry...";
			}
			
			election.mouseChildren = false;
			election.addEventListener(MouseEvent.CLICK, relaunchGame);
		}
		
		private function relaunchGame(e:MouseEvent):void
		{
			SoundManager.getInstance().action();
			Global.raz();
			currentScreen.removeEventListener(MouseEvent.CLICK, relaunchGame);
			newMonth();
		}
	}
	
}
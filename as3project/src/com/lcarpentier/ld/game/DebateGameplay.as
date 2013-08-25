package com.lcarpentier.ld.game 
{
	import com.greensock.TweenMax;
	import com.greensock.TweenNano;
	import com.lcarpentier.ld.manager.Global;
	import com.lcarpentier.ld.manager.SoundManager;
	import com.lcarpentier.ld.vo.DebateEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class DebateGameplay extends Sprite 
	{
		
		private var display:ScreenDebate;
		private var timer:int = 0;
		private var itsOver:Boolean = false;
		private var questionIndex:int = 0;
		private var answerIndex1:int = 0;
		private var answerIndex2:int = 0;
		
		public var debateOver:Signal = new Signal();
		
		
		public function DebateGameplay() 
		{
			display = new ScreenDebate();
			addChild(display);
			
			display.notice.mouseChildren = false;
			display.notice.useHandCursor = true;
			display.notice.buttonMode = true;
			display.notice.addEventListener(MouseEvent.CLICK, launchDebate);
			
			//TODO HANDLE QUESTION
			questionIndex = Math.floor(Math.random()*Global.debateEvents.length);
			
			var  vo:DebateEvent = Global.debateEvents[questionIndex];
			
			answerIndex1 = Math.floor(Math.random()*vo.answers.length);
			answerIndex2 = Math.floor(Math.random()*(vo.answers.length-1));
			
			if (answerIndex2 >= answerIndex1) { answerIndex2++; }
			
			display.questionDisplay.txtQuestion.text = vo.question;
			display.answer1.text = vo.answers[answerIndex1]+" •";
			display.answer1.autoSize = TextFieldAutoSize.RIGHT;
			display.answer2.text = vo.answers[answerIndex2]+" •";
			display.answer2.autoSize = TextFieldAutoSize.RIGHT;
			
			display.spot.alpha = 0.4;
			
			if (Global.round >= 2)
			{
				display.opo1.visible = false;
			}
			if (Global.round >= 3)
			{
				display.opo2.visible = false;
			}
			
		}
		
		public function launchDebate(e:MouseEvent):void {
			
			//fade from black
			
			TweenNano.to(display.notice, 0.4, { alpha:0, onComplete:function():void { display.notice.visible = false; launchTimer(); }} );
			
			
			//Set answers
			display.answer1.addEventListener(MouseEvent.CLICK, answerClicked);
			display.answer2.addEventListener(MouseEvent.CLICK, answerClicked);
		}
		
		public function launchTimer():void {
			SoundManager.getInstance().timerBip();
			TweenNano.delayedCall(1, bipTimer);
			
		}
		
		public function bipTimer():void {
			if (itsOver) { return void; };
			timer++;
			if (timer >= 10) {
				SoundManager.getInstance().letDown();
				displayResults();
			} else {
				SoundManager.getInstance().timerBip();
				TweenNano.delayedCall(1, bipTimer);
			}
		}
		
		private function answerClicked(e:MouseEvent):void
		{
			itsOver = true;
			
			//I can't believe you slept AND wrote that code. You have no excuse.
			
			if ( e.currentTarget == display.answer1 && Global.debateEvents[questionIndex].typeIsVote[answerIndex1]) {
				display.pollingsWon.visible = false;
				display.votersWon.txtValue.text = "+" + Global.debateEvents[questionIndex].rewards[answerIndex1] + "%";
				Global.votes += Global.debateEvents[questionIndex].rewards[answerIndex1];
			} else if ( e.currentTarget == display.answer2 && Global.debateEvents[questionIndex].typeIsVote[answerIndex2]) {
				display.pollingsWon.visible = false;
				display.votersWon.txtValue.text = "+" + Global.debateEvents[questionIndex].rewards[answerIndex2] + "%";
				Global.votes += Global.debateEvents[questionIndex].rewards[answerIndex2];
			} else {
				display.votersWon.visible = false;
				if (e.currentTarget == display.answer1) {
					display.pollingsWon.txtValue.text = "+" + Global.debateEvents[questionIndex].rewards[answerIndex1] + "%";
					Global.poll += Global.debateEvents[questionIndex].rewards[answerIndex1];
				} else {
					display.pollingsWon.txtValue.text = "+" + Global.debateEvents[questionIndex].rewards[answerIndex2] + "%";
					Global.poll += Global.debateEvents[questionIndex].rewards[answerIndex2];
				}
			}
				
			display.answer1.removeEventListener(MouseEvent.CLICK, answerClicked);
			display.answer2.removeEventListener(MouseEvent.CLICK, answerClicked);
			
			//tween them
			TweenNano.to(display.answer1, 0.4, { alpha:0 } );

			TweenNano.to(display.answer2, 0.4, { alpha:0 } );
			
			//Tween question
			TweenNano.to(display.questionDisplay, 0.4, { alpha:0 } );
			
			//add results
			display.votersWon.x = 200;
			display.votersWon.y = 410;
			display.pollingsWon.x = 200;
			display.pollingsWon.y = 410;
			
			TweenNano.to(display.votersWon, 1.2, { y:200 } );
			TweenNano.to(display.pollingsWon, 1.2, { y:200 } );
			
			TweenNano.to(display.spot, 0.5, {alpha:0 } );
			
			//display results
			TweenNano.delayedCall(2.4, displayResults);
		}
		
		private function displayResults():void
		{
			// fade to black
			var blackSprite:Sprite = new Sprite();
			addChild(blackSprite);
			blackSprite.alpha = 0;
			blackSprite.graphics.beginFill(0x000000, 1);
			blackSprite.graphics.drawRect(0, 0, 800, 600);
			blackSprite.graphics.endFill();
			
			TweenNano.to(blackSprite, 0.4, { alpha:1, onComplete:function():void { debateOver.dispatch(); }} );
		}
		
	}

}
package com.lcarpentier.ld.game 
{
	import com.greensock.TweenNano;
	import com.lcarpentier.ld.manager.Global;
	import com.lcarpentier.ld.manager.SoundManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class MonthGameplay extends Sprite
	{
		public var monthIsOver:Signal = new Signal();
		
		private var display:ScreenCampaign;
		
		private var cards:Vector.<CardInstance> = new Vector.<CardInstance>();
		private var buttons:Array = new Array(); //Smell like jam spirit
		
		private var opponents:Vector.<int> = new Vector.<int>();
		private var opponentsRatio:Vector.<int> = new Vector.<int>();
		
		public var round:int = Global.round;
		
		public function MonthGameplay() 
		{
			display = new ScreenCampaign();
			
			display.button1.visible = false;
			display.button1.stop();
			buttons.push(display.button1);
			display.button2.visible = false;
			display.button2.stop();
			buttons.push(display.button2);
			display.button3.visible = false;
			display.button3.stop();
			buttons.push(display.button3);
			
			display.calendar.txtMonth.text = Global.months[Global.month-1];
			
			updateDisplays();
			
			display.mouseEnabled = false;
			
			addChild(display);
			
			drawCards();
			
			
			
			//Handle other candidates
			opponents.push(Global.birchlady);
			display.pollsDisplay.opo1.candidateName.text = "Birchlady";
			display.pollsDisplay.opo1.mariostar.visible = false;
			if (round < 3)
			{
				opponents.push(Global.oakdude);
				display.pollsDisplay.opo2.candidateName.text = "Oakdude";
				display.pollsDisplay.opo2.mariostar.visible = false;
			} else { display.pollsDisplay.opo2.visible = false; }
			if (round < 2)
			{
				opponents.push(Global.ashgirl);
				display.pollsDisplay.opo3.candidateName.text = "Ashgirl";
				display.pollsDisplay.opo3.mariostar.visible = false;
			}else { display.pollsDisplay.opo3.visible = false; }
			
			switch (round) 
			{
				case 1:
					opponentsRatio.push(50);
					opponentsRatio.push(35);
					opponentsRatio.push(15);
				break;
				case 2:
					opponentsRatio.push(65);
					opponentsRatio.push(35);
					display.pollsDisplay.yourself.x += 20;
					display.pollsDisplay.opo1.x += 20;
					display.pollsDisplay.opo2.x += 20;
				break;
				case 3:
					opponentsRatio.push(100);
					display.pollsDisplay.yourself.x += 40;
					display.pollsDisplay.opo1.x += 40;
				break;
				default:
			}
			
			for (var i:int = 0; i < opponents.length; i++) 
			{
				(display.pollsDisplay.getChildByName("opo" + String(i + 1)) as MovieClip).pollCount.text = opponents[i] + "%";
				(display.pollsDisplay.getChildByName("opo" + String(i + 1)) as MovieClip).bar.height = opponents[i];
				
			}
			
		}
		
		private function cleanCards():void
		{
			for (var i:int = cards.length-1; i >= 0; i--) 
			{
				cards[i].removeEventListener(MouseEvent.CLICK, eventChosen);
				removeChild(cards[i]); //Fade it maybe ?
				cards.splice(i, 1);
			}
		}
		
		private function drawCards():void
		{
			var cardsIndex:Vector.<int> = new Vector.<int>();
			
			for (var j:int = 0; j < Global.campaignEvents.length; j++) 
			{
				cardsIndex.push(j);
			}
			
			for (var i:int = 0; i < 3; i++) 
			{
				var cardIndex:int = int(cardsIndex[int(cardsIndex.length * Math.random())]);
				cardsIndex.splice(cardIndex, 1);
				
				
				var card:CardInstance = new CardInstance(Global.campaignEvents[cardIndex]);
				card.x = - 150;
				card.y = 800;
				addChild(card);
				
				cards.push(card);
				
				TweenNano.delayedCall(0.175 * i, delayedSlide, [card, (buttons[i] as Sprite).x, (buttons[i] as Sprite).y]);
				
				card.addEventListener(MouseEvent.CLICK, eventChosen);
				
			}
			
		}
		
		private function delayedSlide(targ:CardInstance, targX:int, targY:int):void
		{
			TweenNano.to(targ, 0.3, { x : targX, y : targY } );
		}
		
		private function eventChosen(e:MouseEvent):void
		{
			var card:CardInstance = e.currentTarget as CardInstance;
			
			SoundManager.getInstance().action();
			
			//Add votes and poll
			Global.votes += card.vote;
			Global.votes = Math.max(Global.votes, 0);
			Global.votes = Math.min(Global.votes, 100);
			
			Global.poll += card.poll;
			Global.poll = Math.max(Global.poll, 0);
			Global.poll = Math.min(Global.poll, 100);
			
			for (var i:int = 0; i < opponents.length; i++) 
			{
				opponents[i] = (100 - Global.poll) * opponentsRatio[i]/100;
			}
			
			//Change date
			Global.day += card.delay;
			
			updateDisplays();
			
			//clean all cards
			
			cleanCards();
			
			//check if finished
			
			if (Global.day > Global.monthLimit) //handle 31
			{
				//fade to black
				var blackSprite:Sprite = new Sprite();
				addChild(blackSprite);
				blackSprite.alpha = 0;
				blackSprite.graphics.beginFill(0x000000, 1);
				blackSprite.graphics.drawRect(0, 0, 800, 600);
				blackSprite.graphics.endFill();
				
				TweenNano.to(blackSprite, 0.4, { alpha:1 } );
				
				
				//end 
				TweenNano.delayedCall(0.7, function():void{
					monthIsOver.dispatch();
				});
			} else {
				
				//draw new cards
				
				drawCards();
			}
		}
		
		private function updateDisplays():void
		{
			//update votes
			display.voteCount.text = Global.votes + "%";
			(display.voteWheel.wheel as MovieClip).rotation = (Global.votes / 100) * 180 + 90;
			
			//update polls
			display.pollsDisplay.yourself.pollCount.text = Global.poll + "%";
			display.pollsDisplay.yourself.bar.height = Global.poll;
			
			//Handle other candidates
			for (var i:int = 0; i < opponents.length; i++) 
			{
				(display.pollsDisplay.getChildByName("opo" + String(i + 1)) as MovieClip).pollCount.text = opponents[i] + "%";
				(display.pollsDisplay.getChildByName("opo" + String(i + 1)) as MovieClip).bar.height = opponents[i];
				
			}
			
			//display.pollCount.text = "Polls : " + Global.poll;
			
			
			//Update calendar
			display.calendar.txtDate.text = Math.min(Global.day, Global.monthLimit) + "";
		}
		
	}

}
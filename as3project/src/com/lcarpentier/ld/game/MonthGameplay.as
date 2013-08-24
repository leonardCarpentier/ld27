package com.lcarpentier.ld.game 
{
	import com.greensock.TweenNano;
	import com.lcarpentier.ld.manager.Global;
	import flash.display.Sprite;
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
			
			display.calendar.txtMonth.text = "JAN";
			
			updateDisplays();
			
			display.mouseEnabled = false;
			
			addChild(display);
			
			drawCards();
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
			for (var i:int = 0; i < 3; i++) 
			{
				var card:CardInstance = new CardInstance(Global.campaignEvents[int(Global.campaignEvents.length * Math.random())]);
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
			
			//Add votes and poll
			Global.votes += card.vote;
			Global.poll += card.poll;
			
			//Change date
			Global.day += card.delay;
			
			updateDisplays();
			
			//clean all cards
			
			cleanCards();
			
			//check if finished
			
			if (Global.day > Global.monthLimit) //handle 31
			{
				monthIsOver.dispatch();
			} else {
				
				//draw new cards
				
				drawCards();
			}
		}
		
		private function updateDisplays():void
		{
			display.voteCount.text = "Votes : " + Global.votes;
			display.pollCount.text = "Polls : " + Global.poll;
			display.calendar.txtDate.text = Global.day + "";
		}
		
	}

}
package com.lcarpentier.ld.game 
{
	import com.greensock.TweenNano;
	import com.lcarpentier.ld.manager.Global;
	import com.lcarpentier.ld.manager.SoundManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class DebriefBox extends Sprite 
	{
		private var display:ScreenDebrief;
		
		public var debriefValidate:Signal = new Signal();
		
		public function DebriefBox() 
		{
			display = new ScreenDebrief();
			addChild(display);
			
			//fade from black
			var blackSprite:Sprite = new Sprite();
			addChild(blackSprite);
			blackSprite.alpha = 1;
			blackSprite.graphics.beginFill(0x000000, 1);
			blackSprite.graphics.drawRect(0, 0, 800, 600);
			blackSprite.graphics.endFill();
			
			TweenNano.to(blackSprite, 0.4, { alpha:0, onComplete:function(s:Sprite):void { removeChild(s); }, onCompleteParams:[blackSprite] } );
			
			var st:String = ((Global.votes - Global.debriefVote) > 0 )? "+" : "";
			display.txtVote.text = st + String(Global.votes - Global.debriefVote) + "% ("+Global.votes+"%)";
			Global.debriefVote = Global.votes;
			
			var s:String = ((Global.poll - Global.debriefPoll) > 0 )? "+" : "";
			display.txtPoll.text = s + String(Global.poll - Global.debriefPoll) + "% ("+Global.poll+"%)";
			Global.debriefPoll = Global.poll;
			
			switch (Global.round) 
			{
				case 1:
					display.txtTitle.text = "First month of campaign";
				break;
				case 2:
					display.txtTitle.text = "Second month of campaign";
				break;
			default:
				display.txtTitle.text = "Last month of campaign";
			}
			
			//check for defeat
			var eliminated:Boolean = false;
			switch (Global.round) 
			{
				case 1:
					if (Global.poll < 0.15 * (100 - Global.poll)) { eliminated = true; }
				break;
				case 2:
					if (Global.poll < 0.35 * (100 - Global.poll)) { eliminated = true; }
				break;
				case 3:
					if (Global.poll < 50)  { eliminated = true; }
				break;
				default:
			}
			
			if (eliminated) {
				SoundManager.getInstance().gameOver();
				display.txtRunning.text = "You are no longer a candidate.";
				display.txtContinue.text = "Try again...";
				display.txtContinue.addEventListener(MouseEvent.CLICK, restart);
			} else {
				display.txtRunning.text = "You've not yet been eliminated as a potential candidate...";
				if (Global.round == 3) { 
					display.txtRunning.text = "You're the official 10-seconds-party candidate for the upcoming election !"
					display.txtContinue.text = "Continue to Election Day..."; }
				display.txtContinue.addEventListener(MouseEvent.CLICK, nextMonth);
			}
		}
		
		private function nextMonth(e:MouseEvent):void
		{
			SoundManager.getInstance().action();
			Global.newMonth();
			debriefValidate.dispatch();
		}
		
		private function restart(e:MouseEvent):void
		{
			SoundManager.getInstance().action();
			Global.raz();
			debriefValidate.dispatch();
		}
		
	}

}
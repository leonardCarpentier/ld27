package com.lcarpentier.ld.game 
{
	import com.lcarpentier.ld.vo.CampaignEvent;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class CardInstance extends Sprite 
	{
		private var display:CampaignCard = new CampaignCard();
		private var vo:CampaignEvent;
		
		private var _vote:int = 0;
		public function get vote():int
		{
			return _vote;
		}
		
		private var _poll:int = 0;
		public function get poll():int 
		{
			return _poll;
		}
		
		
		private var _delay:int = 0;
		public function get delay():int 
		{
			return _delay;
		}
		
		
		public function CardInstance(ce:CampaignEvent) 
		{
			//store the event
			vo = ce;
			
			//Convert it to instance data
			_vote = ce.minVote + Math.floor(Math.random() * (ce.maxVote-ce.minVote));
			_poll = ce.minPoll + Math.floor(Math.random() * (ce.maxPoll-ce.minPoll));
			_delay = ce.minDelay + Math.floor(Math.random() * (ce.maxDelay-ce.minDelay));
			
			
			if (_vote < 1 && _poll < 1) 
			{
				_vote = 1;
			}
			
			//handle display
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = true;
			
			display.stop();
			display.illustration.gotoAndStop(ce.pictureId);
			
			display.txtDaysAmount.text = _delay + "";
			display.txtName.text = vo.name;
			display.txtPoll.text = _poll + "";
			display.txtVotes.text = _vote + "";
			
			addChild(display);
		}
		
	}

}
package com.lcarpentier.ld.manager 
{
	import com.lcarpentier.ld.vo.CampaignEvent;
	import com.lcarpentier.ld.vo.DebateEvent;
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class Global 
	{
		
		public static var votes:int = 40;
		public static var poll:int = 20;
		public static var month:int = 1;
		public static var day:int = 1;
		
		public static var debriefVote:int = 40;
		public static var debriefPoll:int = 20;
		
		public static var oakdude:int = 25;
		public static var ashgirl:int = 20
		public static var birchlady:int = 35;
		
		public static var round:int = 1;
		
		public static var campaignEvents:Vector.<CampaignEvent> = new Vector.<CampaignEvent>();
		public static var debateEvents:Vector.<DebateEvent> = new Vector.<DebateEvent>();
		public static var months:Vector.<String> = new Vector.<String>();
		
		public static function get monthLimit():int {
			if (month == 2) { return 27 };
			if (month == 4 || month == 6 || month == 9 || month == 11) { return 30 };
			return 31;
		}
		
		public function Global() 
		{
			
		}
		
		//set all global values to zero
		public static function raz():void
		{
			votes = 40;
			poll = 20;
			month = 1;
			day = 1;
			round = 1;
			debriefVote = 40;
			debriefPoll = 20;
		}
		
		public static function newMonth():void
		{
			month ++;
			day = 1;
			round ++;
		}
		
		
	}

}
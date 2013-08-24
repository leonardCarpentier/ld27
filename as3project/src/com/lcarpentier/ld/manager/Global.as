package com.lcarpentier.ld.manager 
{
	import com.lcarpentier.ld.vo.CampaignEvent;
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class Global 
	{
		
		public static var votes:int = 0;
		public static var poll:int = 0;
		public static var month:int = 1;
		public static var day:int = 1;
		
		public static var campaignEvents:Vector.<CampaignEvent> = new Vector.<CampaignEvent>();
		
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
			votes = 0;
			poll = 0;
			month = 1;
			day = 1;
		}
		
		
	}

}
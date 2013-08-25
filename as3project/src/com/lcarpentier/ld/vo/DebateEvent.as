package com.lcarpentier.ld.vo 
{
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class DebateEvent 
	{
		
		public var question:String = "";
		public var answers:Vector.<String> = new Vector.<String>();
		public var typeIsVote:Vector.<Boolean> = new Vector.<Boolean>();
		public var rewards:Vector.<int> = new Vector.<int>();
		
		public function DebateEvent() 
		{
			
		}
		
	}

}
package com.lcarpentier.ld.manager 
{
	import com.lcarpentier.ld.vo.CampaignEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Leonar Carpentier
	 */
	public class XMLManager 
	{
		private const URL:String = "content.xml";
		
		private var lang:String = "EN";
		
		public var loadingOver:Signal = new Signal(XMLManager);
		
		public function XMLManager() 
		{
			var urlrequest:URLRequest = new URLRequest(URL);
			var loader:URLLoader = new URLLoader(urlrequest);
			loader.addEventListener(Event.COMPLETE, onLoadingComplete);
		}
		
		//{ region Event listeners
		
		private function onLoadingComplete(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			
			var xml:XML = new XML(loader.data);
			
			//Store locally the data
			
			for each (var _language:XML in xml.language)
			{
				if (_language.@value == lang) {
					xml = _language;
					break;
				}
			}
			
			
			for each (var ce:XML in xml.campaignEvents.campaignEvent)
			{
				var campaignEvent:CampaignEvent = new CampaignEvent();
				campaignEvent.name = ce.@name;
				campaignEvent.minPoll = ce.@minPoll;
				campaignEvent.maxPoll = ce.@maxPoll;
				campaignEvent.minVote = ce.@minVote;
				campaignEvent.maxVote = ce.@maxVote;
				campaignEvent.pictureId = ce.@picId;
				campaignEvent.minDelay = ce.@delay;
				campaignEvent.maxDelay = int(ce.@delay) + int(ce.@delayMargin);
				
				
				Global.campaignEvents.push(campaignEvent);
			}
			
			//end of loading
			
			loadingOver.dispatch(this);
		}
		
		//} endregion
	}

}
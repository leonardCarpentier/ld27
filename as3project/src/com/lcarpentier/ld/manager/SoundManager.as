package com.lcarpentier.ld.manager
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * ...
	 * @author www.leonard-carpentier.com
	 */
	public class SoundManager {
	
		//{ region Class constants
		
		//} endregion
		
		//{ region Constructor
		
		/**
		* Return the unique instance of the class
		*/
		public static function getInstance():SoundManager {
			if (instance == null) {
				localCall = true;
				instance = new SoundManager();
				localCall = false;
			}
			return instance;
		}
		
		/**
		* CONSTRUCTOR This class is a Singleton, use getInstance()
		*/
		public function SoundManager ():void {
			if (!localCall) {
				throw new Error("Error: Instantiation not allowed : Use SoundManager.getInstance() instead of new.");
			} else {
				
			}
		}
		
		//} endregion
		
		//{ region Variables
		
		/* Auto Déclaration */
		private static var instance:SoundManager;
		private static var localCall:Boolean;
		
		private var musicSoundChannel:SoundChannel;
		
		//} endregion
		
		//{ region Properties
		
		public var musicPlaying:Boolean = false;
		
		//} endregion
		
		//{ region Methods
		
		//-----------------------------------------
		// Public
		//-----------------------------------------
		
		/**
		 * Destroy Singleton instance
		 */
		public static function kill():void {
			instance = null;
		}
		
		//SOUNDS
			
		
		public function timerBip():void
		{
			var snd:Sound = new SndTimer();
			snd.play(0, 0, new SoundTransform(0.3));
		}
		
		public function letDown():void
		{
			var snd:Sound = new SndDebateOver();
			snd.play(0, 0, new SoundTransform(0.3));
		}
		
		public function action():void
		{
			if (musicPlaying)
			{
				musicSoundChannel.stop();
				musicSoundChannel = null;
				musicPlaying = false;
			}
			var snd:Sound = new SndAction();
			snd.play(0, 0, new SoundTransform(0.3));
		}
		
		public function intro():void
		{
			var snd:Sound = new SndMusic();
			musicSoundChannel = snd.play();
			musicPlaying = true;
		}
		
		public function gameOver():void
		{
			var snd:Sound = new SndGameOver();
			snd.play();
		}
	
		
		//-----------------------------------------
		// Private
		//-----------------------------------------
		
		//} endregion
		
		//{ region Signals handlers
		
		//} endregion
		
		//{ region Event listeners
	
		
		//} endregion
	}
}
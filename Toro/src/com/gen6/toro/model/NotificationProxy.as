package com.gen6.toro.model
{
	import com.gen6.toro.util.NotificationDisplayManager;
	
	import mx.core.SoundAsset;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import twitter.api.data.TwitterStatus;
	
	public class NotificationProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "NotificationProxy";
		
		private var _notificationDisplayManager : NotificationDisplayManager;
		
		[Embed(source="assets/sounds/note.mp3")]

        [Bindable]
        public var notification:Class;
		
		private var ding : SoundAsset = new notification() as SoundAsset
		            		
		public function NotificationProxy( data : Object = null )
		{
			super( NAME, data );
			
			_notificationDisplayManager = new NotificationDisplayManager();
		}
		
		public function showNotification( status : TwitterStatus, sound : Boolean, placement : Number ) : void
		{
			_notificationDisplayManager.displayMessage( "<b>"+status.user.screenName+"</b> : " + status.text, placement );
			
			if( sound )
			{
				ding.play();
			}
		}
	}
}
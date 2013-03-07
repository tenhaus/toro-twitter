package com.gen6.toro.events
{
	import flash.events.Event;
	
	import twitter.api.data.TwitterStatus;
	import twitter.api.data.TwitterUser;
	
	public class FriendSelectedEvent extends Event
	{
		public var friend : TwitterUser;
		public var status : TwitterStatus;
		
		public function FriendSelectedEvent( name : String, friend : TwitterUser, status : TwitterStatus = null )
		{
			super( name, true );
			this.friend = friend;
			this.status = status;
		}

	}
}
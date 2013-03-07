package com.gen6.toro.events
{
	import flash.events.Event;
	
	import twitter.api.data.TwitterStatus;
	import twitter.api.data.TwitterUser;
	
	public class RetweetEvent extends Event
	{
		
		public var friend : TwitterUser;
		public var status : TwitterStatus;
		public var message : String;
		
		public function RetweetEvent(name : String, msg : String, friend : TwitterUser, status : TwitterStatus = null)
		{
			super( name, true );
			this.message = msg.replace(friend.screenName,"");
			this.message = this.message.replace("\n","");
			this.message = this.message.replace("\r","");
			this.message = this.message.replace("\s{0,100}$","")
			this.friend = friend;
			this.status = status;
		}

	}
}
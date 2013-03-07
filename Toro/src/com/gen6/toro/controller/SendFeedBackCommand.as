package com.gen6.toro.controller
{
	import com.gen6.toro.model.FeedBackProxy;
	import com.gen6.toro.model.TwitterProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SendFeedBackCommand extends SimpleCommand
	{
		public override function execute( notification : INotification ) : void
		{
			var feedProxy : FeedBackProxy = facade.retrieveProxy( FeedBackProxy.NAME ) as FeedBackProxy;
			var twitterProxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			feedProxy.sendFeedBack( notification.getBody() as String, twitterProxy.getUsername() );
		}
	}
}
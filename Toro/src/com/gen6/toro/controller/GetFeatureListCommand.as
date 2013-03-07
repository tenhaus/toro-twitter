package com.gen6.toro.controller
{
	import com.gen6.toro.model.FeedBackProxy;
	import com.gen6.toro.model.TwitterProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GetFeatureListCommand extends SimpleCommand
	{
		override public function execute( notification : INotification ) : void
		{
			var twitterProxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			var feedbackProxy : FeedBackProxy = facade.retrieveProxy( FeedBackProxy.NAME ) as FeedBackProxy;
			
			feedbackProxy.getFeatureList( twitterProxy.getUsername() );		
		}
	}
}
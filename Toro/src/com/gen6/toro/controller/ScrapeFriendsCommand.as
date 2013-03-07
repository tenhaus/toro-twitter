package com.gen6.toro.controller
{
	import com.gen6.toro.model.TwitterProxy;
	import com.gen6.toro.model.TwitterScrapeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ScrapeFriendsCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var twitterProxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			
			var proxy : TwitterScrapeProxy = facade.retrieveProxy( TwitterScrapeProxy.NAME ) as TwitterScrapeProxy;
			proxy.loadFriends();
		}
	}
}
package com.gen6.toro.controller
{
	import com.gen6.toro.model.TwitterProxy;
	import com.gen6.toro.model.TwitterScrapeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LogoutCommand extends SimpleCommand
	{
		public override function execute( notification:INotification ) : void
		{
			var proxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			proxy.logout();
			
			var scrapeProxy : TwitterScrapeProxy = facade.retrieveProxy( TwitterScrapeProxy.NAME ) as TwitterScrapeProxy;
			scrapeProxy.logout();
		}
	}
}
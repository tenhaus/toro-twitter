package com.gen6.toro.controller
{
	import com.gen6.toro.model.TwitterScrapeProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ScrapePublicTimelineCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var proxy : TwitterScrapeProxy = facade.retrieveProxy( TwitterScrapeProxy.NAME ) as TwitterScrapeProxy;
			proxy.loadPublicTimeline();
		}
	}
}
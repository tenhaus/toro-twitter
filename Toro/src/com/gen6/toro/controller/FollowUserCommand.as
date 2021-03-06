package com.gen6.toro.controller
{
	import com.gen6.toro.model.TwitterProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class FollowUserCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var proxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			proxy.followUser( notification.getBody() as String );			
		}
	}
}
package com.gen6.toro.controller
{
	import com.gen6.toro.model.NotificationProxy;
	import com.gen6.toro.model.SQLProxy;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShowNotificationCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void
		{
			var sqlProxy : SQLProxy = facade.retrieveProxy( SQLProxy.NAME ) as SQLProxy;
			
			if( !sqlProxy.configOptions.notifications )
			{
				return;
			} 
					
			var proxy : NotificationProxy = facade.retrieveProxy( NotificationProxy.NAME ) as NotificationProxy;
			var updates : ArrayCollection = notification.getBody() as ArrayCollection;
						
			if( updates.length > 0 )
			{
				proxy.showNotification( updates[0], sqlProxy.configOptions.sound, sqlProxy.configOptions.notificationPlacement );	
			}			
		}
	}
}
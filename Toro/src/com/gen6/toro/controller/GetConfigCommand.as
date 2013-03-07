package com.gen6.toro.controller
{
	import com.gen6.toro.model.SQLProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GetConfigCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var proxy : SQLProxy = facade.retrieveProxy( SQLProxy.NAME ) as SQLProxy;
			proxy.getConfigOptions();			
		}
	}
}
package com.gen6.toro.controller
{
	import com.gen6.toro.entity.ConfigurationVO;
	import com.gen6.toro.model.SQLProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SaveConfigCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var proxy : SQLProxy = facade.retrieveProxy( SQLProxy.NAME ) as SQLProxy;
			proxy.saveConfigOptions( notification.getBody() as ConfigurationVO );
		}
	}
}
package com.gen6.toro.controller
{
	import com.gen6.toro.model.EncryptedLocalStoreProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoadEncryptedCredentialsCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void
		{
			var proxy : EncryptedLocalStoreProxy = facade.retrieveProxy( EncryptedLocalStoreProxy.NAME ) as EncryptedLocalStoreProxy;
			proxy.loadCredentials();
		}
	}
}
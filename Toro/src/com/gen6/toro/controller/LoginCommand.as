package com.gen6.toro.controller
{
	import com.gen6.toro.entity.LoginVO;
	import com.gen6.toro.model.TwitterProxy;
	import com.gen6.toro.model.TwitterScrapeProxy;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class LoginCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var vo : LoginVO = notification.getBody() as LoginVO;
			var twitProxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			twitProxy.login( vo.username, vo.password );
			
			var scrapeProxy : TwitterScrapeProxy = facade.retrieveProxy( TwitterScrapeProxy.NAME ) as TwitterScrapeProxy;
			scrapeProxy.login( vo.username, vo.password );
			
			if( vo.saveUserInfo )
			{
				var userBytes : ByteArray = new ByteArray();
				userBytes.writeUTFBytes( vo.username );
				EncryptedLocalStore.setItem( "username", userBytes );
				
				var passwordBytes : ByteArray = new ByteArray();
				passwordBytes.writeUTFBytes( vo.password );
				EncryptedLocalStore.setItem( "password", passwordBytes );
			}
			else
			{
				EncryptedLocalStore.removeItem( "username" );
				EncryptedLocalStore.removeItem( "password" );
			}
		}
	}
}
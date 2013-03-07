package com.gen6.toro.model
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.LoginVO;
	
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class EncryptedLocalStoreProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "EncryptedLocalStoreProxy";
		
		public function EncryptedLocalStoreProxy( data : Object = null )
		{
			super( NAME, data );
		}
		
		public function loadCredentials() : void
		{
			var username : ByteArray = EncryptedLocalStore.getItem( "username" );
			var password : ByteArray = EncryptedLocalStore.getItem( "password" );
			
			var vo : LoginVO = new LoginVO();
			
			if( username != null &&
				password != null )
			{
				vo.username = username.readUTFBytes(username.length);
				vo.password = password.readUTFBytes(password.length);
				vo.saveUserInfo = true;
				
				sendNotification( ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS, vo );				
			}
			else
			{
				sendNotification( ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_FAILED );				
			}
		}
	}
}
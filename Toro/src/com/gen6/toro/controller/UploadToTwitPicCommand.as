package com.gen6.toro.controller
{
	import com.gen6.toro.entity.TwitPicVO;
	import com.gen6.toro.model.TwitterProxy;
	import com.gen6.toro.model.UploadToTwitPicProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class UploadToTwitPicCommand extends SimpleCommand
	{
		public override function execute (notification:INotification):void
		{
			var vo : TwitPicVO = notification.getBody() as TwitPicVO;
			
			var twitterProxy : TwitterProxy = facade.retrieveProxy( TwitterProxy.NAME ) as TwitterProxy;
			
			var user : String = twitterProxy.getUsername();
			var pass : String = twitterProxy.getPassword();
			
			var proxy : UploadToTwitPicProxy = facade.retrieveProxy( UploadToTwitPicProxy.NAME ) as UploadToTwitPicProxy;
			
			proxy.uploadToTwitPic( user, pass, vo );
		}

	}
}
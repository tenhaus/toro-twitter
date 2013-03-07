package com.gen6.toro.controller
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.model.EncryptedLocalStoreProxy;
	import com.gen6.toro.model.FeedBackProxy;
	import com.gen6.toro.model.NotificationProxy;
	import com.gen6.toro.model.SQLProxy;
	import com.gen6.toro.model.ShrinkUrlProxy;
	import com.gen6.toro.model.TwitterProxy;
	import com.gen6.toro.model.TwitterScrapeProxy;
	import com.gen6.toro.model.UploadToTwitPicProxy;
	import com.gen6.toro.view.ApplicationMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCommand extends SimpleCommand
	{
		override public function execute( notification : INotification ) : void
		{
			facade.registerProxy( new TwitterProxy() );
			facade.registerProxy( new EncryptedLocalStoreProxy() );
			facade.registerProxy( new NotificationProxy() );
			facade.registerProxy( new SQLProxy() );
			facade.registerProxy( new FeedBackProxy() );
			facade.registerProxy( new ShrinkUrlProxy() );
			facade.registerProxy( new TwitterScrapeProxy() );
			facade.registerProxy( new UploadToTwitPicProxy() );
			
			facade.registerMediator( new ApplicationMediator( notification.getBody() as Toro ) );
			
			sendNotification( ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS );			
		}
	}
}
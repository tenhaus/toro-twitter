package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import twitter.api.data.TwitterRateLimit;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "ApplicationMediator";
		
		public function ApplicationMediator( viewComponent : Toro )
		{
			super( NAME, viewComponent );
			
			application.addEventListener( Toro.FEED_BACK_VIEW_CREATED, handleFeedBackViewCreated );			
			
			facade.registerMediator( new MainViewMediator( application.commentView )  );
			facade.registerMediator( new FeedBackMediator( application.feedBackView)  );
			facade.registerMediator( new SettingsMediator( application.settingsview ) );
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.VALID_LOGIN,
					ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS,
					ApplicationFacade.GET_RATE_LIMIT_RESULT,
					ApplicationFacade.LOGOUT,
					ApplicationFacade.SHOW_FEED_BACK_VIEW,
					ApplicationFacade.SHOW_SETTINGS,
					ApplicationFacade.CANCEL_FEED_BACK,
					ApplicationFacade.CANCEL_SETTINGS
					
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.VALID_LOGIN :
					application.setLoginSuccess();					
					break;
					
				case ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS :
					break;
					
				case ApplicationFacade.GET_RATE_LIMIT_RESULT :
					var limit : TwitterRateLimit = notification.getBody() as TwitterRateLimit;					
					application.status = "API calls remaining: UNLIMITED!";
					break;
					
				case ApplicationFacade.SHOW_FEED_BACK_VIEW :
					application.vs_main.selectedChild = application.feedBackView;
					break;
				
				case ApplicationFacade.SHOW_SETTINGS :
					application.vs_main.selectedChild = application.settingsview;
					break;
					
				case ApplicationFacade.CANCEL_FEED_BACK :
					application.vs_main.selectedChild = application.commentView;
					break;
				
				case ApplicationFacade.CANCEL_SETTINGS :
					application.vs_main.selectedChild = application.commentView;
					break;
					
				case ApplicationFacade.LOGOUT :										
					break;
					
				default :
					break;
			}
		}
		
		public function get application() : Toro
		{
			return( viewComponent as Toro );
		}
		
		private function handleFeedBackViewCreated( event : Event ) : void
		{
			if( !facade.hasMediator( FeedBackMediator.NAME ) )
			{
				facade.registerMediator( new FeedBackMediator(application.feedBackView) );
			}
		}
	}
}
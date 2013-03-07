package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.LoginVO;
	import com.gen6.toro.view.components.LoginView;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LoginMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "LoginMediator";
		 
		public function LoginMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			loginView.addEventListener( LoginView.LOGIN_REQUESTED, handleLoginRequested );
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [					
					ApplicationFacade.INVALID_LOGIN,
					ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.INVALID_LOGIN :
					loginView.progress_login.visible = false;
					loginView.setLoginFailed();
					break;
					
				case ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS :					
					loginView.loginVO = notification.getBody() as LoginVO;
					sendNotification( ApplicationFacade.LOGIN, loginView.loginVO );
					break;
					
				default :
					break;
			}
		}
		
		private function handleLoginRequested( event : Event ) : void
		{
			loginView.progress_login.visible = true;
			sendNotification( ApplicationFacade.LOGIN, loginView.loginVO );			
		}
		
		private function get loginView() : LoginView
		{
			return( viewComponent as LoginView );
		}
	}
}
package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.view.components.UserTimelineView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class UserTimelineMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "UserTimelineMediator";		
		
		public function UserTimelineMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			//homeView.addEventListener( UserTimelineView.GET_USER_COMMENTS, handleRequestUserComments );						
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.GET_USER_TIMELINE_RESULT,
					ApplicationFacade.LOGOUT,
					ApplicationFacade.LOGIN
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.GET_USER_TIMELINE_RESULT :					
					homeView.appendComments( notification.getBody() as ArrayCollection );
					break;
				case ApplicationFacade.LOGOUT :
					homeView.resetComments();
					break;
				default :
					break;
			}
		}
		
		private function get homeView() : UserTimelineView
		{
			return( viewComponent as UserTimelineView );
		}	
		
		private function handleRequestUserComments( event : Event ) : void
		{
			sendNotification( ApplicationFacade.GET_USER_TIMELINE );			
		}	
	}
}
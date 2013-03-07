package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.view.components.PublicView;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PublicMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "PublicMediator";		
		 
		public function PublicMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			publicView.addEventListener( PublicView.GET_PUBLIC_COMMENTS, handleRequestPublicComments );			
		}		
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.GET_PUBLIC_COMMENTS_SUCCESS,
					ApplicationFacade.LOGOUT				
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{		
				case ApplicationFacade.GET_PUBLIC_COMMENTS_SUCCESS :
					publicView.publicComments = null;
					publicView.publicComments = notification.getBody() as ArrayCollection;
					break;
				case ApplicationFacade.LOGOUT :
					publicView.publicComments = null;
					break;
				default :
					break;
			}
		}
		
		private function get publicView() : PublicView
		{
			return( viewComponent as PublicView );
		}
		
		private function handleRequestPublicComments( event : Event ) : void
		{
			sendNotification( ApplicationFacade.GET_PUBLIC_COMMENTS );
		}
	}
}
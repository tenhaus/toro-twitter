package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.view.components.RepliesView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class RepliesMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "RepliesMediator";
		 
		public function RepliesMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			repliesView.addEventListener( RepliesView.GET_REPLIES, handleRequestReplies );
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.GET_REPLIES_SUCCESS,
					ApplicationFacade.LOGOUT
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.GET_REPLIES_SUCCESS :
					repliesView.replies = notification.getBody() as ArrayCollection;
					break;
				case ApplicationFacade.LOGOUT :
					repliesView.replies = null;
					break;
				default :
					break;
			}
		}
		
		private function get repliesView() : RepliesView
		{
			return( viewComponent as RepliesView );
		}
		
		private function handleRequestReplies( event : Event ) : void
		{
			sendNotification( ApplicationFacade.GET_REPLIES );
		}
	}
}
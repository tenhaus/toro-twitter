package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.view.components.FriendView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class FriendListMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "FriendListMediator";
		 
		public function FriendListMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			friendsList.addEventListener( FriendView.FRIEND_COMMENTS_REQUESTED, handleGetFriendCommentsRequested );
			
			//sendNotification( ApplicationFacade.GET_FRIENDS );
			//sendNotification( ApplicationFacade.GET_FOLLOWERS );
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [					
					ApplicationFacade.GET_FRIENDS_SUCCESS,
					ApplicationFacade.GET_FRIEND_COMMENTS_SUCCESS,
					ApplicationFacade.GET_FOLLOWERS_SUCCESS,
					ApplicationFacade.LOGOUT
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{				
				case ApplicationFacade.GET_FRIEND_COMMENTS_SUCCESS :					
					friendsList.selectedFriendsComments = notification.getBody() as ArrayCollection;
					break;
				case ApplicationFacade.GET_FRIENDS_SUCCESS :					
					friendsList.friends = notification.getBody() as ArrayCollection;
					break;		
				case ApplicationFacade.GET_FOLLOWERS_SUCCESS :
					friendsList.followers = notification.getBody() as ArrayCollection;
					break;		
				case ApplicationFacade.LOGOUT :
					friendsList.selectedFriendsComments = null;
					friendsList.friends = null;
				default :
					break;
			}
		}
		
		private function handleGetFriendCommentsRequested( event : Event ) : void
		{
			sendNotification( ApplicationFacade.GET_FRIEND_COMMENTS, friendsList.selectedFriend.screenName );			
		}
		
		private function get friendsList() : FriendView
		{
			return( viewComponent as FriendView );
		}
	}
}
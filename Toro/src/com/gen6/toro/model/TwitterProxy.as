package com.gen6.toro.model
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.ConfigurationVO;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import twitter.api.Twitter;
	import twitter.api.data.TwitterStatus;
	import twitter.api.events.TwitterEvent;
	
	public class TwitterProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "TwitterProxy";
		
		private var _twitter : Twitter;
		
		private var _userTimelineLastRequest : Date;
		
		[Bindable]
		private var _currentUserTimeLine : ArrayCollection;
		
		private var _userCommentTimer : Timer = new Timer( 1000*60 );
		private var _repliesCommentTimer : Timer = new Timer( 1000 * 60 );		
		private var _publicCommentTimer : Timer = new Timer( 1000 * 60 );
		private var _rateLimitTimer : Timer = new Timer( 1000 * 30 );
		private var _imageCacheTimer : Timer = new Timer( 1000 * 60 * 3 ); 
		
		public function TwitterProxy( data : Object = null )
		{
			super( NAME, data );
			
			_twitter = new Twitter();
			setupEventListeners();
		}
		
		private function setupEventListeners() : void
		{
			//_userCommentTimer.addEventListener( TimerEvent.TIMER, handleUserTimelineTick );
			//_repliesCommentTimer.addEventListener( TimerEvent.TIMER, handleRepliesTick );
			_rateLimitTimer.addEventListener( TimerEvent.TIMER, handleRateLimitTimerTick );
			//_publicCommentTimer.addEventListener( TimerEvent.TIMER, handleTimeTick );
			//_imageCacheTimer.addEventListener( TimerEvent.TIMER, handleImageCacheTimerTick );
			
			_twitter.addEventListener( TwitterEvent.ON_LOGIN_SUCCESS, handleLoginSuccess );
			_twitter.addEventListener( TwitterEvent.ON_LOGIN_FAILED, handleLoginFailed );
			_twitter.addEventListener( TwitterEvent.ON_LOGIN_ERROR, handleLoginError );
			_twitter.addEventListener( TwitterEvent.ON_FRIENDS_RESULT, handleGetFriendsSuccess );
			_twitter.addEventListener( TwitterEvent.ON_FOLLOWERS, handleGetFollowersSuccess );
			_twitter.addEventListener( TwitterEvent.ON_USER_TIMELINE_RESULT, handleGetFriendCommentsSuccess );
			_twitter.addEventListener( TwitterEvent.ON_PUBLIC_TIMELINE_RESULT, handleGetPublicCommentsSuccess );			
			_twitter.addEventListener( TwitterEvent.ON_SET_STATUS, handleSendCommentSuccess );
			_twitter.addEventListener( TwitterEvent.ON_FRIENDS_TIMELINE_RESULT, handleGetUserTimeline );
			_twitter.addEventListener( TwitterEvent.ON_REPLIES, handleGetReplies );
			_twitter.addEventListener( TwitterEvent.ON_RATE_LIMIT_RESULT, handleGetRateLimitResult );
			_twitter.addEventListener( TwitterEvent.ON_SEARCH_SUCCESS, handleSearchResults );
			_twitter.addEventListener( TwitterEvent.ON_FOLLOW_SUCCESS, handleFollowUserSuccess );
			_twitter.addEventListener( TwitterEvent.ON_UNFOLLOW_SUCCESS, handleUnfollowSuccess );
			
			_twitter.addEventListener( TwitterEvent.ON_FOLLOW_FAILED, handleFollowUserFailed );
			_twitter.addEventListener( TwitterEvent.ON_PUBLIC_TIMELINE_FAILED, handleGetPublicCommentsFailed );
			_twitter.addEventListener( TwitterEvent.ON_USER_TIMELINE_FAILED, handleGetUserTimelineFailed );
			_twitter.addEventListener( TwitterEvent.ON_REPLIES_FAILED, handleGetRepliesFailed );
			
			//_imageCacheTimer.start();
		}
		
		/*
		private function handleImageCacheTimerTick( event : TimerEvent ) : void
		{
			trace( "clear cache" );
			ContentCache.getCache().clear();
		}
		*/
		
		public function login( username : String, password : String ) : void
		{
			_twitter.setAuth( username, password );
			_twitter.authenticate();
		}
		
		private function handleLoginSuccess( event : TwitterEvent ) : void
		{
			//_rateLimitTimer.start();
			getRateLimit();
			
			//sendNotification( ApplicationFacade.GET_FRIENDS );
			//sendNotification( ApplicationFacade.GET_FOLLOWERS );
			//sendNotification( ApplicationFacade.GET_USER_TIMELINE );
			
			//sendNotification( ApplicationFacade.GET_REPLIES );						
			//sendNotification( ApplicationFacade.GET_PUBLIC_COMMENTS );			
			
			/*
			sendNotification( ApplicationFacade.SCRAPE_USER_TIMELINE );
			sendNotification( ApplicationFacade.SCRAPE_FRIENDS );
			sendNotification( ApplicationFacade.SCRAPE_REPLIES );
			sendNotification( ApplicationFacade.SCRAPE_FOLLOWERS );
			sendNotification( ApplicationFacade.SCRAPE_PUBLIC_TIMELINE );
			*/
			
			sendNotification( ApplicationFacade.GET_FEATURE_LIST, getUsername() );		
			
			sendNotification( ApplicationFacade.VALID_LOGIN );
		}
		
		private function handleLoginFailed( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.INVALID_LOGIN );
		}
		
		private function handleLoginError( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.LOGIN_ERROR );
		}
		
		public function getFriends() : void
		{
			_twitter.loadFriends( _twitter.username );
		}
		
		private function handleGetFriendsSuccess( event : TwitterEvent ) : void
		{
			var friends : ArrayCollection = new ArrayCollection( event.data as Array );
			sendNotification( ApplicationFacade.GET_FRIENDS_SUCCESS, friends );
		}
		
		public function getFollowers() : void
		{
			_twitter.loadFollowers( true );
		}
		
		private function handleGetFollowersSuccess( event : TwitterEvent ) : void
		{
			var followers : ArrayCollection = new ArrayCollection( event.data as Array );
			sendNotification( ApplicationFacade.GET_FOLLOWERS_SUCCESS, followers );
		}
		
		public function getFriendComments( friend : String ) : void
		{
			_twitter.loadUserTimeline( friend );
		}
		
		private function handleGetFriendCommentsSuccess( event : TwitterEvent ) : void
		{
			var comments : ArrayCollection = new ArrayCollection( event.data as Array );
			sendNotification( ApplicationFacade.GET_FRIEND_COMMENTS_SUCCESS, comments );			
		}
		
		public function getPublicComments() : void
		{
			if( _publicCommentTimer.running ) return;
			trace( "get public comments" );
			
			_publicCommentTimer.reset();
			
			_twitter.loadPublicTimeline();									
		}
		
		private function handleGetPublicCommentsSuccess( event : TwitterEvent ) : void
		{
			var comments : ArrayCollection = new ArrayCollection( event.data as Array );
			sendNotification( ApplicationFacade.GET_PUBLIC_COMMENTS_SUCCESS, comments );
			_publicCommentTimer.start();
		}
		
		private function handleGetPublicCommentsFailed( event : TwitterEvent ) : void
		{
			trace( "public failed" );
			sendNotification( ApplicationFacade.GET_PUBLIC_COMMENTS_FAILED );
			_publicCommentTimer.start();
		}
		
		public function sendComment( comment : String ) : void
		{
			_twitter.setStatus( comment );						
		}
		
		private function handleSendCommentSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.SEND_COMMENT_SUCCESS );
			//getUserTimeline( true );
			//sendNotification( ApplicationFacade.SCRAPE_USER_TIMELINE );
		}
		
		public function getExtendedInfo( user : String ) : void
		{
			_twitter.getExtendedInfo( user );			
		}
		
		public function getUserTimeline( force : Boolean = false ) : void
		{
			if( !force )
			{
				if( _userCommentTimer.running ) return;
			}
				
			trace( "get user timeline" );
			
			_userCommentTimer.reset();
			
			if( _currentUserTimeLine == null )
			{
				_twitter.loadFriendsTimeline( _twitter.username );				
			}			
			else
			{
				if( _currentUserTimeLine.length == 0 )
				{
					_twitter.loadFriendsTimeline( _twitter.username );					
				}
				else
				{
					_twitter.loadFriendsTimeline( _twitter.username, _currentUserTimeLine.getItemAt(0).id as Number );					
				}				
			}
						
		}
		
		private function handleGetUserTimeline( event : TwitterEvent ) : void
		{			
			var comments : ArrayCollection = new ArrayCollection( event.data as Array );			
			
			if( _currentUserTimeLine == null )
			{
				_currentUserTimeLine = comments;								
			}
			else
			{				
				for( var i : Number = comments.length-1; i >=0; i-- )
				{
					var comment : TwitterStatus = comments.getItemAt(i) as TwitterStatus;
					
					_currentUserTimeLine.addItemAt( comment, 0 );
					if( comment.user.screenName != _twitter.username )
					{
						sendNotification( ApplicationFacade.SHOW_NOTIFICATION, comment );
					}
				}
			}
			
			sendNotification( ApplicationFacade.GET_USER_TIMELINE_RESULT, _currentUserTimeLine );
			getRateLimit();
			_userCommentTimer.start();
		}
		
		private function handleGetUserTimelineFailed( event : TwitterEvent ) : void
		{
			_userCommentTimer.start();
			trace( "user failed" );
		}
		
		private function handleUserTimelineTick( event : TimerEvent ) : void
		{
			_userCommentTimer.reset();
			getUserTimeline();			
		}
		
		public function loadReplies() : void
		{	
			if( _repliesCommentTimer.running ) return;
			trace( "load replies" );
			
			_repliesCommentTimer.reset();
			
			_twitter.loadReplies();
		}
		
		private function handleGetReplies( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_REPLIES_SUCCESS, new ArrayCollection( event.data as Array ) );
			_repliesCommentTimer.start();
		}
		
		private function handleGetRepliesFailed( event : TwitterEvent ) : void
		{
			trace( "replies failed" );
			_repliesCommentTimer.start();
			sendNotification( ApplicationFacade.GET_REPLIES_FAILED );
		}
		
		private function handleRepliesTick( event : TimerEvent ) : void
		{
			_repliesCommentTimer.reset();
			loadReplies();
		}
		
		public function getRateLimit() : void
		{
			_twitter.getRateLimit();
		}
		
		private function handleGetRateLimitResult( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_RATE_LIMIT_RESULT, event.data );									
		}
		
		public function logout() : void
		{
			_twitter.logout();
						
			_userCommentTimer.reset();
			_repliesCommentTimer.reset();
			_rateLimitTimer.reset();
		}
		
		private function handleRateLimitTimerTick( event : TimerEvent ) : void
		{
			getRateLimit();			
		}
		
		private function handleTimeTick( event : TimerEvent ) : void
		{
			_publicCommentTimer.reset();
			getPublicComments();
		}	
		
		public function getUsername() : String
		{
			return( _twitter.username );
		}
		
		public function getPassword() : String
		{
			return( _twitter.password );
		}
		
		public function getConfig() : ConfigurationVO
		{
			var sqlProxy : SQLProxy = facade.retrieveProxy( SQLProxy.NAME ) as SQLProxy;
			return( sqlProxy.configOptions );
			
			
		}
		
		public function search( searchText : String ) : void
		{
			_twitter.search( searchText );
		}
		
		private function handleSearchResults( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.SEARCH_SUCCESS, event.data );
		}
		
		public function followUser( username : String ) : void
		{
			_twitter.follow( username );
		}
		
		private function handleFollowUserSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.FOLLOW_USER_SUCCESS, event.data );						
		}
		
		private function handleFollowUserFailed( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.FOLLOW_USER_FAILED );
		}
		
		private function handleUnfollowSuccess( event : TwitterEvent ) : void
		{
		}
		
		private function handleUnfollowFailed( event : TwitterEvent ) : void
		{
		}
	}
}
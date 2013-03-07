package com.gen6.toro.model
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.util.TwitterScrape;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import twitter.api.events.TwitterEvent;
	
	public class TwitterScrapeProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "TwitterScrapeProxy";
		
		private var _twitterScrape : TwitterScrape;
		
		/* fast as hell, for testing
		private var _userTimelineTimer : Timer = new Timer( 1000 * 10 );
		private var _publicTimelineTimer : Timer = new Timer( 1000 * 5 );
		private var _repliesTimer : Timer = new Timer( 1000 * 6 );
		private var _friendsTimer : Timer = new Timer( 1000 * 30 );
		private var _followersTimer : Timer = new Timer( 1000 * 40 );
		*/
		
		public function TwitterScrapeProxy( data : Object = null )
		{
			super( NAME, data );
			
			_twitterScrape = new TwitterScrape();
			setUpEventListeners();
		}
		
		private function setUpEventListeners() : void
		{	
			_twitterScrape.addEventListener( TwitterEvent.ON_FRIENDS_RESULT, handleLoadFriendsSuccess, false, 0, true );
			_twitterScrape.addEventListener( TwitterEvent.ON_FOLLOWERS, handleLoadFollowersSuccess, false, 0, true );	
			_twitterScrape.addEventListener( TwitterEvent.ON_USER_TIMELINE_RESULT, handleLoadUserTimelineSuccess, false, 0, true );
			_twitterScrape.addEventListener( TwitterEvent.ON_REPLIES, handleLoadRepliesSuccess, false, 0, true );
			_twitterScrape.addEventListener( TwitterEvent.ON_PUBLIC_TIMELINE_RESULT, handleLoadPublicTimelineSuccess, false, 0, true );					
		}
		
		public function login( username : String, password : String ) : void
		{
			_twitterScrape.setAuth( username, password );
		}
		
		public function logout() : void
		{			
			_twitterScrape.logout();								
		}
		
		public function loadFriends( event : Event = null ) : void
		{
			trace( "scrape friends" );
			_twitterScrape.loadFriends();
		}
		
		private function handleLoadFriendsSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_FRIENDS_SUCCESS, event.data );			
		}
		
		public function loadFollowers( event : Event = null ) : void
		{		
			trace( "scrape followers" );
			_twitterScrape.loadFollowers();
		}
		
		private function handleLoadFollowersSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_FOLLOWERS_SUCCESS, event.data );
		}
		
		public function loadUserTimeline( event : Event = null ) : void
		{
			trace( "scrape user timeline" );
			_twitterScrape.loadUserTimeLine();
		}
		
		private function handleLoadUserTimelineSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_USER_TIMELINE_RESULT, event.data );
			sendNotification( ApplicationFacade.SHOW_NOTIFICATION, event.data );									
		}
		
		public function loadReplies( event : Event = null ) : void
		{
			trace( "scrape replies" );
			_twitterScrape.loadReplies();		
		}
		
		private function handleLoadRepliesSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_REPLIES_SUCCESS, event.data );			
		}
		
		public function loadPublicTimeline( event : Event = null ) : void		
		{			
			trace( "scrape public timeline" );
			_twitterScrape.loadPublicTimeline();									
		}
		
		public function handleLoadPublicTimelineSuccess( event : TwitterEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_PUBLIC_COMMENTS_SUCCESS, event.data );
		}
	}
}
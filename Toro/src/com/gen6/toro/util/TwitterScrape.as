package com.gen6.toro.util
{

	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.utils.Base64Encoder;
	
	import twitter.api.data.TwitterStatus;
	import twitter.api.data.TwitterUser;
	import twitter.api.events.TwitterEvent;	
	
	public class TwitterScrape extends EventDispatcher
	{		
		// FRIENDS
		public static const REGEX_PARSE_FRIENDS : RegExp = new RegExp( "(<tr id=\".*?\" class=\"vcard person.*?\">.*?)<\/tr>", "g" );
		public static const REGEX_PARSE_FRIEND_ID : RegExp = new RegExp( "control([0-9]+)" ); 
		public static const REGEX_PARSE_FRIEND_NAME : RegExp = new RegExp( "<span class=\"nickname\">[^<]+</span></a>[ /]*([^<]+)" );		
		public static const REGEX_PARSE_FRIEND_SCREEN_NAME : RegExp = new RegExp( "<a href=\"http://twitter.com/(.*?)\" rel=\"contact\"" );		
		public static const REGEX_PARSE_FRIEND_DESCRIPTION : RegExp = new RegExp( "rel=\"contact\" title=\"(.*?)\"><span class=\"nickname\">" );
		public static const REGEX_PARSE_FRIEND_PROFILE_IMAGE : RegExp = new RegExp( "class=\"photo fn\".*?src=\"(.*?)\"" );
		
		public static const REGEX_PARSE_FRIEND_NEXT_PAGE : RegExp = new RegExp( "<a href=\"\/friends.page=([0-9])\" class=\"section_links\" rel=\"me next\"" );
		
		// FOLLOWERS
		public static const REGEX_PARSE_FOLLOWERS : RegExp = new RegExp( "(<tr id=\".*?\" class=\"vcard person.*?\">.*?)<\/tr>", "g" );
		public static const REGEX_PARSE_FOLLOWER_ID : RegExp = new RegExp( "control([0-9]+)" ); 
		public static const REGEX_PARSE_FOLLOWER_NAME : RegExp = new RegExp( "<span class=\"nickname\">[^<]+</span></a>[ /]*([^<]+)" );		
		public static const REGEX_PARSE_FOLLOWER_SCREEN_NAME : RegExp = new RegExp( "<a href=\"http://twitter.com/(.*?)\" rel=\"contact\"" );		
		public static const REGEX_PARSE_FOLLOWER_DESCRIPTION : RegExp = new RegExp( "class=\"url uid\" title=\"(.*?)\"><span class=\"nickname\">" );
		public static const REGEX_PARSE_FOLLOWER_PROFILE_IMAGE : RegExp = new RegExp( "class=\"photo fn\".*?src=\"(.*?)\"" );
		
		public static const REGEX_PARSE_FOLLOWER_NEXT_PAGE : RegExp = new RegExp( "<a href=\"\/followers.page=([0-9])\" class=\"section_links\" rel=\"me next\"" );
		
		// USER TIMELINE
		public static const REGEX_PARSE_USER_TIMELINE_STATUS : RegExp = new RegExp( "<li class=\"hentry.*?\" id=\".*?\">.*?<\/li>", "g" );
		public static const REGEX_PARSE_USER_TIMELINE_ID : RegExp = new RegExp( "<li class=\"hentry status.*?\" id=\"status_(.*?)\"" );
		public static const REGEX_PARSE_USER_TIMELINE_CREATED_AT : RegExp = new RegExp( "<span class=\"published\">(.*?)</span>" );
		public static const REGEX_PARSE_USER_TIMELINE_TEXT : RegExp = new RegExp( "<span class=\"entry-content\">(.*?)<\/span>" );		
		
		//public static const REGEX_PARSE_USER_TIMELINE_SOURCE : RegExp = new RegExp( "<span class=\"published\" title=\".*?\">.*?</span>.*?</a>.*?<span>from (<a href=\".*?\">.*?<\/a>)</span>" );
		public static const REGEX_PARSE_USER_TIMELINE_SOURCE : RegExp = new RegExp( "<span class=\"published\">.*?</span>.*?</a>.*?<span>from (<a href=\".*?\">.*?<\/a>)</span>" );
		
		// USER TIMELINE USER
		//public static const REGEX_PARSE_USER_TIME_LINE_USERNAME : RegExp = new RegExp( "/home.status=@(.*?)(%20.*?)*\" onclick" );
		public static const REGEX_PARSE_USER_TIME_LINE_USERNAME : RegExp = new RegExp( "<span class=\"thumb vcard author\"><a href=\"http://twitter.com/(.*?)\"" );		
		public static const REGEX_PARSE_USER_TIME_LINE_PROFILE_IMAGE : RegExp = new RegExp( "class=\"photo fn\".*?src=\"(.*?)\"" );
		
		public static const REGEX_PARSE_USER_NEXT_PAGE : RegExp = new RegExp( "<a href=\"\/home.page=([0-9]+)\" class=\"section_links\" rel=\"prev\">Older" );
		
		// REPLIES		
		public static const REGEX_PARSE_REPLIES : RegExp = new RegExp( "<li class=\"hentry status.*?\" id=\".*?\">.*?<\/li>", "g" );
		public static const REGEX_PARSE_REPLY_ID : RegExp = new RegExp( "<li class=\"hentry status\" id=\"status_(.*?)\"" );
		public static const REGEX_PARSE_REPLY_CREATED_AT : RegExp = new RegExp( "<span class=\"published\">(.*?)</span>" );
		public static const REGEX_PARSE_REPLY_TEXT : RegExp = new RegExp( "<span class=\"entry-content\"> *(.*?) *<\/span>" );		
		//public static const REGEX_PARSE_REPLY_SOURCE : RegExp = new RegExp( "<span class=\"published\" title=\".*?\">.*?</span>.*?</a> from (<a href=\".*?\">.*?<\/a>)" );
		//public static const REGEX_PARSE_REPLY_SOURCE : RegExp = new RegExp( "<span class=\"published\" title=\".*?\">.*?</span>.*?</a>.*?<span>from *(<a href=\".*?\">.*?<\/a>)</span>" );
		
				public static const REGEX_PARSE_REPLY_SOURCE : RegExp = new RegExp( "<span class=\"published\" title=\".*?\">.*?</span>.*?</a>.*?<span>from (<a href=\".*?\">.*?<\/a>)</span>" );		
		
		// REPLY USER
		public static const REGEX_PARSE_REPLY_USERNAME : RegExp = new RegExp( "<span class=\"thumb vcard author\"><a href=\"http://twitter.com/(.*?)\"" );
		public static const REGEX_PARSE_REPLY_PROFILE_IMAGE : RegExp = new RegExp( "class=\"photo fn\".*?src=\"(.*?)\"" );
		
		public static const REGEX_PARSE_REPLY_NEXT_PAGE : RegExp = new RegExp( "<a href=\"\/home.page=([0-9]+)\" class=\"section_links\" rel=\"prev\">Older" );
		// PUBLIC TIMELINE
		
		public static const REGEX_PARSE_PUBLIC_TIMELINE : RegExp = new RegExp( "<li class=\"hentry.*?\" id=\".*?\">.*?<\/li>", "g" );
		
		public static const REGEX_PARSE_PUBLIC_TIMELINE_ID : RegExp = new RegExp( "<li class=\"hentry status.*?\" id=\"status_(.*?)\"" );
		public static const REGEX_PARSE_PUBLIC_TIMELINE_CREATED_AT : RegExp = new RegExp( "<span class=\"published\">(.*?)</span>" );
		public static const REGEX_PARSE_PUBLIC_TIMELINE_TEXT : RegExp = new RegExp( "<span class=\"entry-content\"> *(.*?) *<\/span>" );		
		public static const REGEX_PARSE_PUBLIC_TIMELINE_SOURCE : RegExp = new RegExp( "<span class=\"published\" title=\".*?\">.*?</span>.*?</a>.*?<span>from (<a href=\".*?\">.*?<\/a>)</span>" );
		
		
		// PUBLIC TIMELINE PUBLIC		
        public static const REGEX_PARSE_PUBLIC_TIME_LINE_USERNAME : RegExp = new RegExp( "<span class=\"thumb vcard author\"><a href=\"http://twitter.com/(.*?)\"" );
		//public static const REGEX_PARSE_PUBLIC_TIME_LINE_USERNAME : RegExp = new RegExp( "/home.status=@(.*?)\" onclick" );
		public static const REGEX_PARSE_PUBLIC_TIME_LINE_PROFILE_IMAGE : RegExp = new RegExp( "class=\"photo fn\".*?src=\"(.*?)\"" );
		
		public var username : String;
		public var password : String;
		public var encodedCredentials : String;
		
		[Bindable]
		private var _friends : ArrayCollection;
		
		[Bindable]
		private var _followers : ArrayCollection;
		
		[Bindable]
		private var _userTimeline : ArrayCollection;
		
		private var _userComments : CommentCache = new CommentCache(); 
		
		[Bindable]
		private var _replies : ArrayCollection;
		
		//private var _publicTimeline : ArrayCollection;
		
		private var _timeLineRequest : URLRequest;
		private var _timeLineLoader  : URLLoader;
		
		private var _publicTimeLineRequest : URLRequest = new URLRequest( "http://twitter.com/public_timeline" );
		private var _publicTimeLineLoader  : URLStream  = new URLStream();
		
		public function TwitterScrape() : void
		{
			_publicTimeLineRequest.cacheResponse = false;
	        _publicTimeLineRequest.method = "POST";
	        
	        _publicTimeLineRequest.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        _publicTimeLineRequest.requestHeaders.push( authHeader );	        
	        
	       	_publicTimeLineLoader.addEventListener( Event.COMPLETE, handleLoadPublicTimeline, false, 0, true  );
		}
		
		public function logout() : void
		{
			setAuth( null, null );
			_userComments = new CommentCache();			
		}	
			
		public function setAuth( username:String, password:String ) : void
		{
			this.username = username;
			this.password = password;
			
			var enc : Base64Encoder = new Base64Encoder();
			enc.encode( username + ":" + password );
			encodedCredentials = enc.flush();
		}
			
		public function loadFriends( page : Number = -1 ) : void
		{	
			if( page == -1 )
			{
				_friends = new ArrayCollection();
				_timeLineRequest = new URLRequest( "http://twitter.com/friends" );
			}
			else
			{
				_timeLineRequest = new URLRequest( "http://twitter.com/friends?page=" + String(page) );
			}
			
			_timeLineRequest.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        _timeLineRequest.requestHeaders.push( authHeader );
	        _timeLineRequest.method = "POST";
	        
	        if( !_timeLineLoader )
	        {
	        	_timeLineLoader = new URLLoader();
	        	_timeLineLoader.addEventListener( Event.COMPLETE, handleLoadFriends, false, 0, true );
	        }
	        
	        
	        _timeLineLoader.load( _timeLineRequest );	    
		}
		
		private function handleLoadFriends( event : Event ) : void
		{
			var result : Array;
			
			var loader : URLLoader = event.target as URLLoader;
			var text : String = loader.data as String;

			text = ToroUtil.cleanTwitterStatus( text );
			
			var body : Array = text.match( REGEX_PARSE_FRIENDS );			
			
			for each( var htmlFriend : String in body )
			{
				var user : TwitterUser = new TwitterUser();
								
				result = htmlFriend.match( REGEX_PARSE_FRIEND_ID );
				if( ToroUtil.validRegexMatch(result) ) user.id = parseInt( result[1] );
				
				result = htmlFriend.match( REGEX_PARSE_FRIEND_NAME );				
				ToroUtil.validRegexMatch( result ) ? user.name = StringUtil.trim( result[1] ) : user.name = "";
				
				result = htmlFriend.match( REGEX_PARSE_FRIEND_SCREEN_NAME );
				if( ToroUtil.validRegexMatch(result) ) user.screenName = result[1];
					
				result = htmlFriend.match( REGEX_PARSE_FRIEND_DESCRIPTION );
				ToroUtil.validRegexMatch(result) ? user.description = StringUtil.trim( result[1] ) : user.description = "";  
								
				result = htmlFriend.match( REGEX_PARSE_FRIEND_PROFILE_IMAGE );
				if( ToroUtil.validRegexMatch(result) ) user.profileImageUrl = StringUtil.trim( result[1] );
				
				user.location = "";
				
				_friends.addItem( user );		
			}
			
			result = text.match( REGEX_PARSE_FRIEND_NEXT_PAGE );
			if( ToroUtil.validRegexMatch(result) ) 
			{
				loadFriends( parseInt(result[1]) );			
			}
			else
			{
				var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_FRIENDS_RESULT );
				twitterEvent.data = _friends;
				dispatchEvent( twitterEvent );
			}
		}
		
		public function loadFollowers( page : Number = -1 ) : void
		{
			var request : URLRequest;
			
			if( page == -1 )
			{
				_followers = new ArrayCollection();
				request = new URLRequest( "http://twitter.com/followers" );
			}
			else
			{
				request = new URLRequest( "http://twitter.com/followers?page=" + String(page) );
			}
			
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        
	        var loader : URLLoader = new URLLoader();
	        loader.addEventListener( Event.COMPLETE, handleLoadFollowers );
	        loader.load( request );	    
		}
		
		private function handleLoadFollowers( event : Event ) : void
		{			
			var result : Array;
			
			var loader : URLLoader = event.target as URLLoader;
			
			var text : String = loader.data as String;
			text = ToroUtil.cleanTwitterStatus( text );
			
			
			var body : Array = text.match( REGEX_PARSE_FOLLOWERS );			
			
			for each( var htmlFriend : String in body )
			{				
				var user : TwitterUser = new TwitterUser();
				
				result = htmlFriend.match( REGEX_PARSE_FOLLOWER_ID );
				if( ToroUtil.validRegexMatch(result) ) user.id = parseInt( result[1] );
				
				result = htmlFriend.match( REGEX_PARSE_FOLLOWER_NAME );				
				ToroUtil.validRegexMatch( result ) ? user.name = StringUtil.trim( result[1] ) : user.name = "";
				
				result = htmlFriend.match( REGEX_PARSE_FOLLOWER_SCREEN_NAME );
				if( ToroUtil.validRegexMatch(result) ) user.screenName = result[1];
					
				result = htmlFriend.match( REGEX_PARSE_FOLLOWER_DESCRIPTION );
				ToroUtil.validRegexMatch(result) ? user.description = StringUtil.trim( result[1] ) : user.description = "";  
								
				result = htmlFriend.match( REGEX_PARSE_FOLLOWER_PROFILE_IMAGE );
				if( ToroUtil.validRegexMatch(result) ) user.profileImageUrl = StringUtil.trim( result[1] );
				
				user.location = "";
							
				_followers.addItem( user );		
			}
			
			result = text.match( REGEX_PARSE_FOLLOWER_NEXT_PAGE );
			if( ToroUtil.validRegexMatch(result) ) 
			{
				loadFollowers( parseInt(result[1]) );			
			}
			else
			{
				var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_FOLLOWERS );
				twitterEvent.data = _followers;
				dispatchEvent( twitterEvent );
			}
		}
		
		public function loadUserTimeLine( page : Number = -1 ) : void
		{
			var request : URLRequest;
			
			if( page == -1 )
			{
				_userTimeline = new ArrayCollection();
				request = new URLRequest( "http://twitter.com/home" );				
			}
			else
			{
				request = new URLRequest( "http://twitter.com/home?page=" + String(page) );				
			}
			
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        
	        var loader : URLLoader = new URLLoader();
	        loader.addEventListener( Event.COMPLETE, handleLoadUserTimeline, false, 0, true );
	        loader.load( request );	    
		}
		
		private function handleLoadUserTimeline( event : Event ) : void
		{
			var result : Array;
			var status : TwitterStatus;
			
			var loader : URLLoader = event.target as URLLoader;
			var text : String = loader.data;
			
			text = ToroUtil.cleanTwitterStatus( text );
			
			var body : Array = text.match( REGEX_PARSE_USER_TIMELINE_STATUS );
			
			for each( var htmlStatus : String in body )
			{
				//Alert.show( htmlStatus );
				status = new TwitterStatus();
				
				result = htmlStatus.match( REGEX_PARSE_USER_TIMELINE_ID );
				
				ToroUtil.validRegexMatch( result ) ? status.id = parseInt( result[1] ) : status.id = -1;
				
				result = htmlStatus.match( REGEX_PARSE_USER_TIMELINE_CREATED_AT );
				ToroUtil.validRegexMatch( result ) ? status.createdAt = result[1] : status.createdAt = null;//ToroUtil.createDateFromTString( result[1] ) : status.createdAt = null;
				
				result = htmlStatus.match( REGEX_PARSE_USER_TIMELINE_TEXT );
				ToroUtil.validRegexMatch( result ) ? status.text = result[1] : status.text = "";
				
				result = htmlStatus.match( REGEX_PARSE_USER_TIMELINE_SOURCE );
				ToroUtil.validRegexMatch( result ) ? status.source = result[1] : status.source = "web";
				
				status.user = new TwitterUser();
				
				result = htmlStatus.match( REGEX_PARSE_USER_TIME_LINE_USERNAME );
				ToroUtil.validRegexMatch( result ) ? status.user.screenName = result[1] : status.user.screenName = username;
				
				result = htmlStatus.match( REGEX_PARSE_USER_TIME_LINE_PROFILE_IMAGE );
				ToroUtil.validRegexMatch( result ) ? status.user.profileImageUrl = result[1] : status.user.profileImageUrl = null;
				
				
				_userTimeline.addItem( status );
			}
			
			result = text.match( REGEX_PARSE_USER_NEXT_PAGE );
			text = null;
			loader = null;
			
			if( ToroUtil.validRegexMatch(result) &&
				parseInt(result[1]) < 3 )
			{				
				loadUserTimeLine( parseInt(result[1]) );
			}
			else
			{
				var newComments : ArrayCollection = _userComments.addComments( _userTimeline );
				var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_USER_TIMELINE_RESULT );
				twitterEvent.data = newComments;
				
				dispatchEvent( twitterEvent );				
			}									
		}
		
		public function loadReplies( page : Number = -1 ) : void
		{
			var request : URLRequest;
			
			if( page == -1 )
			{
				_replies = new ArrayCollection();
				request = new URLRequest( "http://twitter.com/replies" );				
			}
			else
			{
				request = new URLRequest( "http://twitter.com/replies?page=" + String(page) );				
			}
			
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        
	        var loader : URLLoader = new URLLoader();
	        loader.addEventListener( Event.COMPLETE, handleLoadReplies );
	        loader.load( request );	    
		}
		
		private function handleLoadReplies( event : Event ) : void
		{
			var result : Array;
			var reply : TwitterStatus;
				
			var loader : URLLoader = event.target as URLLoader;
			var text : String = loader.data;
			
			text = ToroUtil.cleanTwitterStatus( text );
			
			var body : Array = text.match( REGEX_PARSE_REPLIES );
			
			for each( var htmlReply : String in body )
			{	
				reply = new TwitterStatus();
				
				result = htmlReply.match( REGEX_PARSE_REPLY_ID );
				ToroUtil.validRegexMatch( result ) ? reply.id = parseInt( result[1] ) : reply.id = -1;
				
				result = htmlReply.match( REGEX_PARSE_REPLY_CREATED_AT );
				//PETE ToroUtil.validRegexMatch( result ) ? reply.createdAt = ToroUtil.createDateFromTString( result[1] ) : reply.createdAt = null;
				ToroUtil.validRegexMatch( result ) ? reply.createdAt = result[1] : reply.createdAt = null;
				result = htmlReply.match( REGEX_PARSE_REPLY_TEXT );
				ToroUtil.validRegexMatch( result ) ? reply.text = result[1] : reply.text = "";
				
				result = htmlReply.match( REGEX_PARSE_REPLY_SOURCE );
				ToroUtil.validRegexMatch( result ) ? reply.source = result[1] : reply.source = "web";
				
				reply.user = new TwitterUser();
				
				result = htmlReply.match( REGEX_PARSE_REPLY_USERNAME );
				ToroUtil.validRegexMatch( result ) ? reply.user.screenName = result[1] : reply.user.screenName = username;
				
				result = htmlReply.match( REGEX_PARSE_REPLY_PROFILE_IMAGE );
				ToroUtil.validRegexMatch( result ) ? reply.user.profileImageUrl = result[1] : reply.user.profileImageUrl = null;
				
				_replies.addItem( reply );				
			}
			
			result = text.match( REGEX_PARSE_USER_NEXT_PAGE );
			
			if( ToroUtil.validRegexMatch(result) &&
				parseInt(result[1]) < 3 )
			{				
				loadReplies( parseInt(result[1]) );
			}
			else
			{			
				var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_REPLIES );
				twitterEvent.data = _replies;
				dispatchEvent( twitterEvent );				
			}									
		}
	
		public function loadPublicTimeline() : void
		{   		        
	        _publicTimeLineLoader.load( _publicTimeLineRequest );	        
		}
		
		private function handleLoadPublicTimeline( event : Event ) : void
		{
			var array : ByteArray = new ByteArray();			
			_publicTimeLineLoader.readBytes( array, 0, _publicTimeLineLoader.bytesAvailable );
			
			var text : String = array.toString();			
			var publicTimeline : ArrayCollection = new ArrayCollection();			
			var nextText : String = ToroUtil.cleanTwitterStatus( text );
			
			var body : Array = nextText.match( REGEX_PARSE_PUBLIC_TIMELINE );
			
			
			for each( var htmlReply : String in body )
			{
				var result : Array;
				var publicStatus : TwitterStatus = new TwitterStatus();
					
				publicStatus.user = new TwitterUser();				
				
				result = htmlReply.match( REGEX_PARSE_PUBLIC_TIMELINE_ID );
				ToroUtil.validRegexMatch( result ) ? publicStatus.id = parseInt( result[1] ) : publicStatus.id = -1;
				
				result = htmlReply.match( REGEX_PARSE_PUBLIC_TIMELINE_CREATED_AT );
				//PETE ToroUtil.validRegexMatch( result ) ? publicStatus.createdAt = ToroUtil.createDateFromTString( result[1] ) : publicStatus.createdAt = null;
				ToroUtil.validRegexMatch( result ) ? publicStatus.createdAt = result[1] : publicStatus.createdAt = null;
				result = htmlReply.match( REGEX_PARSE_PUBLIC_TIMELINE_TEXT );
				ToroUtil.validRegexMatch( result ) ? publicStatus.text = result[1] : publicStatus.text = "";
				
				
				result = htmlReply.match( REGEX_PARSE_PUBLIC_TIMELINE_SOURCE );
				ToroUtil.validRegexMatch( result ) ? publicStatus.source = result[1] : publicStatus.source = "web";
				
				var user : TwitterUser = new TwitterUser();
				
				result = htmlReply.match( REGEX_PARSE_PUBLIC_TIME_LINE_USERNAME );				
				ToroUtil.validRegexMatch( result ) ? user.screenName = result[1] : user.screenName = username;
				
				result = htmlReply.match( REGEX_PARSE_PUBLIC_TIME_LINE_PROFILE_IMAGE );
				ToroUtil.validRegexMatch( result ) ? user.profileImageUrl = result[1] : user.profileImageUrl = null;
				
				publicStatus.user = user;
				publicTimeline.addItem( publicStatus );				
			}
						
			var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_PUBLIC_TIMELINE_RESULT );
			twitterEvent.data = publicTimeline;
			//twitterEvent.data = new ArrayCollection( ArrayUtil.createUniqueCopy( publicTimeline.toArray() ) );
			
			dispatchEvent( twitterEvent );
		}
	}	
}
/*
Twitter Library 2.0
*/
package twitter.api {
	
	import com.adobe.utils.XMLUtil;
	import com.adobe.xml.syndication.atom.Atom10;
	import com.adobe.xml.syndication.atom.Author;
	import com.adobe.xml.syndication.atom.Entry;
	import com.adobe.xml.syndication.atom.Link;
	
	import flash.events.*;
	import flash.net.*;
	import flash.xml.*;
	
	import mx.collections.ArrayCollection;
	import mx.utils.Base64Encoder;
	
	import twitter.api.data.*;
	import twitter.api.events.TwitterEvent;
	
	/**
	 * This is a wrapper class around the Twitter public API.
	 * The pattern for all of the calls is to:
	 * 1.) Use XML for the format
	 * 2.) Internally handle the event from the REST call
	 * 3.) Parse the XML into a strongly typed object
	 * 4.) Publish a TwitterEvent whose payload is the type object from above
	 */ 
	public class Twitter extends EventDispatcher
	{
		// constatns used for loaders
		private static const FRIENDS:String = "friends";
		private static const FRIENDS_TIMELINE:String = "friendsTimeline";
		private static const PUBLIC_TIMELINE:String = "timeline";
		private static const USER_TIMELINE:String = "userTimeline";
		private static const SET_STATUS:String = "setStatus";
		private static const FOLLOW_USER:String = "follow";
		private static const UNFOLLOW_USER : String = "unfollow";
		private static const SHOW_STATUS:String = "showStatus";
		private static const REPLIES:String = "replies";
		private static const DESTROY:String = "destroy";
		private static const FOLLOWERS:String = "followers";
		private static const FEATURED:String = "featured";
		private static const AUTHENTICATE : String = "authenticate";
		private static const EXTENDED_INFO : String = "extendedInfo";
		private static const RATE_LIMIT : String = "rateLimit";		
		private static const SEARCH : String = "search";
		
		private static const LOAD_FRIENDS_URL:String = "http://twitter.com/statuses/friends/$userId.xml";
		
		private static const LOAD_FRIENDS_TIMELINE_URL:String = "http://twitter.com/statuses/friends_timeline/$userId.xml";
		
		private static const PUBLIC_TIMELINE_URL:String = "http://twitter.com/statuses/public_timeline.xml";
		
		private static const LOAD_USER_TIMELINE_URL:String = "http://twitter.com/statuses/user_timeline.xml";
		
		private static const FOLLOW_USER_URL:String = "http://twitter.com/notifications/follow/$userId.xml";
		
		private static const UNFOLLOW_USER_URL:String = "http://twitter.com/notifications/leave/$userId.xml";
		
		private static const SET_STATUS_URL:String = "http://twitter.com/statuses/update.xml";
		
		private static const SHOW_STATUS_URL:String = "http://twitter.com/statuses/show/$id.xml";
		
		private static const REPLIES_URL:String = "http://twitter.com/statuses/replies.xml";
		
		private static const DESTROY_URL:String = "http://twitter.com/statuses/destroy/$id.xml";
		
		private static const FOLLOWERS_URL:String = "http://twitter.com/statuses/followers.xml";
		
		private static const FEATURED_USERS_URL:String = "http://twitter.com/statuses/featured.xml";
		
		public static const AUTHENTICATION_URL : String = "https://twitter.com/account/verify_credentials.xml";
		
		public static const EXTENDED_INFO_URL : String = "http://twitter.com/users/show/$id.xml";
		
		public static const RATE_LIMIT_URL : String = "http://twitter.com/account/rate_limit_status.xml";
		
		public static const SEARCH_URL : String = "http://search.twitter.com/search.atom?q=";
		
		private static const LITE:String = "?lite=true";
		
		
		
		// internal variables
		private var loaders:Array;
		// username and password currently not used, just rely on HTTP auth
		public var username:String;
		public var password:String;
		public var encodedCredentials : String;
		
		function Twitter() 
		{
			loaders = [];
			this.addLoader(FRIENDS, friendsHandler);
			this.addLoader(FRIENDS_TIMELINE, friendsTimelineHandler);
			this.addLoader(PUBLIC_TIMELINE, publicTimelineHandler);
			this.addLoader(USER_TIMELINE, userTimelineHandler);
			this.addLoader(SET_STATUS, setStatusHandler);
			this.addLoader(FOLLOW_USER, friendCreatedHandler);
			this.addLoader(UNFOLLOW_USER, unfollowHandler );
			this.addLoader(SHOW_STATUS, showStatusHandler);
			this.addLoader(REPLIES, repliesHandler);
			this.addLoader(DESTROY, destroyHandler);
			this.addLoader(FOLLOWERS, followersHandler);
			this.addLoader(FEATURED, featuredHandler);
			this.addLoader( AUTHENTICATE, authHandler );
			this.addLoader( EXTENDED_INFO, extendedInfoHandler );
			this.addLoader( RATE_LIMIT, rateLimitHandler );
			this.addLoader( SEARCH, searchHandler );
		}
	
		// Public API
		
		/**
		* Loads a list of Twitter friends and (optionally) their statuses. 
		 * Authentication required for private users.
		*/
		public function loadFriends(userId:String, lite:Boolean = true):void
		{
			trace( "load friends" );			
			var friendsLoader:URLLoader = this.getLoader(FRIENDS);
			var urlStr:String = LOAD_FRIENDS_URL.replace("$userId", userId);
			if (lite)
			{
				urlStr += LITE;
			}
			friendsLoader.load(twitterRequest(urlStr));
		}
		/**
		* Loads the timeline of all friends on Twitter. Authentication required for private users.
		*/
		public function loadFriendsTimeline( userId:String, id : Number = -1 ) : void
		{
			var request : URLRequest = twitterRequest(LOAD_FRIENDS_TIMELINE_URL.replace("$userId",userId))
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
			
			if( id != -1 )
			{
				var variables : URLVariables = new URLVariables();
				variables.since_id = id;
				request.data = variables;
			}
	        
			var friendsTimelineLoader:URLLoader = this.getLoader(FRIENDS_TIMELINE);
			friendsTimelineLoader.load( request );
		}
		/**
		* Loads the timeline of all public users on Twitter.
		*/
		public function loadPublicTimeline():void
		{
			var publicTimelineLoader:URLLoader = this.getLoader(PUBLIC_TIMELINE);
			var request : URLRequest = twitterRequest( PUBLIC_TIMELINE_URL );
			request.cacheResponse = false;
			
			publicTimelineLoader.load(request);
		}
		/**
		* Loads the timeline of a specific user on Twitter. Authentication required for private users.
		*/
		public function loadUserTimeline(userId:String):void
		{
			/*
			var userTimelineLoader:URLLoader = this.getLoader(USER_TIMELINE);
			userTimelineLoader.load(twitterRequest(LOAD_USER_TIMELINE_URL.replace("$userId", userId)));
			*/
			var request : URLRequest = twitterRequest( LOAD_USER_TIMELINE_URL );
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        
	        var variables : URLVariables = new URLVariables();
			variables.id = userId;
			request.data = variables;
				
	        try
			{
				this.getLoader(USER_TIMELINE).load( request );
			} 
			catch (error : Error)
			{
				trace( "Unable to load user timeline" );
			}
	        
		}
		
		/**
		 * Follows a user. Right now this uses the /friendships/create/user.format
		 */
		public function follow( userId : String ) : void
		{
			var request:URLRequest = twitterRequest(FOLLOW_USER_URL.replace("$userId",userId));
			request.method = "POST";
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
		    request.requestHeaders.push( authHeader );
		    request.method = "POST";
		    
		    try
		    {
		    	this.getLoader(FOLLOW_USER).load( request );
		    }
		    catch( error : Error )
		    {
		    	trace( "failed to follow user" );
		    }
		}
		
		public function unfollow( userId : String ) : void
		{
			var request:URLRequest = twitterRequest(UNFOLLOW_USER_URL.replace("$userId",userId));
			request.method = "POST";
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
		    request.requestHeaders.push( authHeader );
		    request.method = "POST";		
		    
		    try
		    {
		    	this.getLoader(UNFOLLOW_USER).load( request );		    			    	
		    }   
		    catch( error : Error )
		    {
		    	trace( "failed to follow user" );		    	
		    }
		}
		
		/**
		* Sets user's Twitter status. Authentication required.
		*/
		public function setStatus(statusString:String):void
		{
			if (statusString.length <= 140)
			{
				var request : URLRequest = twitterRequest (SET_STATUS_URL);
				
				var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
		        request.requestHeaders.push( authHeader );
		        request.method = "POST";		            
		        		        
				var variables : URLVariables = new URLVariables();
				variables.status = statusString;
				variables.source = "toro";
				request.data = variables;
				
				try
				{
					this.getLoader(SET_STATUS).load( request );
				} 
				catch (error : Error)
				{
					trace( "Unable to set status" );
				}
			}
			else
			{
				trace( "STATUS NOT SET: status limited to 140 characters" );
			}
		}
		
		public function getRateLimit() : void
		{
			var request : URLRequest = twitterRequest( RATE_LIMIT_URL );
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";		            
	        
			try
			{
				this.getLoader(RATE_LIMIT).load( request );
			} 
			catch (error : Error)
			{
				trace( "could not get rate limit" );
			}			
		}
		
		public function search( searchText : String ) : void
		{
			var request : URLRequest = twitterRequest( SEARCH_URL + searchText );
			try
			{
				this.getLoader( SEARCH ).load( request );
			}
			catch( error : Error )
			{
				trace( "unable to search" );
			}
			
						
		}
		
		public function authenticate() : void
		{
			var request : URLRequest = twitterRequest( AUTHENTICATION_URL );
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        			
	        try
			{
				var loader : URLLoader = this.getLoader( AUTHENTICATE );
				trace(loader.toString());
				loader.load( request );
			} 
			catch( error : Error )
			{
				trace( "Unable to authencate" );
			}
		}
		
		public function getExtendedInfo( user : String ) : void
		{
			var request : URLRequest = twitterRequest( EXTENDED_INFO_URL.replace("$id",user) );
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        			
	        try
			{
				this.getLoader( EXTENDED_INFO ).load( request );
			} 
			catch( error : Error )
			{
				trace( "Unable to get extended user info" );
			}
		}
		
		/**
		 * Returns a single status, specified by the id parameter below.  
		 * The status's author will be returned inline.
		 */
		public function showStatus(id:String):void
		{
			var showStatusLoader:URLLoader = this.getLoader(SHOW_STATUS);
			showStatusLoader.load(twitterRequest(SHOW_STATUS_URL.replace("$id",id)));
		}
		
		/**
		 * Loads the most recent replies for the current authenticated user
		 */
		public function loadReplies():void
		{
			var request : URLRequest = twitterRequest( REPLIES_URL );
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        			
	        try
			{
				this.getLoader( REPLIES ).load( request );
			} 
			catch( error : Error )
			{
				trace( "Unable to get replies" );
			}
			
			//var repliesLoader:URLLoader = this.getLoader(REPLIES);
			//repliesLoader.load(twitterRequest(REPLIES_URL));
		}
		
		public function loadFollowers(lite:Boolean=true):void
		{
			trace( "load followers" );
			var request : URLRequest = twitterRequest( FOLLOWERS_URL );
			request.authenticate = false;
			
			var authHeader : URLRequestHeader = new URLRequestHeader( "Authorization", "Basic " + encodedCredentials );
	        request.requestHeaders.push( authHeader );
	        request.method = "POST";
	        
	        try
			{
				this.getLoader( FOLLOWERS ).load( request );
			} 
			catch( error : Error )
			{
				trace( "Unable to get followers" );
			}
		}
		
		public function loadFeatured():void
		{
			var featuredLoader:URLLoader = this.getLoader(FEATURED);
			featuredLoader.load(twitterRequest(FEATURED_USERS_URL));
		}
		
		// currently unused
		/**
		*  setAuth should be called before any methods that require authentication. PLEASE USE WITH CAUTION, Twitter user information should NOT be hardcoded in applications that are publicly available
		*/
		public function setAuth (username:String, password:String):void
		{
			this.username = username;
			this.password = password;
			
			var enc : Base64Encoder = new Base64Encoder();
			enc.encode( username + ":" + password );
			encodedCredentials = enc.flush();
		}
		
		public function logout() : void
		{
			this.username = null;
			this.password = null;
			this.encodedCredentials = null;
		}			
		
		// private handlers for the events coming back from twitter
		
		private function friendsHandler(e:Event):void {
			var xml:XML = new XML(this.getLoader(FRIENDS).data);
			var userArray:Array = new Array();
            for each (var tempXML:XML in xml.children()) {
				var twitterUser:TwitterUser = new TwitterUser(tempXML);
                userArray.push(twitterUser);
            }
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_FRIENDS_RESULT);
			r.data = userArray;
			dispatchEvent (r);
		}
			
		private function friendsTimelineHandler(e:Event):void {
			var xml:XML = new XML(this.getLoader(FRIENDS_TIMELINE).data);
			
			var statusArray:Array = new Array();
			
            for each (var tempXML:XML in xml.children()) 
            {
            	var user : TwitterUser = new TwitterUser( tempXML.user[0] );
				var twitterStatus:TwitterStatus = new TwitterStatus ( tempXML, user );
                statusArray.push(twitterStatus );
            }
            
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_FRIENDS_TIMELINE_RESULT);
			r.data = statusArray;
			dispatchEvent (r);
		}
		
		private function publicTimelineHandler(e:Event) : void
		{			
			var xml:XML = new XML(this.getLoader(PUBLIC_TIMELINE).data);
			
			var statusArray:Array = new Array();
			
            for each (var tempXML:XML in xml.children()) 
            {
				var twitterStatus:TwitterStatus = new TwitterStatus (tempXML);
                statusArray.push(twitterStatus );
            }
            
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_PUBLIC_TIMELINE_RESULT);
			r.data = statusArray;
			dispatchEvent (r);
		}
		
		private function userTimelineHandler(e:Event):void {
			var xml:XML = new XML(this.getLoader(USER_TIMELINE).data);
			var statusArray:Array = new Array();
            for each (var tempXML:XML in xml.children()) {
				var twitterStatus:TwitterStatus = new TwitterStatus (tempXML)
                statusArray.push(twitterStatus );
            }
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_USER_TIMELINE_RESULT);
			r.data = statusArray;
			dispatchEvent (r);
		}
		
		
		private function setStatusHandler (e : Event) : void
		{
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_SET_STATUS);
			r.data = "success";
			dispatchEvent (r);
		}
		
		private function rateLimitHandler( e : Event ) : void
		{
			var xml : XML = new XML( this.getLoader(RATE_LIMIT).data );
			
			var rateLimit : TwitterRateLimit = new TwitterRateLimit( xml );
			var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_RATE_LIMIT_RESULT );
			twitterEvent.data = rateLimit;
			dispatchEvent( twitterEvent );
		}
		
		private function friendCreatedHandler( e : Event ) : void
		{
			var event : TwitterEvent = new TwitterEvent( TwitterEvent.ON_FOLLOW_SUCCESS );
			event.data = getLoader( FOLLOW_USER ).data;
			trace( "follow " + event.data );			
			dispatchEvent( event );
		}
		
		private function unfollowHandler( e : Event ) : void
		{
			var event : TwitterEvent = new TwitterEvent( TwitterEvent.ON_UNFOLLOW_SUCCESS );
			event.data = getLoader( UNFOLLOW_USER ).data;
			trace( "unfollow " + event.data );			
			dispatchEvent( event );
		}
		
		private function showStatusHandler(e:Event):void
		{
			var xml:XML = new XML(this.getLoader(SHOW_STATUS).data);
			var twitterStatus:TwitterStatus = new TwitterStatus(xml);
			var twitterEvent:TwitterEvent = new TwitterEvent(TwitterEvent.ON_SHOW_STATUS);
			twitterEvent.data = twitterStatus;
			dispatchEvent(twitterEvent);
		}
		
		private function repliesHandler(e:Event):void
		{
			var xml:XML = new XML(this.getLoader(REPLIES).data);
			var statusArray:Array = [];
			for each(var reply:XML in xml.children())
			{
				statusArray.push(new TwitterStatus(reply));
			}
			var twitterEvent:TwitterEvent = new TwitterEvent(TwitterEvent.ON_REPLIES);
			twitterEvent.data = statusArray;
			dispatchEvent(twitterEvent);
		}
		
		private function destroyHandler(e:Event):void
		{
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_DESOTRY);
			r.data = "success";
			dispatchEvent (r);
		}
		
		private function errorHandler( errorEvent : IOErrorEvent ) : void
		{			
			trace ( errorEvent.text );
			
			var event : TwitterEvent
			
			if( errorEvent.text.indexOf( SET_STATUS_URL ) != -1 )
			{
				event = new TwitterEvent( TwitterEvent.ON_SET_STATUS_FAILED );				
			}
			
			if( errorEvent.text.indexOf( AUTHENTICATION_URL ) != -1 )
			{				
				event = new TwitterEvent( TwitterEvent.ON_LOGIN_ERROR );
			}
			
			if( errorEvent.text.indexOf( PUBLIC_TIMELINE_URL ) != -1 )
			{
				event = new TwitterEvent( TwitterEvent.ON_PUBLIC_TIMELINE_FAILED );
			}
			
			if( errorEvent.text.indexOf( LOAD_FRIENDS_TIMELINE_URL.replace("$userId",username) ) != -1 )				
			{
				event = new TwitterEvent( TwitterEvent.ON_USER_TIMELINE_FAILED );								
			}
			
			if( errorEvent.text.indexOf( REPLIES_URL ) != -1 )
			{
				event = new TwitterEvent( TwitterEvent.ON_REPLIES_FAILED );
			}
			
			if( errorEvent.text.indexOf( FOLLOW_USER_URL ) != -1 )
			{
				event = new TwitterEvent( TwitterEvent.ON_FOLLOW_FAILED );
			}
			
			if( event == null )
			{
				event = new TwitterEvent( TwitterEvent.ON_UNCAUGHT_FAILURE );				
			}
			
			dispatchEvent( event );
		}
		
		private function followersHandler(e:Event):void
		{			
			var xml:XML = new XML(this.getLoader(FOLLOWERS).data);
			var userArray:Array = new Array();
            for each (var tempXML:XML in xml.children()) {
				var twitterUser:TwitterUser = new TwitterUser(tempXML);
                userArray.push(twitterUser);
            }
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_FOLLOWERS);
			r.data = userArray;
			dispatchEvent (r);
		}
		
		private function featuredHandler(e:Event):void
		{
			var xml:XML = new XML(this.getLoader(FEATURED).data);
			var userArray:Array = new Array();
            for each (var tempXML:XML in xml.children()) {
				var twitterUser:TwitterUser = new TwitterUser(tempXML);
                userArray.push(twitterUser);
            }
			var r:TwitterEvent = new TwitterEvent (TwitterEvent.ON_FEATURED);
			r.data = userArray;
			dispatchEvent (r);
		}
		
		private function authHandler( e : Event ) : void
		{
			var loader : URLLoader = this.getLoader( AUTHENTICATE );
			
			var event : TwitterEvent;
			
			if( XML(loader.data).toString().match(new RegExp("user")))
			{
				trace("auth");
				event = new TwitterEvent( TwitterEvent.ON_LOGIN_SUCCESS );			
				dispatchEvent( event );
			}else{
				trace( XML(loader.data));
			}
		}
		
		private function extendedInfoHandler( e : Event ) : void
		{
			var loader : URLLoader = this.getLoader( EXTENDED_INFO );			
		}
		
		private function searchHandler( e : Event ) : void
		{			
			var loader : URLLoader = getLoader( SEARCH );			
			var rawAtom : String = loader.data;
				
				if( !XMLUtil.isValidXML(rawAtom) )
				{
					trace( "search result not valid XML" );
					return;
				}
				
				var atom : Atom10 = new Atom10();
				atom.parse( rawAtom );				
				var entries : Array = atom.entries;
				
				var results : ArrayCollection = new ArrayCollection();
				
				for each( var entry : Entry in entries )
				{										
					var status : TwitterStatus = new TwitterStatus( null );
					status.text = entry.title;
					//status.text = ToroUtil.htmlFormatComment( entry.title );
					
					for each( var link : Link in entry.links )
					{
						if( link.type == "image/png" )
						{
							var user : TwitterUser = new TwitterUser( null );
							user.profileImageUrl = link.href;
							
							var author : Author = entry.authors[0] as Author;
							user.screenName = author.name.substr( 0, author.name.indexOf(' ') );					
							status.user = user;							
						}
					}
					
					
					results.addItem( status );
				}
				
				var twitterEvent : TwitterEvent = new TwitterEvent( TwitterEvent.ON_SEARCH_SUCCESS );
				twitterEvent.data = results;
				
				dispatchEvent( twitterEvent );
		}		
		
		// private helper methods
		
		private function addLoader(name:String, completeHandler:Function):void
		{
			var loader:URLLoader = new URLLoader();
												
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			
			this.loaders[name] = loader;
		}
		
		private function getLoader(name:String):URLLoader
		{
			return this.loaders[name] as URLLoader;
		}
		
		private static function twitterRequest (URL : String):URLRequest
		{
			var r:URLRequest = new URLRequest (URL)
			return r;
		}
	}
}
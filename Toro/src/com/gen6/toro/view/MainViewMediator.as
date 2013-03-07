package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.ConfigurationVO;
	import com.gen6.toro.entity.LoginVO;
	import com.gen6.toro.entity.ShrinkUrlVO;
	import com.gen6.toro.entity.TwitPicVO;
	import com.gen6.toro.events.FriendSelectedEvent;
	import com.gen6.toro.events.RetweetEvent;
	import com.gen6.toro.view.components.CommentItemRenderer;
	import com.gen6.toro.view.components.LoginView;
	import com.gen6.toro.view.components.MainView;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainViewMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "MainViewMediator";
		
		public var config : ConfigurationVO;
		
		private var _login : LoginView;
		
		private var _userTimelineTimer : Timer = new Timer( 1000 * 21 );
		private var _publicTimelineTimer : Timer = new Timer( 1000 * 30 );
		private var _repliesTimer : Timer = new Timer( 1000 * 60 );
		private var _friendsTimer : Timer = new Timer( 1000 * 60 * 5.2 );
		private var _followersTimer : Timer = new Timer( 1000 * 60 * 5.5 );
		
		public function MainViewMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			
			_userTimelineTimer.addEventListener( TimerEvent.TIMER, loadUserTimeline, false, 0, true );
			_publicTimelineTimer.addEventListener( TimerEvent.TIMER, loadPublicTimeline );
			_repliesTimer.addEventListener( TimerEvent.TIMER, loadReplies, false, 0, true );
			_friendsTimer.addEventListener( TimerEvent.TIMER, loadFriends, false, 0, true );
			_followersTimer.addEventListener( TimerEvent.TIMER, loadFollowers, false, 0, true );
			
			mainView.addEventListener( MainView.SHOW_FEED_BACK, handleShowFeedBack );
			mainView.addEventListener( MainView.SHOW_SETTINGS, handleShowSettings );
			mainView.addEventListener( MainView.LOGOUT_SELECTED, handleLogoutSelected );
			
			mainView.addEventListener( MainView.SHRINK_URL, handleRequestShrinkUrl );
			mainView.addEventListener( MainView.UPLOAD_TO_TWITPIC, handleRequestUploadToTwitPic );
			
			mainView.addEventListener( MainView.REQUEST_SEND_COMMENT, handleRequestSendComment );
			mainView.addEventListener( CommentItemRenderer.REPLY_TO_USER, handleReplyToUser );
			mainView.addEventListener( CommentItemRenderer.RETWEET, handleRetweet );
			mainView.addEventListener( MainView.EVENT_SEARCH, handleSearchRequest );
		}
		
		private function loadUserTimeline( event : Event = null ) : void
		{
			mainView.setProgress( true, MainView.VIEW_USER );
			sendNotification( ApplicationFacade.SCRAPE_USER_TIMELINE );
		}
		
		private function loadPublicTimeline( event : Event = null ) : void
		{
			mainView.setProgress( true, MainView.VIEW_PUBLIC );
			sendNotification( ApplicationFacade.SCRAPE_PUBLIC_TIMELINE );
		}
		
		private function loadReplies( event : Event = null ) : void
		{
			mainView.setProgress( true, MainView.VIEW_REPLIES );
			sendNotification( ApplicationFacade.SCRAPE_REPLIES );			
		}
		
		private function loadFriends( event : Event = null ) : void
		{
			mainView.setProgress( true, MainView.VIEW_FRIENDS );
			sendNotification( ApplicationFacade.SCRAPE_FRIENDS );			
		}
		
		private function loadFollowers( event : Event = null ) : void
		{
			mainView.setProgress( true, MainView.VIEW_FRIENDS );
			sendNotification( ApplicationFacade.SCRAPE_FOLLOWERS );
		}
		
		private function handleReplyToUser( event : FriendSelectedEvent ) : void
		{	
			mainView.ta_comment.setFocus();
			mainView.ta_comment.text = "@" + event.friend.screenName + " ";
			mainView.ta_comment.setSelection((mainView.ta_comment.text.length),(mainView.ta_comment.text.length));
			
		}
		
		private function handleRetweet( event : RetweetEvent ) : void
		{
			mainView.ta_comment.setFocus();
			var text : String = ""
			var textType : Number = config.retweetText;
			
			//var textType : Number = sqlProxy.configOptions.retweetText;
			
			if(textType == 0)
			{
				text = "";
				text += "retweet @" + event.friend.screenName + ": " + event.message + " ";
				if(text.length > 140) textType = 1;
			}
			
			if(textType == 1)
			{
				text = "";
				text += "rt @" + event.friend.screenName + ": " + event.message + " ";
				if(text.length > 140) textType = 2;
			}
			
			if(textType == 2)
			{
				text = "";
				text += "retweet: " + event.message + " ";
				if(text.length > 140) textType = 3;
			}
			
			if(textType == 3)
			{
				text = "";
				text += "rt: " + event.message + " ";
				if(text.length > 140) textType = 4;
			}
			
			if(textType == 4)
			{
				text = "";
				text += event.message + " ";
			}
			
			// "rt @" 
			//text += event.friend.screenName + ": " + event.message + " ";
			mainView.ta_comment.text = text;
			
			mainView.ta_comment.setSelection((mainView.ta_comment.text.length),(mainView.ta_comment.text.length));
			
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.GET_USER_TIMELINE_RESULT,
					ApplicationFacade.GET_PUBLIC_COMMENTS_SUCCESS,
					ApplicationFacade.GET_REPLIES_SUCCESS,
					ApplicationFacade.SEARCH_SUCCESS,
					ApplicationFacade.GET_FRIENDS_SUCCESS,
					ApplicationFacade.GET_FOLLOWERS_SUCCESS,
					ApplicationFacade.SEND_COMMENT_SUCCESS,
					ApplicationFacade.SHRINK_URL_SUCCESS,
					ApplicationFacade.SHRINK_URL_FAILED,
					ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS,
					ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_FAILED,
					ApplicationFacade.VALID_LOGIN,
					ApplicationFacade.INVALID_LOGIN,
					ApplicationFacade.LOGIN_ERROR,					
					ApplicationFacade.LOGOUT,
					ApplicationFacade.GET_CONFIG_SUCCESS,
					ApplicationFacade.UPLOAD_TO_TWITPIC_SUCCESS,
					ApplicationFacade.UPLOAD_TO_TWITPIC_FAILED
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{			
			switch( notification.getName() )
			{
				case ApplicationFacade.GET_USER_TIMELINE_RESULT :
					mainView.setProgress( false, MainView.VIEW_USER );
					mainView.userTimeline = notification.getBody() as ArrayCollection;
					break;
					
				case ApplicationFacade.GET_PUBLIC_COMMENTS_SUCCESS :
					mainView.setProgress( false, MainView.VIEW_PUBLIC );
					mainView.publicTimeline = notification.getBody() as ArrayCollection;
					break;
				
				case ApplicationFacade.GET_REPLIES_SUCCESS :
					mainView.setProgress( false, MainView.VIEW_REPLIES ); 
					mainView.replies = notification.getBody() as ArrayCollection;
					break;
					
				case ApplicationFacade.SEARCH_SUCCESS : 
					mainView.setProgress( false, MainView.VIEW_SEARCH );
					mainView.searchResults = notification.getBody() as ArrayCollection;
					break;
				
				case ApplicationFacade.GET_FRIENDS_SUCCESS :
					mainView.setProgress( false, MainView.VIEW_FRIENDS );
					mainView.friends = notification.getBody() as ArrayCollection;
					break;
				
				case ApplicationFacade.GET_FOLLOWERS_SUCCESS :
					mainView.setProgress( false, MainView.VIEW_FRIENDS );
					mainView.followers = notification.getBody() as ArrayCollection;
					break;
					
				case ApplicationFacade.SEND_COMMENT_SUCCESS :
					mainView.setSendCommentSuccess();
					loadUserTimeline();
					break;
					
				case ApplicationFacade.SHRINK_URL_SUCCESS :					
					mainView.shrunkURL = notification.getBody() as String;
					break;
					
				case ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_SUCCESS :										
					sendNotification( ApplicationFacade.LOGIN, notification.getBody() as LoginVO );
					break;
					
				case ApplicationFacade.LOAD_ENCRYPTED_CREDENTIALS_FAILED :
					showLogin();
					break;
					
				case ApplicationFacade.SHRINK_URL_FAILED :	
					mainView.setShinkUrlFailed();				
					break;
					
				case ApplicationFacade.UPLOAD_TO_TWITPIC_SUCCESS :
					mainView.twitPicSuccess = "huzzah";
					mainView.setSendCommentSuccess();
					loadUserTimeline();
					break;
					
				case ApplicationFacade.UPLOAD_TO_TWITPIC_FAILED :
					mainView.setUploadToTwitPicFailed();
					break;
					
				case ApplicationFacade.VALID_LOGIN :
					
					PopUpManager.removePopUp( _login );
					
					loadUserTimeline();
					loadPublicTimeline();
					loadReplies();
					loadFriends();
					loadFollowers();
					
					sendNotification(  ApplicationFacade.GET_CONFIG,this);
					
					//sendNotification( ApplicationFacade.SCRAPE_USER_TIMELINE );
					//sendNotification( ApplicationFacade.SCRAPE_FRIENDS );
					//sendNotification( ApplicationFacade.SCRAPE_REPLIES );
					//sendNotification( ApplicationFacade.SCRAPE_FOLLOWERS );
					//sendNotification( ApplicationFacade.SCRAPE_PUBLIC_TIMELINE );
					
					_userTimelineTimer.start();
					_publicTimelineTimer.start();
					_repliesTimer.start();	
					_friendsTimer.start();
					_followersTimer.start();
					
					break;
				
				case ApplicationFacade.INVALID_LOGIN :
					_login.setLoginFailed();
					break;
				
				case ApplicationFacade.LOGIN_ERROR :
					_login.setLoginError();
					break;
				
				case ApplicationFacade.GET_CONFIG_SUCCESS :
					config = notification.getBody() as ConfigurationVO;
					break;
					
				default :
					break;
			}			
		}
		
		private function showLogin() : void
		{
			_login = PopUpManager.createPopUp( mainView, com.gen6.toro.view.components.LoginView, true ) as LoginView;
			PopUpManager.centerPopUp( _login );
			_login.addEventListener( LoginView.LOGIN_REQUESTED, handleLoginRequested );			
		}
		
		private function handleLoginRequested( event : Event ) : void
		{
			sendNotification( ApplicationFacade.LOGIN, _login.loginVO );			
		}
		
		private function get mainView() : MainView
		{			
			return( viewComponent as MainView );
		}
		
		/*
		private function handleUserViewCreated( event : Event ) : void
		{			
			trace( "user view created" );
			if( !facade.hasMediator( UserTimelineMediator.NAME ) )
			{
				facade.registerMediator( new UserTimelineMediator( mainView.homeView ) );
				sendNotification( ApplicationFacade.GET_USER_TIMELINE );				
			}
		}
		
		private function handleCommentViewCreated( event  : Event ) : void
		{
			if( !facade.hasMediator( FriendListMediator.NAME ) )
			{				
				facade.registerMediator( new FriendListMediator(mainView.friendView) );															
			}
		}
		
		private function handlePublicViewCreated( event : Event ) : void
		{
			if( !facade.hasMediator( PublicMediator.NAME ) )
			{
				facade.registerMediator( new PublicMediator( mainView.publicView ) );				
			}
		}
		
		private function handleRepliesViewCreated( event : Event ) : void
		{
			if( !facade.hasMediator( RepliesMediator.NAME ) )
			{
				facade.registerMediator( new RepliesMediator( mainView.repliesView ) );				
			}
		}
		
		private function handleSearchViewCreated( event : Event ) : void
		{
			if( !facade.hasMediator( SearchMediator.NAME ) )
			{
				facade.registerMediator( new SearchMediator( mainView.searchView ) );
			}
		}
		*/
		
		private function handleSearchRequest( event : Event ) : void
		{
			mainView.setProgress( true, MainView.VIEW_SEARCH );
			sendNotification( ApplicationFacade.SEARCH, mainView.t_query.text );
		}
		
		private function handleRequestSendComment( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SEND_COMMENT, mainView.commentText );
		}
		
		private function handleLogoutSelected( event : Event ) : void
		{
			_userTimelineTimer.stop();
			_publicTimelineTimer.stop();
			_repliesTimer.stop();
			_friendsTimer.stop();
			_followersTimer.stop();
			
			mainView.reset();
			sendNotification( ApplicationFacade.LOGOUT );
			showLogin();
		}
		
		private function handleShowFeedBack( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SHOW_FEED_BACK_VIEW );
		}
		
		private function handleShowSettings( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SHOW_SETTINGS );
		}
		
		private function handleRequestShrinkUrl( event : Event ) : void
		{
			var vo : ShrinkUrlVO = mainView.shrinkVO;
			
			sendNotification( ApplicationFacade.SHRINK_URL, vo );
		}
		
		private function handleRequestUploadToTwitPic( event : Event ) : void
		{
			var vo : TwitPicVO = mainView.twitPicVO;
			sendNotification( ApplicationFacade.UPLOAD_TO_TWITPIC, vo);
		}
	}
}
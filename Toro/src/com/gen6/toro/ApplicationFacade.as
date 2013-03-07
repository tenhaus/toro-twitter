package com.gen6.toro
{
	import com.gen6.toro.controller.FollowUserCommand;
	import com.gen6.toro.controller.GetConfigCommand;
	import com.gen6.toro.controller.GetExtendedInfoCommand;
	import com.gen6.toro.controller.GetFeatureListCommand;
	import com.gen6.toro.controller.GetFollowersCommand;
	import com.gen6.toro.controller.GetFriendCommentsCommand;
	import com.gen6.toro.controller.GetFriendsCommand;
	import com.gen6.toro.controller.GetPublicCommentsCommand;
	import com.gen6.toro.controller.GetRateLimitCommand;
	import com.gen6.toro.controller.GetRepliesCommand;
	import com.gen6.toro.controller.GetUserTimeLineCommand;
	import com.gen6.toro.controller.LoadEncryptedCredentialsCommand;
	import com.gen6.toro.controller.LoginCommand;
	import com.gen6.toro.controller.LogoutCommand;
	import com.gen6.toro.controller.SaveConfigCommand;
	import com.gen6.toro.controller.ScrapeFollowersCommand;
	import com.gen6.toro.controller.ScrapeFriendsCommand;
	import com.gen6.toro.controller.ScrapePublicTimelineCommand;
	import com.gen6.toro.controller.ScrapeRepliesCommand;
	import com.gen6.toro.controller.ScrapeUserTimelineCommand;
	import com.gen6.toro.controller.SearchCommand;
	import com.gen6.toro.controller.SendCommentCommand;
	import com.gen6.toro.controller.SendFeedBackCommand;
	import com.gen6.toro.controller.SendVoteCommand;
	import com.gen6.toro.controller.ShowNotificationCommand;
	import com.gen6.toro.controller.ShrinkUrlCommand;
	import com.gen6.toro.controller.StartupCommand;
	import com.gen6.toro.controller.UploadToTwitPicCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const STARTUP : String = "startup";
		
		public static const LOGIN  : String = "login";
   		public static const LOGOUT : String = "logout";
   		
   		public static const VALID_LOGIN : String = "valid_login";
   		public static const INVALID_LOGIN : String = "invalid_login";
   		public static const LOGIN_ERROR : String = "login_error";
   		
   		public static const GET_FRIENDS : String = "get_friends";
   		public static const GET_FRIENDS_SUCCESS : String = "get_friends_success";
   		
   		public static const GET_FOLLOWERS : String = "get_followers";
   		public static const GET_FOLLOWERS_SUCCESS : String = "get_followers_success";
   		
   		public static const GET_FRIEND_COMMENTS : String = "get_friend_comments";
   		public static const GET_FRIEND_COMMENTS_SUCCESS : String = "get_friend_comments_success";
   		
   		public static const GET_PUBLIC_COMMENTS : String = "get_public_comments";
   		public static const GET_PUBLIC_COMMENTS_SUCCESS : String = "get_public_comments_success";
   		public static const GET_PUBLIC_COMMENTS_FAILED : String = "get_public_comments_failed";
   		
   		public static const SEND_COMMENT : String = "send_comment";
   		public static const SEND_COMMENT_SUCCESS : String = "send_comment_success";
   		
   		public static const LOAD_ENCRYPTED_CREDENTIALS : String = "load_encrypted_credentials";
   		public static const LOAD_ENCRYPTED_CREDENTIALS_SUCCESS : String = "load_encrypted_credentials_success";
   		public static const LOAD_ENCRYPTED_CREDENTIALS_FAILED : String = "load_encrypted_credentials_failed";
   		
   		public static const GET_EXTENDED_INFO : String = "get_extended_info";
   		public static const GET_EXTENDED_INFO_SUCCESS : String = "get_extended_info_success";
   		
   		public static const GET_USER_TIMELINE : String = "get_user_timeline";
   		public static const GET_USER_TIMELINE_RESULT : String = "get_user_timeline_result";
   		
   		public static const GET_REPLIES : String = "get_replies";
   		public static const GET_REPLIES_SUCCESS : String  ="get_replies_success";
   		public static const GET_REPLIES_FAILED : String  ="get_replies_failed";
   		
   		public static const GET_RATE_LIMIT : String = "get_rate_limit";
   		public static const GET_RATE_LIMIT_RESULT : String = "get_rate_limit_result";
   		
   		public static const SHOW_NOTIFICATION : String = "show_notification";
   		
   		public static const SHOW_FEED_BACK_VIEW : String = "show_feed_back_view";
   		public static const SHOW_SETTINGS : String = "show_settings";
   		
   		public static const CANCEL_SETTINGS : String = "cancel_settings"; 		
   		public static const CANCEL_FEED_BACK : String = "cancel_feed_back";
   		
   		public static const SEND_FEED_BACK : String = "send_feed_back";
   		public static const SEND_FEED_BACK_SUCCESS : String = "send_feedback_success";
   		public static const SEND_FEED_BACK_FAILED : String = "send_feedback_failed";
   		
   		public static const GET_FEATURE_LIST : String = "get_feature_list";
   		public static const GET_FEATURE_LIST_SUCCEESS : String = "get_feature_list_success";
   		public static const GET_FEATURE_LIST_FAILED : String = "get_feature_list_failed";
   		
   		public static const VOTE : String = "vote";
   		public static const VOTE_SUCCESS : String = "vote_success";
   		public static const VOTE_FAILED : String = "vote_failed";
   		public static const VOTE_EXCEED_LIMIT : String = "vote_exceed_limit";    		
   		
   		public static const SHRINK_URL : String = "shrink_url";
   		public static const SHRINK_URL_SUCCESS : String = "shrink_url_success";
   		public static const SHRINK_URL_FAILED : String = "shrink_url_failed";
   		
   		public static const SEARCH : String = "search";
   		public static const SEARCH_SUCCESS : String = "search_success";
   		public static const SEARCH_FAILED : String = "search_failed";
   		
   		public static const FOLLOW_USER : String = "follow_user";
   		public static const FOLLOW_USER_SUCCESS : String = "follow_user_success";
   		public static const FOLLOW_USER_FAILED : String = "follow_user_failed";
   		
   		public static const SCRAPE_FRIENDS : String = "scrape_friends";   		
   		public static const SCRAPE_FOLLOWERS : String = "scrape_followers";   		
   		public static const SCRAPE_USER_TIMELINE : String = "scrape_user_timeline";
   		public static const SCRAPE_REPLIES : String = "scrape_replies";
   		public static const SCRAPE_PUBLIC_TIMELINE : String = "scrape_public_timeline";
   		
   		public static const GET_CONFIG : String = "get_config";
   		public static const GET_CONFIG_SUCCESS : String = "get_config_success";
   		public static const GET_CONFIG_FAILED : String = "get_config_failed";
   		
   		public static const SAVE_CONFIG : String = "save_config";
   		public static const SAVE_CONFIG_SUCCES : String = "save_config_success";
   		public static const SAVE_CONFIG_FAILED : String = "save_config_failed";
   		
   		public static const UPLOAD_TO_TWITPIC : String = "upload_to_twitpic";
   		public static const UPLOAD_TO_TWITPIC_SUCCESS : String = "upload_to_twitpic_success";
   		public static const UPLOAD_TO_TWITPIC_FAILED : String = "upload_to_twitpic_failed";
   		
   		public static function getInstance() : ApplicationFacade
		{
			if( instance == null ) instance = new ApplicationFacade();
			return( instance as ApplicationFacade );
		}
		
		override protected function initializeController() : void
		{
			super.initializeController();
			
			registerCommand( STARTUP, StartupCommand );
			registerCommand( LOGIN, LoginCommand );
			registerCommand( GET_FRIENDS, GetFriendsCommand );
			registerCommand( GET_FRIEND_COMMENTS, GetFriendCommentsCommand );
			registerCommand( GET_PUBLIC_COMMENTS, GetPublicCommentsCommand );
			registerCommand( SEND_COMMENT, SendCommentCommand );
			registerCommand( LOAD_ENCRYPTED_CREDENTIALS, LoadEncryptedCredentialsCommand );
			registerCommand( GET_EXTENDED_INFO, GetExtendedInfoCommand );
			registerCommand( SHOW_NOTIFICATION, ShowNotificationCommand );		
			registerCommand( GET_USER_TIMELINE, GetUserTimeLineCommand );
			registerCommand( GET_REPLIES, GetRepliesCommand );
			registerCommand( GET_RATE_LIMIT, GetRateLimitCommand );
			registerCommand( LOGOUT, LogoutCommand );
			registerCommand( SEND_FEED_BACK, SendFeedBackCommand );
			registerCommand( SHRINK_URL, ShrinkUrlCommand );
			registerCommand( SEARCH, SearchCommand );
			registerCommand( GET_FOLLOWERS, GetFollowersCommand );
		 	registerCommand( SCRAPE_FRIENDS, ScrapeFriendsCommand );
		 	registerCommand( SCRAPE_FOLLOWERS, ScrapeFollowersCommand );
		 	registerCommand( SCRAPE_USER_TIMELINE, ScrapeUserTimelineCommand );
		 	registerCommand( SCRAPE_REPLIES, ScrapeRepliesCommand );
		 	registerCommand( SCRAPE_PUBLIC_TIMELINE, ScrapePublicTimelineCommand );
		 	registerCommand( FOLLOW_USER, FollowUserCommand );
		 	registerCommand( GET_FEATURE_LIST, GetFeatureListCommand );
		 	registerCommand( VOTE, SendVoteCommand );
		 	registerCommand( GET_CONFIG, GetConfigCommand );
		 	registerCommand( SAVE_CONFIG, SaveConfigCommand );
		 	registerCommand( UPLOAD_TO_TWITPIC, UploadToTwitPicCommand );
		} 
		
		public function startup( app : Toro ) : void
		{
			sendNotification( STARTUP, app );
		}
	}
}
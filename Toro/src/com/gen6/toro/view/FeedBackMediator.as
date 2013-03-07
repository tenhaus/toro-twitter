package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.FeatureListVO;
	import com.gen6.toro.view.components.FeedBackView;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class FeedBackMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "FeedBackMediator";
		 
		public function FeedBackMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			
			feedBackView.addEventListener( FeedBackView.CANCEL, handleCancelFeedBack );
			feedBackView.addEventListener( FeedBackView.SEND_FEEDBACK, handleSendFeedBack );
			feedBackView.addEventListener( FeedBackView.FETCH_FEATURE_LIST, handleUserRequestFeatureList );
			feedBackView.addEventListener( FeedBackView.VOTE, handleUserRequestsVote );
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.SEND_FEED_BACK_SUCCESS,
					ApplicationFacade.SEND_FEED_BACK_FAILED,
					ApplicationFacade.GET_FEATURE_LIST_SUCCEESS,
					ApplicationFacade.GET_FEATURE_LIST_FAILED,
					ApplicationFacade.VOTE_SUCCESS,
					ApplicationFacade.VOTE_FAILED,
					ApplicationFacade.VOTE_EXCEED_LIMIT
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.SEND_FEED_BACK_SUCCESS :
					feedBackView.setFeedBackSuccess();
					break;
					
				case ApplicationFacade.SEND_FEED_BACK_FAILED :
					feedBackView.setFeedBackFailed();
					break;
				
				case ApplicationFacade.GET_FEATURE_LIST_SUCCEESS :
					feedBackView.tasks = notification.getBody() as FeatureListVO; 
					break;
				
				case ApplicationFacade.GET_FEATURE_LIST_FAILED : 
					feedBackView.displayFetchTasksFailed();
					break;
				
				case ApplicationFacade.VOTE_SUCCESS :					
					sendNotification( ApplicationFacade.GET_FEATURE_LIST );
					feedBackView.displayVoteSuccess();					
					break;
				
				case ApplicationFacade.VOTE_FAILED :
					feedBackView.displayVoteFailed();
					sendNotification( ApplicationFacade.GET_FEATURE_LIST );
					break;
				
				case ApplicationFacade.VOTE_EXCEED_LIMIT :
					feedBackView.displayVoteExceedLimit(); 
					sendNotification( ApplicationFacade.GET_FEATURE_LIST );
					break;
						
				default :
					break;
			}
		}
		
		private function get feedBackView() : FeedBackView
		{
			return( viewComponent as FeedBackView );
		}
		
		private function handleCancelFeedBack( event : Event ) : void
		{			
			sendNotification( ApplicationFacade.CANCEL_FEED_BACK );
		}
		
		private function handleSendFeedBack( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SEND_FEED_BACK, feedBackView.ta_comment.text );			
		}
		
		private function handleUserRequestFeatureList( event : Event ) : void
		{
			sendNotification( ApplicationFacade.GET_FEATURE_LIST );
		}
		
		private function handleUserRequestsVote( event : Event ) : void
		{
			var item : Object = feedBackView.dg_tasks.selectedItem;
			sendNotification( ApplicationFacade.VOTE, item );			
		}
	}
}
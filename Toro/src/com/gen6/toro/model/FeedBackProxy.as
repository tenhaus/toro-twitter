package com.gen6.toro.model
{
	import com.adobe.utils.XMLUtil;
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.FeatureListVO;
	import com.gen6.toro.entity.FeatureVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FeedBackProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "FeedBackProxy";
		
		public function FeedBackProxy( data : Object = null )
		{
			super( NAME, data );
		}
		
		public function sendFeedBack( text : String, username : String ) : void
		{			
			var request : URLRequest = new URLRequest( "http://www.gen-6.com/toro/post.php" );
			request.method = URLRequestMethod.POST;
			
			var loader : URLLoader = new URLLoader();
			
			var variables : URLVariables = new URLVariables();
			variables.comment = text;
			variables.username = username;
			
			request.data = variables;
			
			loader.addEventListener( Event.COMPLETE, handleSendFeedBackComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, handleSendFeedBackFailed );
			loader.load( request );
		}
		
		private function handleSendFeedBackComplete( event : Event ) : void
		{
			var loader : URLLoader = event.target as URLLoader;
			sendNotification( ApplicationFacade.SEND_FEED_BACK_SUCCESS );
			
		}
		
		private function handleSendFeedBackFailed( event : IOErrorEvent ) : void
		{
			sendNotification( ApplicationFacade.SEND_FEED_BACK_FAILED );
		}
		
		public function getFeatureList( username : String ) : void
		{
			var request : URLRequest = new URLRequest( "http://www.gen-6.com/toro/vote/fetch.php?u=" + username );
			request.method = URLRequestMethod.POST;
			
			var loader : URLLoader = new URLLoader();
			
			var variables : URLVariables = new URLVariables();			
			variables.username = username;
			
			request.data = variables;
			
			loader.addEventListener( Event.COMPLETE, handleGetFeatureListComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, handleGetFeatureListFailed );
			loader.load( request );						
		}
		
		private function handleGetFeatureListComplete( event : Event ) : void
		{
			if( XMLUtil.isValidXML( event.target.data ) )
			{
				var tasks : ArrayCollection = new ArrayCollection();
				var result : XML = XML( event.target.data );
				
				var featureList : FeatureListVO = new FeatureListVO();
				featureList.votesLeft = parseInt( result.@votesleft );
				
				for each( var task : XML in result.task )
				{
					var feature : FeatureVO = new FeatureVO();
					
					feature.id = parseInt( task.id );
					feature.title = task.title;
					feature.description = task.description;
					feature.votes = parseInt( task.votes );
					feature.status = parseInt( task.status );
					
					feature.htmlText = "<p><b>" + feature.title + "</b></p><p>"+feature.description+"</p>"
					
					featureList.list.addItem( feature );
				}
				
				sendNotification( ApplicationFacade.GET_FEATURE_LIST_SUCCEESS, featureList );
			}
			else
			{
				sendNotification( ApplicationFacade.GET_FEATURE_LIST_FAILED );
			}		
		}
		
		private function handleGetFeatureListFailed( event : IOErrorEvent ) : void
		{
			sendNotification( ApplicationFacade.GET_FEATURE_LIST_FAILED );			
		}	
		
		public function sendVote( username : String, feature : FeatureVO ) : void
		{
			var request : URLRequest = new URLRequest( "http://www.gen-6.com/toro/vote/vote.php?u=" + username );
			request.method = URLRequestMethod.POST;
			
			var loader : URLLoader = new URLLoader();
			
			var variables : URLVariables = new URLVariables();
			variables.username = username;
			variables.task = feature.id;
			
			request.data = variables;
			
			loader.addEventListener( Event.COMPLETE, handleVoteSuccess );
			loader.addEventListener( IOErrorEvent.IO_ERROR, handleVoteFailed );
			loader.load( request );		
		}
		
		private function handleVoteSuccess( event : Event ) : void
		{
			if( event.target.data == "success" )
			{
				sendNotification( ApplicationFacade.VOTE_SUCCESS );
				return;				
			}
			
			if( event.target.data == "over_limit" )
			{
				sendNotification( ApplicationFacade.VOTE_EXCEED_LIMIT );
			}
		}
		
		private function handleVoteFailed( event : IOErrorEvent ) : void
		{
			sendNotification( ApplicationFacade.VOTE_FAILED );			
		}
	}
}
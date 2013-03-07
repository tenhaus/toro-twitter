package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.view.components.SearchView;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SearchMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "SearchMediator";		
		 
		public function SearchMediator( viewComponent : Object )
		{
			super( NAME, viewComponent );
			searchView.addEventListener( SearchView.EVENT_SEARCH, handleSearchRequest );
		}		
		
		override public function listNotificationInterests() : Array
		{
			return( [					
					ApplicationFacade.LOGOUT,
					ApplicationFacade.SEARCH_SUCCESS
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.LOGOUT :
					searchView.searchResults = null;
					break;
				case ApplicationFacade.SEARCH_SUCCESS :
					searchView.searchResults = notification.getBody() as ArrayCollection;
					break;
				default :
					break;
			}
		}
		
		private function get searchView() : SearchView
		{
			return( viewComponent as SearchView );
		}
		
		private function handleSearchRequest( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SEARCH, searchView.t_query.text );
		}
	}
}
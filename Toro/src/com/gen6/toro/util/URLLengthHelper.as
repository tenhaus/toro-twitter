package com.gen6.toro.util
{
	import com.gen6.toro.events.ShrinkUrlEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class URLLengthHelper extends EventDispatcher
	{
		public static const URL_TINY_URL : String = "http://tinyurl.com/api-create.php?url=REPLACE";
		public static const URL_HEX_IO : String = "http://hex.io/api-create.php?url=REPLACE";
		public static const URL_BIT_LY : String = "http://bit.ly/api?url=REPLACE";
		public static const URL_SNIP_URL : String = "http://snipr.com/site/snip?r=simple&link=REPLACE";
		public static const URL_IS_GD : String = "http://is.gd/api.php?longurl=REPLACE";
		public static const URL_LIN_CR : String = "http://lin.cr/?l=REPLACE&mode=api&full=1"
		public static const URL_SRNK : String = "http://srnk.net/create.php?url=REPLACE";
		
		public static const EVENT_SHRINK_SUCCESS : String = "shrink_success";
		public static const EVENT_SHRINK_FAILED : String = "shrink_failed";
		
		private var _shrinkUrlLoader : URLLoader = new URLLoader();
		
		function URLLengthHelper()
		{
			_shrinkUrlLoader.addEventListener( Event.COMPLETE, handleUrlResult );
			_shrinkUrlLoader.addEventListener( IOErrorEvent.IO_ERROR, handleUrlFailed );
		}
		
		public function replaceUrl( url : String, provider : String ) : void
		{
			var request : URLRequest;
					
			switch( provider )
			{
				case "tinyurl" :
					request = new URLRequest( URL_TINY_URL.replace("REPLACE",url) );
					break;
				case "lin.cr" :
					request = new URLRequest( URL_LIN_CR.replace("REPLACE",url) );
					break;
				case "is.gd" :
					request = new URLRequest( URL_IS_GD.replace("REPLACE",url) );
					break;
				case "snipurl" :
					request = new URLRequest( URL_SNIP_URL.replace("REPLACE",url) );
					break;
				case "hex.io" :
					request = new URLRequest( URL_HEX_IO.replace("REPLACE",url) );
					break;
				case "bit.ly" :
					request = new URLRequest( URL_BIT_LY.replace("REPLACE",url) );
					break;
				case "srnk.net" :
					request = new URLRequest( URL_SRNK.replace("REPLACE",url) );
				default :
					trace( "bad shorten url provider" );
					break;
			}
			
			_shrinkUrlLoader.load( request );
		}
		
		private function handleUrlResult( event : Event ) : void
		{
			dispatchEvent( new ShrinkUrlEvent( EVENT_SHRINK_SUCCESS, _shrinkUrlLoader.data as String ) );			
		}
		
		private function handleUrlFailed( event : IOErrorEvent ) : void
		{
			dispatchEvent( new Event( EVENT_SHRINK_SUCCESS ) );
		}
	}
}
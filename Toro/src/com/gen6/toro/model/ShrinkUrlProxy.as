package com.gen6.toro.model
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.ShrinkUrlVO;
	import com.gen6.toro.events.ShrinkUrlEvent;
	import com.gen6.toro.util.URLLengthHelper;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ShrinkUrlProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "ShrinkUrlProxy";
		
		private var _urlHelper : URLLengthHelper;
		
		public function ShrinkUrlProxy( data : Object = null )
		{
			super( NAME, data );			
			_urlHelper = new URLLengthHelper();
			_urlHelper.addEventListener( URLLengthHelper.EVENT_SHRINK_SUCCESS, handleShrinkSuccess, false, 0, true );
			_urlHelper.addEventListener( URLLengthHelper.EVENT_SHRINK_FAILED, handleShrinkFailed, false, 0, true );			
		}
		
		public function shrinkURL( value : ShrinkUrlVO ) : void
		{
			_urlHelper.replaceUrl( value.longUrl, value.provider );
		}
		
		private function handleShrinkSuccess( event : ShrinkUrlEvent ) : void
		{
			sendNotification( ApplicationFacade.SHRINK_URL_SUCCESS, event.url );			
		}
		
		private function handleShrinkFailed( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SHRINK_URL_FAILED );			
		}
	}
}
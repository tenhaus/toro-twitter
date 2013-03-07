package com.gen6.toro.events
{
	import com.gen6.toro.entity.ShrinkUrlVO;
	
	import flash.events.Event;
	
	public class ShrinkUrlEvent extends Event
	{
		public var url : String;
		
		public function ShrinkUrlEvent( name : String, url : String )
		{
			super( name );
			this.url = url;
		}
	}
}
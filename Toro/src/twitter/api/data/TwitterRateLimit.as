package twitter.api.data
{
	public class TwitterRateLimit
	{
		public var remaining : Number;
		public var limit : Number;
		public var resetTimeInSeconds : Number;
		public var resetTime : Date;
		
		public function TwitterRateLimit( xml : XML )
		{
			remaining = parseInt( xml.child("remaining-hits") );
			limit = parseInt( xml.child("hourly-limit") );			
			resetTimeInSeconds = parseInt( xml.child("reset-time-in-seconds") );
			
			var resetTimeString : String = xml.child( "reset-time" );			
			var d : Date = makeDate( resetTimeString );
			resetTime = d;		 
		}
		
		private function makeDate( created_at:String ):Date
		{	
			var dateString:String = created_at.substr(0,10);			
			var timeString:String = created_at.substr(11,8);
			
			
			dateString = dateString.replace( "-", "/" );
			dateString = dateString.replace( "-", "/" );
			
			var d : Date = new Date(dateString + " " + timeString);
			
			var offset : Number = d.getTimezoneOffset() * 60 * 1000;
			d.setTime( d.getTime() - offset );
			
			return( d );
		}
	}
}
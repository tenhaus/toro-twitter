package com.gen6.toro.util
{
	import mx.utils.ObjectUtil;
	
	import twitter.api.data.TwitterStatus;
	import twitter.api.data.TwitterUser;
	
	public class ToroUtil
	{
		public static const REGEX_REMOVE_BREAKS : RegExp = new RegExp( "[\n\r]","g" );
		public static const REGEX_REMOVE_SPACE  : RegExp = new RegExp( "[ \t]+", "g" );
		
		public static function htmlFormatComment( status : Object, user : TwitterUser = null ) : String
		{						
			var comment : String = status.text;
			
			// strip out new lines
			comment = comment.replace(new RegExp("[\n\r]","g")," ");			
			
			var protocol:String = "((?:http|ftp|https)://)";
			var urlPart:String = "([a-z0-9_-]+\.[a-z0-9_-]+)";
			//var optionalUrlPart:String = "(\.[a-z0-9_-\/]*)";
			var optionalUrlPart:String = "([^ ]*)";
			
			var urlPattern:RegExp = new RegExp( protocol + urlPart + optionalUrlPart, "ig" );
			comment = comment.replace( urlPattern, "<a href='event:$1$2$3'><u>$1$2$3</u></a>" );
			
			
			if( user != null )
			{
				comment = "<font color='#018ee8' face='Verdana' size='12'><b>" + user.screenName + "</b></font><font color='#1a1a1a' face='Verdana' size='12'> " + comment + "</font>";
				//trace( comment );
			}
			else
			{
				comment = "<font color='#1a1a1a' face='Verdana'>" + comment + "</font>";				
			}
			
			return( comment );
		}
		
		public static function htmlFormatCommentVO( status : TwitterStatus ) : String
		{
			var comment : String = status.text;
			
			// strip out new lines
			comment = comment.replace(new RegExp("[\n\r]","g")," ");			
			
			//var protocol:String = "((?:http|ftp|https)://)";
			//var urlPart:String = "([a-z0-9_-]+\.[a-z0-9_-]+)";
			//var optionalUrlPart:String = "(\.[a-z0-9_-\/]*)";
			//var optionalUrlPart:String = "([^ ]*)";
			
			//var urlPattern:RegExp = new RegExp( protocol + urlPart + optionalUrlPart, "ig" );
			//comment = comment.replace( urlPattern, "<a href='event:$1$2$3'><u>$1$2$3</u></a>" );
			
			comment = comment.replace( new RegExp( "(<a.*?<\/a>)", "g" ), "<u>$1</u>" );
			comment = comment.replace( new RegExp( "@<u><a href=\"(.*?)\"", "g" ), "@<u><a href=\"http://www.twitter.com$1\"" );
			
			if( status.user != null )
			{				
				comment = "<p><font color=\'#000000\' face=\'Verdana\' size=\'12\'><b><a href='http://www.twitter.com/" + status.user.screenName + "'>" + status.user.screenName + "</a></font></b><font color=\'#1a1a1a\' face=\'Verdana\' size=\'12\'> " + comment + "</font></p>";
				//trace( comment );
			}
			else
			{
				comment = "<p><font color=\'#1a1a1a\' face=\'Verdana\' size=\'12\'>" + comment + "</font></p>";				
			}
			
			//trace( "result is " + comment );
			return( comment );						
		}
		
		public static function createDateFromTString( value : String ) : Date
		{		
			var dateString:String = value.substr(0,10);			
			var timeString:String = value.substr(11,8);			
			
			dateString = dateString.replace( "-", "/" );
			dateString = dateString.replace( "-", "/" );
			
			var d : Date = new Date(dateString + " " + timeString);
			
			var offset : Number = d.getTimezoneOffset() * 60 * 1000;
			d.setTime( d.getTime() - offset );
			
			return( d );		
		}
		
		public static function cleanTwitterStatus( text : String ) : String
		{
			var textWithoutBreaks : String = text.replace( REGEX_REMOVE_BREAKS, "" );
			var textWithoutSpaces : String = textWithoutBreaks.replace( REGEX_REMOVE_SPACE, " " );
			
			return( textWithoutSpaces );
		}
		
		public static function validRegexMatch( value : Array ) : Boolean
		{			
			if( value != null )
			{
				if( value.length > 1 )
				{
					return( true );
				}
			}
			
			return( false );
		}
		
		public static function parseBool( value : Number ) : Boolean
		{
			if( value == 1 ) return true;
			else return false;
		}
	}
}
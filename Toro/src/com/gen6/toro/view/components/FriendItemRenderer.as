package com.gen6.toro.view.components
{
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Image;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListData;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.StringUtil;
	
	import qs.controls.SuperImage;
	
	import twitter.api.data.TwitterUser;
	
	public class FriendItemRenderer extends UIComponent implements IListItemRenderer
	{
		public static const REPLY_TO_USER : String = "reply_to_user";
		
		[Bindable]
		private var _friend : TwitterUser;
		
		private var _image : Image;
		
		private var _nameLocation : TextField;		
		private var _infoText : TextField;
		
		public function FriendItemRenderer() : void
		{
			super();			
		}
		
		private function handleLink( event : TextEvent ) : void
		{
			//_text.setSelection( 0, 0 );
			
			var request : URLRequest = new URLRequest( event.text );
			navigateToURL( request );
		}
		 
		public function set data(value:Object):void
		{
			_friend = value as TwitterUser;
			
			invalidateProperties();			
			
			dispatchEvent( new FlexEvent(FlexEvent.DATA_CHANGE) );			
		}
		
		public function get data() : Object
		{
			return( _friend );
		}
		
		/*
		[Bindable("dataChange")]
		public function get listData() : BaseListData 
		{
			return( _listData );
		}
		
		public function set listData( value : BaseListData ) : void
		{			
			_listData = ListData( value );
			invalidateProperties();
		}
		*/
		
		override protected function createChildren() : void
		{
			if( _image == null )
			{
				_image = new Image();
				_image.width = 48;
				_image.height = 48;
				_image.setStyle( "borderStyle", "none" );
				addChild( _image );
			}
			
			if( _nameLocation == null )
			{
				_nameLocation = new TextField();
				_nameLocation.wordWrap = true;
				_nameLocation.autoSize = TextFieldAutoSize.LEFT;				

				addChild( _nameLocation );
			}
			
			if( _infoText == null )
			{
				_infoText = new TextField();
				_infoText.wordWrap = true;
				_infoText.autoSize = TextFieldAutoSize.LEFT;
				addChild( _infoText );
			}
		}

		override protected function commitProperties() : void
		{
			super.commitProperties();
			
			if( _friend )
			{
				_nameLocation.htmlText = "";
				_infoText.htmlText = "";
				
				if( StringUtil.trim(_friend.name) == "" )
				{
					_nameLocation.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\"><u><b>" + _friend.screenName + "</b>";
				}
				else
				{
					_nameLocation.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\"><u><b>" + _friend.screenName + "</b> - <i>" + _friend.name + "</i></u></font>";
				}
								
				_image.source  = _friend.profileImageUrl;
				
				if( StringUtil.trim(_friend.description) == "" )
				{
					_infoText.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\">" + "no description" + "</font>";					
				}
				else
				{
					_infoText.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\">" + _friend.description + "</font>";					
				}
				
				_nameLocation.width = explicitWidth - _image.width - 5 - 5 - 3;
				_infoText.width = explicitWidth - _image.width - 5 - 5 - 8;
				//_infoText.width = _infoText.textWidth;
			}
			
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredWidth = explicitWidth;			
            measuredHeight = Math.max( _image.height + 10 + 6, _nameLocation.textHeight + _infoText.textHeight + 10 + 2 + 6);
		}
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ) : void
		{			
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			_image.move( 8, 8 );
			_nameLocation.x = _image.width + 5 + 5 + 3;
			_nameLocation.y = 2 + 3;
			
			_infoText.x = _nameLocation.x;
			_infoText.y = _nameLocation.y + _nameLocation.textHeight + 2;
			
			graphics.clear();
			
			graphics.lineStyle( 1, 0x9d9d9d, 1 );
			
			graphics.moveTo( 2, 2 );			
			graphics.lineTo( measuredWidth-2, 2 );
			graphics.lineTo( measuredWidth-2, measuredHeight -2);
			graphics.lineTo( 2, measuredHeight-2 );
			graphics.lineTo( 2, 2 );
			
			graphics.lineStyle( 1, 0xefefef, 1 );
			
			graphics.moveTo( 1, 1 );			
			graphics.lineTo( measuredWidth-1, 1 );
			graphics.lineTo( measuredWidth-1, measuredHeight -1);
			graphics.lineTo( 1, measuredHeight-1 );
			graphics.lineTo( 1, 1 );
			
			graphics.lineStyle( 1, 0xf5f5f5, 1 );
			
			graphics.moveTo( 0, 0 );			
			graphics.lineTo( measuredWidth-0, 0 );
			graphics.lineTo( measuredWidth-0, measuredHeight -0);
			graphics.lineTo( 0, measuredHeight-0 );
			graphics.lineTo( 0, 0 );
		}
	}
}
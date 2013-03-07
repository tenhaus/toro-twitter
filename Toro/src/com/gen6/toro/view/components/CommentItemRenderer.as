package com.gen6.toro.view.components
{
	import com.gen6.toro.events.FriendSelectedEvent;
	import com.gen6.toro.events.RetweetEvent;
	import com.gen6.toro.util.ToroUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import twitter.api.data.TwitterStatus;
	import twitter.api.data.TwitterUser;
	
	public class CommentItemRenderer extends UIComponent implements IListItemRenderer, IDropInListItemRenderer
	{
		private static const HEIGHT_OPTIONS : Number = 20;
		
		public static const REPLY_TO_USER : String = "reply_to_user";
		public static const RETWEET : String = "retweet";
		
		private var _isFriend : Boolean;
		
		private var _twitterStatus : TwitterStatus;
		private var _twitterUser : TwitterUser;
		
		// status
		private var _text : TextField;
		private var _statusOptions : String = "<font color=\"#fafafa\" size=\"14\"><a href='event:test'>retweet</a> | <a href='event:test'>reply</a></font>";
		
		// friend
		private var _nameLocation : TextField;
		
		// both
		private var _options : TextField;
		private var _image : Image;
		private var _infoText : TextField;		
		private var _replyButton : Button;
		private var _retweetButton : Button;
		private var _directmessageButton : Button;	

		private var _df : DateFormatter = new DateFormatter();
		private var _listData : BaseListData;		
		private var _mouseOver : Boolean = true;
		private var _mouseUp : Boolean = true;
		
		public function CommentItemRenderer() : void
		{
			super();
			_df.formatString = "EEEE, MMM. D, YYYY at L:NN A";
			this.addEventListener(MouseEvent.MOUSE_DOWN,setMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP,setMouseUp);
			//this.addEventListener(MouseEvent.CLICK,setMouseDown);
			this.addEventListener(DragEvent.DRAG_START,setMouseDown);
			this.addEventListener(DragEvent.DRAG_EXIT,setMouseUp);
		}
		
		private function setMouseDown(e:Event):void
		{
			_mouseUp = false;
			showButtons();
		}
		
		private function setMouseUp(e:Event):void
		{
			_mouseUp = true;
		}
		
		public function showButtons():void
		{
			if( _twitterStatus )
			{
				_replyButton.visible = true;
				_retweetButton.visible = true;
				//_directmessageButton = true;
			}
		}
		
		public function hideButtons():void
		{
			if( _twitterStatus )
			{
				if(_mouseUp)
				{
					_replyButton.visible = false;
					_retweetButton.visible = false;
					//_directmessageButton = false;
				}
			}
		}
		

		private function handleLink( event : TextEvent ) : void
		{	
			var request : URLRequest = new URLRequest( event.text );
			navigateToURL( request );
		}
		
		private function handleReplyClick( event : MouseEvent ) : void
		{
			var friendEvent : FriendSelectedEvent = new FriendSelectedEvent( REPLY_TO_USER, _twitterStatus.user, _twitterStatus );
			dispatchEvent( friendEvent );
			//_twitterStatus.showingOptions = !_twitterStatus.showingOptions;
			//invalidateSize();
			//invalidateDisplayList();			
		}
		
		private function handleRetweetClick( event : MouseEvent ) : void
		{
			var retweetEvent : RetweetEvent = new RetweetEvent ( RETWEET, _text.text, _twitterStatus.user, _twitterStatus );
			dispatchEvent ( retweetEvent );
		}
		 
		public function set listData( value : BaseListData ) : void
		{
			_listData = value;
			/*
			if( _listData != null )
			{
				_listData.owner.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
				_listData.owner.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			}
			*/			
		}
		
		public function get listData() : BaseListData
		{
			return( _listData );						
		}
		
		public function set data( value : Object ) : void
		{			
			if( value )
			{
				_isFriend = false;
				
				_twitterStatus = null;
				_twitterUser   = null;
				
				if( value is TwitterStatus )
				{	
					_twitterStatus = value as TwitterStatus;					
				}
				
				if( value is TwitterUser )
				{
					_isFriend = true;
					_twitterUser = value as TwitterUser;					
				}
							
				invalidateProperties();
				invalidateSize();
				dispatchEvent( new FlexEvent(FlexEvent.DATA_CHANGE) );
			}
		}
		
		public function get data() : Object
		{			
			if( _isFriend ) { return _twitterUser }
			else return _twitterStatus;					
		}
		
		private function handleImageClick( event : MouseEvent ) : void
		{
			if( _twitterStatus )
			{
				
				if( _twitterStatus.user )
				{
					navigateToURL( new URLRequest("http://www.twitter.com/" + _twitterStatus.user.screenName) );
					return;
				}
			}	
			
			if( _twitterUser )
			{
				navigateToURL( new URLRequest("http://www.twitter.com/" + _twitterUser.screenName) );
			}
		}
		
		override protected function createChildren():void
		{
			if( _image == null )
			{
				_image = new Image();
				_image.width = 48;
				_image.height = 48;
				_image.useHandCursor = true;
				
				_image.addEventListener( MouseEvent.CLICK, handleImageClick );

				addChild( _image );
			}
			
			if( _text == null )
			{
				_text = new TextField();
				
				_text.wordWrap = true;
				_text.multiline = true;
				_text.autoSize = TextFieldAutoSize.LEFT;
				_text.selectable = true;
				
				_text.addEventListener( TextEvent.LINK, handleLink, false, 0, true ); 

				addChild( _text );
			}
			
			if( _replyButton == null )
			{
				_replyButton = new Button();
				
				_replyButton.width = 16;
				_replyButton.height = 16;				
				_replyButton.styleName = "replyButton";
				_replyButton.toolTip = "Reply";
				
				_replyButton.addEventListener( MouseEvent.CLICK, handleReplyClick );
				
				addChild( _replyButton );				
			}
			//Pete start
			if( _retweetButton == null )
			{
				_retweetButton = new Button();
				
				_retweetButton.width = 16;
				_retweetButton.height = 16;				
				_retweetButton.styleName = "retweetButton";
				_retweetButton.toolTip = "Retweet";
				
				_retweetButton.addEventListener( MouseEvent.CLICK, handleRetweetClick );
				
				addChild( _retweetButton );				
			}
			
			if( _directmessageButton == null )
			{
				_directmessageButton = new Button();
				
				_directmessageButton.width = 16;
				_directmessageButton.height = 16;				
				_directmessageButton.styleName = "directmessageButton";
				_directmessageButton.toolTip = "Direct Message";
				
				_directmessageButton.addEventListener( MouseEvent.CLICK, handleReplyClick );
				
				addChild( _directmessageButton );				
			}
			
			//Pete end
			
			if( _options == null )
			{
				_options = new TextField();
				_options.selectable = true;
				_options.autoSize = TextFieldAutoSize.LEFT;
				
				addChild( _options );				
			}
			
			if( _infoText == null )
			{
				_infoText = new TextField();		
				_infoText.selectable = true;		
				_infoText.autoSize = TextFieldAutoSize.LEFT;
				addChild( _infoText );
			}
			
			if( _nameLocation == null )
			{
				_nameLocation = new TextField();
				_nameLocation.selectable = true;
				_nameLocation.wordWrap = true;
				_nameLocation.autoSize = TextFieldAutoSize.LEFT;				

				addChild( _nameLocation );
			}
			
			_replyButton.visible = false;
			_retweetButton.visible = false;
			_directmessageButton.visible = false;
		}

		override protected function commitProperties() : void
		{
			super.commitProperties();
			_infoText.visible = true;
			
			if( _twitterStatus )
			{
				_infoText.wordWrap = false;
				
				_text.htmlText = "";
				_text.htmlText = ToroUtil.htmlFormatCommentVO( _twitterStatus );
				_text.width = explicitWidth - _image.width - 5 - 8 - 3;
				
				_image.source  = _twitterStatus.user.profileImageUrl;				
				
				if( _twitterStatus.createdAt )
				{					
					if( _twitterStatus.source )
					{
						_infoText.htmlText = "<font color=\"#666666\" size=\"12\">" + _twitterStatus.createdAt + " from " + _twitterStatus.source + "</font>";						
						//_infoText.htmlText = "<font color=\"#666666\" size=\"12\">" + _df.format( _twitterStatus.createdAt ) + " from " + _twitterStatus.source + "</font>";
					}
					else
					{
						_infoText.htmlText = "<font color=\"#666666\" size=\"12\">" + _twitterStatus.createdAt + "</font>";						
						//_infoText.htmlText = "<font color=\"#666666\" size=\"12\">" + _df.format( _twitterStatus.createdAt ) + "</font>";
					}					
										
				}
				else
				{
					_infoText.visible = false;
				}
				
				if( _twitterStatus.showingOptions )
				{
					_options.htmlText = _statusOptions;
					_options.width = measuredWidth;					
				}
				else
				{
					_options.htmlText = "";
				}
			}
			
			if( _twitterUser )
			{
				_infoText.wordWrap = true;
				
				_nameLocation.htmlText = "";
				_infoText.htmlText = "";
				
				if( StringUtil.trim(_twitterUser.name) == "" )
				{
					_nameLocation.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\"><u><b><a href='http://www.twitter.com/" + _twitterUser.screenName + "'>" + _twitterUser.screenName + "</a></b>";
				}
				else
				{
					_nameLocation.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\"><u><a href='http://www.twitter.com/" + _twitterUser.screenName + "'><b>" + _twitterUser.screenName + "</b><i> - " + _twitterUser.name + "</i></a></u></font>";
				}
								
				_image.source  = _twitterUser.profileImageUrl;
				
				if( StringUtil.trim(_twitterUser.description) == "" )
				{
					_infoText.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\">" + "no description" + "</font>";					
				}
				else
				{
					_infoText.htmlText = "<font color=\"#1a1a1a\" size=\"12\" face=\"Verdana\">" + _twitterUser.description + "</font>";					
				}
				
				_nameLocation.width = explicitWidth - _image.width - 5 - 5 - 3;
				_infoText.width = explicitWidth - _image.width - 5 - 5 - 8;
			}			
		}
		
		override protected function measure():void
		{
			super.measure();
			
			if( _twitterStatus )
			{
				measuredWidth = explicitWidth;
	            measuredHeight = Math.max( _image.height, _text.textHeight );
	            measuredHeight += 4 + Math.max( _replyButton.height, _infoText.textHeight ) + 4 + 6;
	            
	            if( _twitterStatus.showingOptions )
	            {
	            	_options.visible = true;
	            	
	            	measuredHeight += HEIGHT_OPTIONS;
	            	_options.x = 5;
	            	_options.y = measuredHeight - HEIGHT_OPTIONS;
	            }
	            else
	            {
	            	_options.visible = false;	            	
	            }
	  		}
	  		
	  		if( _twitterUser )
	  		{
	  			measuredWidth = explicitWidth;
            	measuredHeight += 4 + Math.max( _image.height + 10 + 6, _nameLocation.textHeight + _infoText.textHeight + 10 + 4 + 6);
	  		}
		}
		
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ) : void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if( _twitterStatus )
			{
				_nameLocation.visible = false;
				_text.visible = true;
				hideButtons();
				
				//_image.move( 5, 8 );
				_image.x = 5;
				_image.y = 5;
				
				_text.x = _image.width + 5 + 5 + 3;
				_text.y = 2 + 3;
				
				if( _twitterStatus.showingOptions )
				{
					_replyButton.move( measuredWidth - _replyButton.width - 5 - 3, measuredHeight - _replyButton.height - 2 - 3 - HEIGHT_OPTIONS );
					_retweetButton.move( measuredWidth - _retweetButton.width -17 - 5 - 3, measuredHeight - _retweetButton.height - 2 - 3 - HEIGHT_OPTIONS );
					_directmessageButton.move( measuredWidth - _retweetButton.width - _directmessageButton.width -19 - 5 - 3, measuredHeight - _directmessageButton.height - 2 - 3 - HEIGHT_OPTIONS );
								//pete added _retweetbuttonwidth and _direcmessagebuttonwidth
					_infoText.x = measuredWidth - _infoText.textWidth - _replyButton.width - _retweetButton.width - 13 - 3;
					_infoText.y = measuredHeight - _infoText.textHeight - 2 - 2 - 3 - HEIGHT_OPTIONS;												
				}
				else
				{
					_replyButton.move( measuredWidth - _replyButton.width - 5 - 3, measuredHeight - _replyButton.height - 2 - 3 );
					_retweetButton.move( measuredWidth - _retweetButton.width - 17 - 5 - 3, measuredHeight - _retweetButton.height - 2 - 3 );
					_directmessageButton.move( measuredWidth - _retweetButton.width - _directmessageButton.width - 19 - 5 - 3, measuredHeight - _directmessageButton.height - 2 - 3 );
							//pete and again	
					_infoText.x = measuredWidth - _infoText.textWidth - _replyButton.width - _retweetButton.width -_directmessageButton.width - 15 - 3;
					_infoText.y = measuredHeight - _infoText.textHeight - 2 - 2 - 3;
				}
				
			}
			
			if( _twitterUser )
			{	
				_nameLocation.visible = true;
				_text.visible = false;			
				_replyButton.visible = false;				
				
				_image.move( 8, 8 );
				_nameLocation.x = _image.width + 5 + 5 + 3;
				_nameLocation.y = 2 + 3;
				
				_infoText.x = _nameLocation.x;
				_infoText.y = _nameLocation.y + _nameLocation.textHeight + 2;
			}
			
			// draw border
			graphics.clear();
			
			if( _twitterStatus )
			{
				if( _twitterStatus.showingOptions )
				{
					//graphics.beginGradientFill( GradientType.LINEAR, [0x00ff00,0xff00ff], [1,1], [1,1] );
					
					graphics.beginFill( 0x666666, 1 );
					graphics.drawRect( 0, measuredHeight - HEIGHT_OPTIONS, measuredWidth, HEIGHT_OPTIONS );
					graphics.endFill();
					
					/*
					graphics.lineStyle( 2, 0x9d9d9d, 1 );
					graphics.moveTo( 3, measuredHeight - HEIGHT_OPTIONS );
					graphics.lineTo( measuredWidth - 3, measuredHeight - HEIGHT_OPTIONS );
					*/			
				}
			}
			
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
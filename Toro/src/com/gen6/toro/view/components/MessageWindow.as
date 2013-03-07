package com.gen6.toro.view.components
{
	import com.gen6.toro.util.NotificationDisplayManager;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * A lightweight window to display the message.
	 */
	public class MessageWindow extends NativeWindow
	{
		public var timeToLive:uint;
		private static const stockWidth:int = 250;
		private var manager:NotificationDisplayManager;
		private const format:TextFormat = new TextFormat( "arial", 14, 0xfafafa );
					
		public function MessageWindow(message:String, manager:NotificationDisplayManager):void
		{
			this.manager = manager;
			
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			options.type = NativeWindowType.LIGHTWEIGHT;
			options.systemChrome = NativeWindowSystemChrome.NONE;
			options.transparent = true;
			super(options);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onClick);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			manager.addEventListener(NotificationDisplayManager.LIFE_TICK,lifeTick,false,0,true);
			width = MessageWindow.stockWidth;
			
			var textDisplay:TextField = new TextField();
			
			textDisplay.htmlText = message;
			textDisplay.wordWrap = true;
			textDisplay.setTextFormat( format );
			stage.addChild( textDisplay );
			textDisplay.x = 5;
			textDisplay.y = 5;
			textDisplay.width = width - 10;
			height = textDisplay.textHeight + 10;

			draw();	
			alwaysInFront = true;
		}
		
		private function onClick(event:MouseEvent):void{
			close();
		}
		
		public function lifeTick( event : Event ) : void
		{			
			timeToLive--;
			if(timeToLive < 1)
			{
				close();
			}
		}
		
		public override function close() : void
		{
			manager.removeEventListener(NotificationDisplayManager.LIFE_TICK,lifeTick,false);
			super.close();
		}
		
		private function draw():void
		{
			var background:Sprite = new Sprite();
			with( background.graphics )
			{
				lineStyle(1);
				//beginFill(0xddffdd,.9);
				beginFill(0x1a1a1a,.9);
				drawRoundRect(2,2,width-4,height-4,8,8);
				endFill();
			}
			
			stage.addChildAt(background, 0);
		}
		
		public function animateY(endY:int):void
		{
			var dY:Number;
			var animate:Function = function(event:Event) : void
			{
				dY = (endY - y)/4
				y += dY;
				if( y <= endY)
				{
					y = endY;
					stage.removeEventListener(Event.ENTER_FRAME,animate);
				}
			}
			
			stage.addEventListener( Event.ENTER_FRAME, animate );
		}
	}
}
package com.gen6.toro.util
{
	import com.gen6.toro.view.components.MessageWindow;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	/**
	 * The DisplayManager takes a message, finds a spot to display it using the
	 * Screen API and creates a new message window. it also keeps track of the
	 * timer used to remove old messages.
	 */
	public class NotificationDisplayManager extends EventDispatcher
	{
		private var lifeTicks:uint = 0;
		private var lifeTimer:Timer = new Timer( 1000 );
		private var currentScreen:Screen;
		private const timeToLive:uint = 6;
		private const gutter:int = 10;
		
		public static const LIFE_TICK:String = "lifeTick";
		
		//Create the timer
		public function NotificationDisplayManager() : void
		{
			lifeTimer.addEventListener( TimerEvent.TIMER, addTick );
			lifeTimer.start();
		}
		
		//Create a new message window and animate its entrance
		public function displayMessage(message:String,placement : Number) : void
		{
			var messageWindow:MessageWindow = new MessageWindow(message, this);
			
			var messageWindowX : Number = 0;
			var messageWindowY : Number = 0;
			
			messageWindow.timeToLive = timeToLive;
			
			switch(placement)
			{
				case 0:
					messageWindowX = 20;
					messageWindowY = 20;
					break;
				case 1:
					messageWindowX = flash.system.Capabilities.screenResolutionX - 270;
					messageWindowY = 20;
					break;
				case 2:
					messageWindowX = (flash.system.Capabilities.screenResolutionX/2) - (messageWindow.width/2);
					messageWindowY = (flash.system.Capabilities.screenResolutionY/2) - (messageWindow.height/2);
					break;
				case 3:
					messageWindowX = 20;
					messageWindowY = flash.system.Capabilities.screenResolutionY - (messageWindow.height + 20);
					break;
				case 4:
					messageWindowX = flash.system.Capabilities.screenResolutionX - 270;
					messageWindowY = flash.system.Capabilities.screenResolutionY - (messageWindow.height + 20);
					break;
				default:
					break;
			}
			//var position:Point = findSpotForMessage(messageWindow.bounds);
			
			//messageWindow.x = position.x;
			//messageWindow.y = currentScreen.bounds.height;
			messageWindow.x = messageWindowX;
			//messageWindow.y = 20;
			messageWindow.y = 0;
			
			messageWindow.visible = true;
			//messageWindow.animateY( position.y );
			messageWindow.animateY( messageWindowY );
		}
		
		//Stop the timer when the user is away
		public function pauseExpiration():void{
			lifeTimer.stop();
		}
		
		//Start the timer when the user returns, reset the expiration of 
		//existing messages so the user has a chance to read them.
		public function resumeExpiration():void{
			lifeTimer.start();
		}
		
		//Increment the expiration timer
		private function addTick( event : Event ) : void
		{			
			lifeTicks++;
			var tickEvent:Event = new Event( LIFE_TICK, false,false );
			dispatchEvent( tickEvent );
		}
		
		//Finds a spot onscreen for a message window
		private function findSpotForMessage(size:Rectangle) : Point
		{
			var spot:Point = new Point();
			var done:Boolean = false;
			
			for each(var screen:Screen in Screen.screens)
			{
				currentScreen = screen;
				
				for(var x:int = screen.visibleBounds.x + screen.visibleBounds.width - size.width - gutter; 
						x >= screen.visibleBounds.x; 
						x -= (size.width + gutter))
				{
							
					for(var y:int = screen.visibleBounds.y + screen.visibleBounds.height - size.height - gutter;
							y >= screen.visibleBounds.y;  
							y -= 10)
					{
						var testRect:Rectangle = new Rectangle(x, y, size.width + gutter, size.height + gutter);
						
						if(!isOccupied(testRect))
						{
							spot.x = x;
							spot.y = y;
							done = true;
							break;
						}
					}
					if(done){break;}
				}
				if(done){break;}
			}
			return spot;
		}
		
		//Checks to see if any opened message windows are in a particular spot on screen
		private function isOccupied(testRect:Rectangle):Boolean{
			var occupied:Boolean = false;
			for each (var window:NativeWindow in NativeApplication.nativeApplication.openedWindows){
				occupied = occupied || window.bounds.intersects(testRect);
			}
			return occupied;
		}
	}
}
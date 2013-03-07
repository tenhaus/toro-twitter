package com.gen6.toro.view
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.ConfigurationVO;
	import com.gen6.toro.view.components.SettingsView;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SettingsMediator extends Mediator implements IMediator
	{
		public static const NAME : String = "SettingsMediator";
		
		public function SettingsMediator( viewComponent : SettingsView ) : void
		{
			super( NAME, viewComponent );
			
			settingsView.addEventListener( SettingsView.CANCEL, handleCancelSettings );
			settingsView.addEventListener( SettingsView.SAVE_SETTINGS, handleSaveSettings );
		}
		
		override public function listNotificationInterests() : Array
		{
			return( [
					ApplicationFacade.SHOW_SETTINGS,
					ApplicationFacade.GET_CONFIG_SUCCESS,
					ApplicationFacade.GET_CONFIG_FAILED,
					ApplicationFacade.SAVE_CONFIG_FAILED					
					] );
		}
		
		override public function handleNotification( notification : INotification ) : void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.SHOW_SETTINGS :
					sendNotification( ApplicationFacade.GET_CONFIG );					
					break;
				
				case ApplicationFacade.GET_CONFIG_SUCCESS :	
					settingsView.config = notification.getBody() as ConfigurationVO;
					
					break;
				
				case ApplicationFacade.GET_CONFIG_FAILED :
					settingsView.displayGetConfigFailed();
					break;
				case ApplicationFacade.SAVE_CONFIG_FAILED :
					settingsView.displaySaveConfigFailed();
					break;
					
				default :
					break;
			}
		}
		
		private function handleSaveSettings( event : Event ) : void
		{
			sendNotification( ApplicationFacade.SAVE_CONFIG, settingsView.config );			
		}
		
		private function handleCancelSettings( event : Event ) : void
		{			
			sendNotification( ApplicationFacade.CANCEL_SETTINGS );
		}
		
		public function get settingsView() : SettingsView
		{
			return( viewComponent as SettingsView );
		}
	}
}
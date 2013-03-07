package com.gen6.toro.model
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.ConfigurationVO;
	import com.gen6.toro.util.SQLiteInterface;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SQLProxy extends Proxy implements IProxy
	{
		public static const NAME : String = "SQLProxy";
		
		private var _sqlInterface : SQLiteInterface;
		
		public function get configOptions() : ConfigurationVO
		{
			return( _sqlInterface.getConfigOptions() );			
		}
		
		public function SQLProxy( data : Object = null )
		{
			super( NAME, data );
			
			_sqlInterface = new SQLiteInterface();
		}
		
		public function getConfigOptions() : void
		{
			sendNotification( ApplicationFacade.GET_CONFIG_SUCCESS, _sqlInterface.getConfigOptions() );			
		}
		
		public function saveConfigOptions( value : ConfigurationVO ) : void
		{
			if( _sqlInterface.saveConfigOptions(value) )
			{
				sendNotification( ApplicationFacade.SAVE_CONFIG_SUCCES );
			}
			else
			{
				sendNotification( ApplicationFacade.SAVE_CONFIG_FAILED );
			}
		}
	}
}
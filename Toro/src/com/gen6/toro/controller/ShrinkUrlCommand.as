package com.gen6.toro.controller
{
	import com.gen6.toro.entity.ShrinkUrlVO;
	import com.gen6.toro.model.ShrinkUrlProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ShrinkUrlCommand extends SimpleCommand
	{
		public override function execute(notification:INotification):void
		{
			var vo : ShrinkUrlVO = notification.getBody() as ShrinkUrlVO;
			var proxy : ShrinkUrlProxy = facade.retrieveProxy( ShrinkUrlProxy.NAME ) as ShrinkUrlProxy;
			
			proxy.shrinkURL( vo );			
		}
	}
}
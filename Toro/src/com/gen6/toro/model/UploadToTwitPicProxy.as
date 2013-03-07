package com.gen6.toro.model
{
	import com.gen6.toro.ApplicationFacade;
	import com.gen6.toro.entity.TwitPicVO;
	import flash.events.DataEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class UploadToTwitPicProxy extends Proxy implements IProxy
	{
		public static const NAME:String="UploadToTwitPicProxy";

		public function UploadToTwitPicProxy(data:Object=null)
		{
			super(NAME, data);
		}

		public function uploadToTwitPic(user:String, password:String, vo:TwitPicVO):void
		{

			var urlRequest:URLRequest=new URLRequest("https://twitpic.com/api/uploadAndPost");
			urlRequest.method=URLRequestMethod.POST;
			var urlVars:URLVariables=new URLVariables();
			urlVars.username=user;
			urlVars.password=password;

			vo.file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadDone);

			if (vo.description != "description ..." || vo.description != "")
			{
				urlVars.message=vo.description;
			}
			urlRequest.data=urlVars;

			try
			{
				vo.file.upload(urlRequest, 'media');
			}
			catch (error:Error)
			{
				failure();
			}
		}

		private function failure():void
		{
			sendNotification(ApplicationFacade.UPLOAD_TO_TWITPIC_FAILED);
		}

		private function uploadDone(event:DataEvent):void
		{
			var result:XML=XML(event.text);

			var reg:RegExp=new RegExp(".*?rsp status=\"ok\".*");

			if (event.text.match(reg).toString() == "<rsp status=\"ok\">")
			{
				sendNotification(ApplicationFacade.UPLOAD_TO_TWITPIC_SUCCESS);
			}
			else
			{
				failure();
			}
		}
	}
}
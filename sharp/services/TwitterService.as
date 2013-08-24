package sharp.services
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.ORedStringUtils;
	import net.ored.util.URLShortener;
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Actor;
	
	public class TwitterService extends Actor
	{
		private const __TWITTER:String = "http://twitter.com/home?status=";
		
		private var _status:String; 
		
		public function TwitterService()
		{
			super();
		}
		
		public function tweet($shareUrl:String, $status:String):void{
			Out.status(this, "tweet");
			_status = $status;
			var bitly:URLShortener = new URLShortener($shareUrl);
			bitly.addEventListener(Event.COMPLETE, _shareTwitter);
			bitly.go();

		}
		protected function _shareTwitter($e:Event):void
		{
			EventDispatcher($e.target).removeEventListener(Event.COMPLETE, _shareTwitter);
			var url:String = __TWITTER + ORedStringUtils.strEscape(_status) + ORedEvent($e).payload.shortUrl;
			Out.info(this, "_shareTwitter: "+url);
			ExternalInterface.call("window.open", url);
			
		}
	}
}
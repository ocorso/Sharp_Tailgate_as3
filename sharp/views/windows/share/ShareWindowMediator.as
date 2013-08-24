package sharp.views.windows.share
{
	import cfm.core.events.CFM_NavigationEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	import net.ored.events.ORedEvent;
	import net.ored.util.URLShortener;
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.SharpWindowEvent;
	import sharp.events.TwitterEvent;
	import sharp.model.Model;
	
	public class ShareWindowMediator extends Mediator
	{
		
		[Inject]
		public var view:ShareWindow;
		
		[Inject]
		public var _m:Model;
		
		private const __TWITTER:String = "http://twitter.com/home?status=";
		private const __FACEBOOK:String = "https://www.facebook.com/sharer.php?u=";
		
		override public function onRegister():void
		{	
			eventMap.mapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked, null, true, 0, true);
		}
		override public function onRemove():void{
			eventMap.unmapListener(view, CFM_NavigationEvent.BUTTON_CLICKED, onNavigationClicked);
		}
		// =================================================
		// ================ Callable
		// =================================================
		
		// =================================================
		// ================ Create and Build
		// =================================================
		
		// =================================================
		// ================ Workers
		// =================================================
		
		// =================================================
		// ================ Handlers
		// =================================================
		private function onNavigationClicked(e:CFM_NavigationEvent):void{
			switch(e.id){
			
				case "facebook":
					var facebookUrl:String = __FACEBOOK + shareUrl;
					ExternalInterface.call("window.open",[facebookUrl]);
					_m.ga.trackShareWindow(_m.currentPageId, _m.currentWindowId, e.id);
					break;
				case "twitter":
					_m.ga.trackShareWindow(_m.currentPageId, _m.currentWindowId, e.id);
					dispatch(new TwitterEvent(TwitterEvent.TWEET, {shareUrl:shareUrl}));
					break;
				default:
					dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW, "email", {tid:_m.tid, tailgateName:_m.submitImageParams.title}));
					_m.ga.trackShareWindow(_m.currentPageId, "share", e.id);
					break;
			}
			
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		public function get shareUrl():String{
			return _m.baseUrl + "gallery/redirect/" + _m.tid;
		}
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function ShareWindowMediator()
		{
			super();
		}
	}
}
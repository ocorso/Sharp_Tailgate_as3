package sharp.views.windows.email
{
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.events.DataResponseEvent;
	import sharp.events.SharpWindowEvent;
	import sharp.model.Model;
	
	public class EmailWindowMediator extends Mediator
	{
		[Inject]
		public var view:EmailWindow;
		
		[Inject]
		public var _m:Model;
		
		override public function onRegister():void{
			view.baseUrl = _m.baseUrl;
			eventMap.mapListener(view, DataResponseEvent.RESPONSE, onEmailResponse, null, false, 0, true);
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
		private function onEmailResponse(e:DataResponseEvent):void{
			Out.info(this, "response   " + e.body.title);
			Out.info(this, "response   " + e.body.message);
			_m.ga.track(_m.currentPageId, "", _m.currentWindowId + "_submit");
			dispatch(new SharpWindowEvent(SharpWindowEvent.OPEN_WINDOW,"response_email",{title:e.body.title,message:e.body.message,tid:_m.tid, tailgateName:_m.customizeParams.tailgateName}));
		}
		
		// =================================================
		// ================ Animation
		// =================================================
		
		// =================================================
		// ================ Getters / Setters
		// =================================================
		
		// =================================================
		// ================ Core Handler
		// =================================================
		
		// =================================================
		// ================ Overrides
		// =================================================
		
		// =================================================
		// ================ Constructor
		// =================================================

		public function EmailWindowMediator()
		{
			super();
		}
	}
}
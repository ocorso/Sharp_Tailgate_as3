package sharp.views.youtubeModule
{
	import com.greensock.TweenMax;
	
	import net.ored.util.out.Out;
	
	import org.robotlegs.mvcs.Mediator;
	
	import sharp.model.Model;
	import sharp.model.vo.Vo;
	import sharp.views.youtubeModule.event.YoutubeEvent;
	
	public class YoutubePlayerMediator extends Mediator
	{
		[Inject]
		public var view:YouTubePlayer;
		
		[Inject]
		public var _m:Model;
		
		
		override public function onRegister():void{
			eventMap.mapListener(eventDispatcher, YoutubeEvent.GET_VIDEO_ID, onGetVideoID, null, false, 0, true);
			eventMap.mapListener(view, YoutubeEvent.ON_READY, onVideoReady, null, false, 0, true);
			eventMap.mapListener(view, YoutubeEvent.ON_CHANGE, onPlayerStatusChange, null, false, 0, true);
			eventMap.mapListener(view, YoutubeEvent.CONTROL_BUTTON_CLICKED, onControlButtonClicked, null, false, 0, true);
		}
		
		override public function onRemove():void{
			eventMap.unmapListener(eventDispatcher, YoutubeEvent.GET_VIDEO_ID, onGetVideoID);
			eventMap.unmapListener(view, YoutubeEvent.ON_READY, onVideoReady);
			eventMap.unmapListener(view, YoutubeEvent.ON_CHANGE, onPlayerStatusChange);
			eventMap.unmapListener(view, YoutubeEvent.CONTROL_BUTTON_CLICKED, onControlButtonClicked);
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
		private function toPauseState():void{
			view.pauseVideo();
			view.controlButton.playIcon.visible = true;
			view.controlButton.pauseIcon.visible = false;
		}
		
		private function toPlayState():void{
			view.playVideo();
			view.controlButton.playIcon.visible = false;
			view.controlButton.pauseIcon.visible = true;
		}
		
		// =================================================
		// ================ Handlers
		// =================================================

		private function onGetVideoID(e:YoutubeEvent):void{

			view.youtubeData = _m.youtube;
			view.destroyVideo();
			view.createPlayer();
			
		}

		private function onVideoReady(e:YoutubeEvent):void{
			Out.info(this, "ready" + _m.youtube.videoId);
			
			view.buildHitArea(_m.customizeParams.tvContentWidth, _m.customizeParams.tvContentHeight);
			
			view.cueVideoById(_m.youtube.videoId);
			view.setSize(_m.customizeParams.tvContentWidth, _m.customizeParams.tvContentHeight);	
			view.buildControlButton(_m.customizeParams.tvContentWidth, _m.customizeParams.tvContentHeight);
		}
		
		private function onControlButtonClicked(e:YoutubeEvent):void{
			
			switch(view.PlayerState){
				//end
				case 0:
				//pause
				case 2:
					toPlayState();
					break
				//playing
				case 1:
					toPauseState();
					break
			}
			
		}
		
		private function onPlayerStatusChange(e:YoutubeEvent):void{
			//end
			if(view.PlayerState == 0) {
				view.showControl();
				toPauseState();
			}
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

		public function YoutubePlayerMediator()
		{
			super();
		}
	}
}